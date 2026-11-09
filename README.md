# Mom's List

A bespoke grocery list app built for one very particular user: Mom.

She uses an iPhone with the system text size turned up a lot, so every screen
is designed and tested to work at the largest iOS Dynamic Type sizes.

## Getting started

Requires Flutter **3.47.9** (pinned in `pubspec.yaml`).

```sh
flutter pub get
flutter run
```

## Checks

These are the same checks CI runs on every pull request:

```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Project layout

```
lib/
  main.dart            Entry point, nothing else
  app.dart             Root MaterialApp and theme wiring
  theme/               ThemeData builders
  features/<feature>/  One folder per feature (screens, widgets, state)
test/
  helpers/             Shared test helpers (large-text pumping, a11y checks)
```

## Accessibility

- Text scaling is never clamped; the app follows the system text size.
- High-contrast themes are used automatically when "Increase Contrast" is on.
- `test/helpers/pump_app.dart` renders widgets on an iPhone Pro sized screen
  at text scales from default up to AX5 (about 3.1x). Use it in every screen
  test along with `expectAccessibilityGuidelines()`.

## License

[MIT](LICENSE)
