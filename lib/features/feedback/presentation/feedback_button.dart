import 'package:material_ui/material_ui.dart';
import 'package:moms_list/l10n/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// App bar action that opens Sentry's feedback form.
///
/// A screenshot of the current page is attached automatically, so Mom only
/// has to type what she wants changed. Add this to the `actions` of every
/// page's [AppBar].
class FeedbackButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.feedback_outlined),
      tooltip: context.l10n.feedbackButtonTooltip,
      onPressed: () => _showFeedbackForm(context),
    );
  }

  Future<void> _showFeedbackForm(BuildContext context) async {
    final screenshot = await SentryFlutter.captureScreenshot();
    if (!context.mounted) return;
    SentryFeedbackForm.show(context, screenshot: screenshot);
  }
}
