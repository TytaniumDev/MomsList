#!/usr/bin/env bash
# Sets the GitHub Actions secrets that the TestFlight release workflow
# (.github/workflows/release.yaml) reads. Mirrored from Sousvite's script.
#
# Run it on your own computer. Secret values go straight from files or
# hidden prompts to GitHub. They are never printed, and nothing is written
# to the repository.
#
# Usage:
#   tools/secrets/set_github_secrets.sh [secrets-folder]
#
# The secrets folder defaults to ~/Sousvite-secrets, because the App Store
# Connect API key is shared by every app on the team. It should hold one
# AuthKey_<KEY ID>.p8 file.
#
# Requirements: the GitHub CLI (`brew install gh`, then `gh auth login`) and,
# for the match secrets, the Doppler CLI signed in (otherwise you are asked).

set -euo pipefail

readonly REPO="TytaniumDev/MomsList"
readonly DIR="${1:-$HOME/Sousvite-secrets}"

say() { printf '%s\n' "$*"; }

# Reads a secret from stdin and stores it under the given name.
set_secret() {
  gh secret set "$1" --repo "$REPO" >/dev/null
  say "  set $1"
}

# True when the secret already exists in the repository.
has_secret() {
  gh secret list --repo "$REPO" | grep -q "^$1[[:space:]]"
}

check_gh() {
  if ! command -v gh >/dev/null 2>&1; then
    say "The GitHub CLI is missing. Install it with: brew install gh" >&2
    exit 1
  fi
  if ! gh auth status >/dev/null 2>&1; then
    say "Sign in to GitHub first with: gh auth login" >&2
    exit 1
  fi
}

app_store_connect_key() {
  local keys=("$DIR"/AuthKey_*.p8)
  if [[ ! -f "${keys[0]}" ]]; then
    say "App Store Connect: no AuthKey_*.p8 in $DIR, skipped."
    return
  fi
  if ((${#keys[@]} > 1)); then
    say "App Store Connect: more than one AuthKey_*.p8 in $DIR. Keep only the current one." >&2
    exit 1
  fi
  local key_file="${keys[0]}"
  local key_id
  key_id="$(basename "$key_file" .p8)"
  key_id="${key_id#AuthKey_}"

  local issuer_id
  read -r -p "App Store Connect Issuer ID (shown above the keys table): " issuer_id
  if [[ -z "$issuer_id" ]]; then
    say "App Store Connect: no Issuer ID given, skipped."
    return
  fi

  say "App Store Connect API key:"
  printf '%s' "$key_id" | set_secret APP_STORE_CONNECT_KEY_ID
  printf '%s' "$issuer_id" | set_secret APP_STORE_CONNECT_ISSUER_ID
  set_secret APP_STORE_CONNECT_API_KEY <"$key_file"
}

# iOS signing reuses the match certificates repo that Tyler's other apps
# share. Its password and deploy key are in Doppler (project blinkbreak,
# config prd), so they are copied from there when the Doppler CLI is signed
# in, and the password is asked for at a hidden prompt otherwise.
match_secrets() {
  local name value
  say "iOS signing (fastlane match):"
  for name in MATCH_PASSWORD MATCH_SSH_PRIVATE_KEY; do
    if has_secret "$name"; then
      say "  $name: already set, kept."
      continue
    fi
    value=""
    if command -v doppler >/dev/null 2>&1; then
      value="$(doppler secrets get "$name" --plain --project blinkbreak --config prd 2>/dev/null || true)"
    fi
    if [[ -z "$value" && "$name" == MATCH_PASSWORD ]]; then
      read -r -s -p "  match password (input hidden, Enter to skip): " value
      say ""
    fi
    if [[ -z "$value" ]]; then
      say "  $name: not found, skipped."
      continue
    fi
    # An SSH key needs its final newline, which $(...) strips.
    if [[ "$name" == MATCH_SSH_PRIVATE_KEY ]]; then
      printf '%s\n' "$value" | set_secret "$name"
    else
      printf '%s' "$value" | set_secret "$name"
    fi
  done
}

sentry_token() {
  if has_secret SENTRY_AUTH_TOKEN; then
    say "SENTRY_AUTH_TOKEN: already set, kept."
    return
  fi
  local token
  read -r -s -p "Sentry auth token (input hidden, Enter to skip): " token
  say ""
  if [[ -z "$token" ]]; then
    say "SENTRY_AUTH_TOKEN: skipped."
    return
  fi
  printf '%s' "$token" | set_secret SENTRY_AUTH_TOKEN
}

main() {
  check_gh
  say "Secrets folder: $DIR"
  say "Repository: $REPO"
  say ""

  app_store_connect_key
  match_secrets
  sentry_token
}

main
