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
- `very_good test --coverage --test-randomize-ordering-seed random`
  (CI requires 100% coverage)
- Run: `flutter run` (single production build, no flavors)

## Conventions

- Feature-first layout: `lib/<feature>/` with `view/` (and later state)
  folders and a `<feature>.dart` barrel file. Tests mirror `lib/`.
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
  `lib/feedback/`) in its `actions`, so Mom can always send feedback. It opens
  Sentry's feedback form with a screenshot of the page attached.
- No IDE folders (`.idea/`, `.vscode/`) and no build flavors: there is one
  production build from `lib/main.dart`.
- State management has not been chosen yet (likely Riverpod or plain
  `ChangeNotifier`). Ask before adding one.
- PR titles follow Conventional Commits (`feat:`, `fix:`, `chore:` ...);
  CI checks this.
