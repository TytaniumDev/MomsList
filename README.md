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

There is a single production build, so run it with:

```sh
$ flutter run
```

_\*Mom's List works on iOS, Android and Web._

---

## Releasing to TestFlight 🚀

Every push to `main` builds a signed iOS release and uploads it to
TestFlight's **Internal** group (`.github/workflows/release.yaml`, lanes in
`ios/fastlane/`). The build number is the workflow's run number, so it
always goes up. You can also start a release from the Actions tab with
**Run workflow**. Pull requests that touch the release setup build without
signing, so a broken build shows up before it merges.

Signing uses fastlane `match` with the shared `TytaniumDev-certificates`
repo, like Sousvite. Locally, Xcode signs automatically with the team set
in `ios/Runner.xcodeproj`.

### One-time setup

1. In App Store Connect, create the app with bundle ID
   `com.tytaniumdev.momsList`, then create a TestFlight internal group named
   `Internal` with automatic distribution turned on, and add the testers to
   it. Every uploaded build then goes to them once Apple has processed it.
2. Set the repository secrets from your Mac:

   ```sh
   $ tools/secrets/set_github_secrets.sh
   ```

   | Secret | From |
   |---|---|
   | `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_API_KEY` | The team's App Store Connect API key (`AuthKey_<key id>.p8`) |
   | `MATCH_PASSWORD`, `MATCH_SSH_PRIVATE_KEY` | The match password and the certificates repo's deploy key, from Doppler |
   | `SENTRY_AUTH_TOKEN` | A Sentry org auth token (optional, uploads debug symbols) |
   | `FIREBASE_SERVICE_ACCOUNT` | `moms-list-firebase-deploy.json`, for the web deploy (see Web app below) |

3. Create the App Store profile once, on a computer that can push to the
   certificates repo:

   ```sh
   $ cd ios
   $ BUNDLE_GEMFILE=../Gemfile bundle install
   $ BUNDLE_GEMFILE=../Gemfile bundle exec fastlane certs
   ```

   It reads the same `APP_STORE_CONNECT_*` and `MATCH_PASSWORD` values from
   the environment.

### Manual upload

To upload from a Mac instead, bump the build number in `pubspec.yaml` past
the last one on TestFlight, run `flutter build ipa`, and upload
`build/ios/ipa/*.ipa` with Apple's Transporter app.

TestFlight builds expire after 90 days, so make sure something merges at
least that often.

---

## Web app 🌐

Every push to `main` builds the web app and deploys it to Firebase Hosting
at **https://moms-list-app.web.app**, together with the Firestore security
rules in `firestore.rules` (`.github/workflows/deploy_web.yaml`, mirrored
from Sousvite). Mom signs in with the same Google account as on her
iPhone, so she sees the same list. You can also deploy from the Actions tab
with **Run workflow**.

### One-time setup

The deploy needs a service account key for the `moms-list-app` Firebase
project. Until it is set, the workflow builds the app and skips the deploy
with a warning.

1. In the [Firebase console](https://console.firebase.google.com/project/moms-list-app/firestore),
   create the Firestore database in **production mode** (its rules deny
   everything until the workflow deploys `firestore.rules`). Pick a
   location near you; it can't be changed later.
2. In [Google Cloud → IAM → Service accounts](https://console.cloud.google.com/iam-admin/serviceaccounts?project=moms-list-app),
   create `github-deploy` with the roles **Firebase Hosting Admin**,
   **Firebase Rules Admin**, **API Keys Viewer** and **Cloud Run Viewer**.
3. On its **Keys** tab, add a JSON key and save it as
   `~/Sousvite-secrets/moms-list-firebase-deploy.json`.
4. Run `tools/secrets/set_github_secrets.sh`, which sets
   `FIREBASE_SERVICE_ACCOUNT` from that file.

To try it locally instead, run `flutter run -d chrome`. Google sign-in works
on `localhost`, which Firebase Auth allows by default.

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
