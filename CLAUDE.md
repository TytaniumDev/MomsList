# Mom's List

Bespoke Flutter grocery list app for one user (Tyler's mom) on an iPhone Pro
with very large system text. Accessibility at large text sizes is a
requirement, not a nice-to-have.

## Commands

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

## Conventions

- Feature-first layout: `lib/features/<feature>/`. Keep modules small and
  single-purpose; prefer extracting a reusable widget over growing a file.
- Package imports only (`package:moms_list/...`), enforced by lints.
- Never clamp or override `TextScaler`. Layouts must reflow (wrap, scroll,
  stack vertically) instead of truncating at large text sizes.
- Every screen gets a widget test that loops over `textScalesUnderTest`
  (`test/helpers/text_scales.dart`), pumps with `pumpAtTextScale`, and calls
  `expectAccessibilityGuidelines()`.
- Keep `pubspec.yaml`'s pinned `flutter:` version in sync with the SDK used.
