# Mom's List

Bespoke Flutter grocery list app for one user (Tyler's mom) on an iPhone Pro
with very large system text. Accessibility at large text sizes is a
requirement, not a nice-to-have.

The codebase follows Very Good Ventures conventions (Very Good Core template,
`very_good_analysis`, `very_good_workflows`). When in doubt, do what a
`very_good create` project would do.

## Commands

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `dart run build_runner build` after changing a `@riverpod` provider
  (generated `*.g.dart` files are committed)
- `very_good test --coverage --exclude-coverage "**/*.g.dart"
  --test-randomize-ordering-seed random` (CI requires 100% coverage)
- Run: `flutter run` (single production build, no flavors)

## Conventions

- Architecture mirrors Sousvite (TytaniumDev/Sousvite, docs/ENGINEERING.md
  §4 to §6), scaled down to one app with no packages:
  - Features are folders: `lib/features/<name>/` with `presentation/`,
    `application/` (providers and notifiers) and `data/` when needed.
  - A feature's public surface is one file, `lib/features/<name>/<name>.dart`.
    Other features import only that file.
  - External services sit behind interfaces in `lib/app/services/`, with a
    stub implementation for builds without config (`SignedOutAuthService`).
  - Tests mirror `lib/`.
- Import `package:material_ui/material_ui.dart` rather than
  `package:flutter/material.dart`, like the template.
- All user-facing strings go in `lib/l10n/arb/app_en.arb` and are read with
  `context.l10n`.
- Keep modules small and single-purpose; prefer extracting a reusable widget
  over growing a file.
- Never clamp or override `TextScaler`. Layouts must reflow (wrap, scroll,
  stack vertically) instead of truncating at large text sizes.
- Every page gets a widget test that loops over `textScalesUnderTest`, pumps
  with `pumpApp(..., textScale: scale)` and calls
  `expectAccessibilityGuidelines()` (all from `test/helpers/helpers.dart`).
- Every page's `AppBar` includes `FeedbackButton()` (from
  `lib/features/feedback/`) in its `actions`, so Mom can always send feedback. It opens
  Sentry's feedback form with a screenshot of the page attached.
- No IDE folders (`.idea/`, `.vscode/`) and no build flavors: there is one
  production build from `lib/main.dart`.
- State management is Riverpod 3 with code generation only (`@riverpod`,
  `@Riverpod(keepAlive: true)` for app-wide state such as auth). `ref.watch`
  in `build`, `ref.read` in callbacks. Riverpod is the only DI. Tests
  override providers through `pumpApp(..., overrides: [...])`.
- Sign-in is Google only, through Firebase Auth (project `moms-list-app`).
  Sync will use Firestore. `lib/firebase_options.dart` has the iOS and web
  config; other platforms get null and run signed out.
- PR titles follow Conventional Commits (`feat:`, `fix:`, `chore:` ...);
  CI checks this.
