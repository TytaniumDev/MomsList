import 'package:moms_list/l10n/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Sets up Sentry's feedback form so it is as simple as possible for Mom:
/// a single message box with our own wording, no name or email fields and
/// no Sentry branding.
///
/// The screenshot button is hidden because `FeedbackButton` attaches a
/// screenshot of the current page automatically.
void configureFeedbackForm(
  SentryFlutterOptions options,
  AppLocalizations l10n,
) {
  options.feedback
    ..title = l10n.feedbackFormTitle
    ..showName = false
    ..showEmail = false
    ..showBranding = false
    ..showCaptureScreenshot = false
    ..messageLabel = l10n.feedbackMessageLabel
    ..messagePlaceholder = l10n.feedbackMessagePlaceholder
    // Only one field is shown, so there is nothing to mark as required.
    ..isRequiredLabel = ''
    ..validationErrorLabel = l10n.feedbackValidationError
    ..submitButtonLabel = l10n.feedbackSubmitButtonLabel
    ..cancelButtonLabel = l10n.feedbackCancelButtonLabel
    ..successMessageText = l10n.feedbackSuccessMessage
    ..submitErrorMessageText = l10n.feedbackSubmitErrorMessage
    ..removeScreenshotButtonLabel = l10n.feedbackRemoveScreenshotButtonLabel;
}
