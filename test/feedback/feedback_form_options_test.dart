import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/feedback/feedback.dart';
import 'package:moms_list/l10n/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  group('configureFeedbackForm', () {
    late SentryFlutterOptions options;
    late AppLocalizations l10n;

    setUp(() {
      options = SentryFlutterOptions();
      l10n = lookupAppLocalizations(const Locale('en'));
      configureFeedbackForm(options, l10n);
    });

    test('only shows the message box', () {
      expect(options.feedback.showName, isFalse);
      expect(options.feedback.showEmail, isFalse);
      expect(options.feedback.showBranding, isFalse);
      expect(options.feedback.showCaptureScreenshot, isFalse);
      expect(options.feedback.isRequiredLabel, isEmpty);
    });

    test('uses the app strings', () {
      expect(options.feedback.title, l10n.feedbackFormTitle);
      expect(options.feedback.messageLabel, l10n.feedbackMessageLabel);
      expect(
        options.feedback.messagePlaceholder,
        l10n.feedbackMessagePlaceholder,
      );
      expect(
        options.feedback.validationErrorLabel,
        l10n.feedbackValidationError,
      );
      expect(
        options.feedback.submitButtonLabel,
        l10n.feedbackSubmitButtonLabel,
      );
      expect(
        options.feedback.cancelButtonLabel,
        l10n.feedbackCancelButtonLabel,
      );
      expect(options.feedback.successMessageText, l10n.feedbackSuccessMessage);
      expect(
        options.feedback.submitErrorMessageText,
        l10n.feedbackSubmitErrorMessage,
      );
      expect(
        options.feedback.removeScreenshotButtonLabel,
        l10n.feedbackRemoveScreenshotButtonLabel,
      );
    });
  });
}
