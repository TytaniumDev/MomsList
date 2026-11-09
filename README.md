# Mom's List

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A bespoke grocery list app built for one very particular user: Mom.

She uses an iPhone with the system text size turned up a lot, so every page is
designed and tested to work at the largest iOS Dynamic Type sizes.

Built on the [Very Good Core][very_good_core_link] template from
[Very Good CLI][very_good_cli_link].

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

On web, flavors are not supported, so pass only the target:

```sh
$ flutter run -d chrome --target lib/main_development.dart
```

_\*Mom's List works on iOS, Android and Web._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

CI requires 100% coverage. To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Accessibility ♿

- Text scaling is never clamped; the app follows the system text size.
- High-contrast themes are used automatically when "Increase Contrast" is on.
- `test/helpers/` pumps pages on an iPhone Pro sized screen at every scale in
  `textScalesUnderTest`, from the default size up to AX5 (about 3.1x), and
  `expectAccessibilityGuidelines()` checks tap target size, labels and text
  contrast. Every page test should use both.

---

## Working with Translations 🌐

This project follows the [official internationalization guide for Flutter][internationalization_link] using [ARB files][arb_documentation_link]. English is the only locale today, but all user-facing strings still go through `context.l10n`.

### Adding Strings

1. Open `lib/l10n/arb/app_en.arb` and add a new key/value pair with a description:

```arb
{
    "@@locale": "en",
    "homeWelcome": "Welcome!",
    "@homeWelcome": {
        "description": "Heading on the home page"
    }
}
```

2. Use the new string:

```dart
import 'package:moms_list/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.homeWelcome);
}
```

### Generating Translations

```sh
flutter gen-l10n
```

Alternatively, run `flutter run` and code generation will take place automatically.

[internationalization_link]: https://docs.flutter.dev/ui/internationalization
[arb_documentation_link]: https://github.com/google/app-resource-bundle
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_core_link]: https://cli.vgv.dev/docs/templates/core
