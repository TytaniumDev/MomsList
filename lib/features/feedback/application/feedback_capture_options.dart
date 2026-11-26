import 'package:sentry_flutter/sentry_flutter.dart';

/// Sets up what Sentry captures alongside feedback and errors.
///
/// The app holds nothing private (it is a grocery list), so screenshots are
/// sent unmasked and Sentry may attach default user and device details. This
/// lets feedback screenshots show exactly what Mom was looking at.
void configureFeedbackCapture(SentryFlutterOptions options) {
  options
    // Lets errors and feedback include a screenshot of the page.
    ..attachScreenshot = true
    ..sendDefaultPii = true;
  options.privacy
    ..maskAllText = false
    ..maskAllImages = false;
}
