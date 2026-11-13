import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:moms_list/feedback/feedback.dart';
import 'package:moms_list/l10n/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Client key for the `moms-list` Sentry project. DSNs only allow sending
/// events, so they are safe to ship inside the app.
const _sentryDsn =
    'https://3511a15cdc32727186aaffad415cce6a@o4510951154712576.ingest.us.sentry.io/4512422683475968';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await SentryFlutter.init(
    (options) {
      options
        ..dsn = _sentryDsn
        // Lets errors and feedback include a screenshot of the page.
        ..attachScreenshot = true;
      // The app is English only, so the form can be localized before the
      // widget tree (and its BuildContext) exists.
      configureFeedbackForm(
        options,
        lookupAppLocalizations(const Locale('en')),
      );
    },
    // SentryWidget is what makes screenshots possible.
    appRunner: () async => runApp(SentryWidget(child: await builder())),
  );
}
