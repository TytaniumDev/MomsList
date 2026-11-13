import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/feedback/feedback.dart';
import 'package:moms_list/l10n/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../helpers/helpers.dart';

void main() {
  group(FeedbackButton, () {
    setUp(() async {
      // A real (but unreachable) DSN is needed: an empty one disables
      // Sentry, and the feedback form requires an enabled Flutter hub.
      await SentryFlutter.init((options) {
        options
          ..dsn = 'https://public@sentry.invalid/1'
          ..autoInitializeNativeSdk = false;
        configureFeedbackForm(
          options,
          lookupAppLocalizations(const Locale('en')),
        );
      });
    });

    tearDown(Sentry.close);

    Widget buildSubject() =>
        Scaffold(appBar: AppBar(actions: const [FeedbackButton()]));

    testWidgets('opens the feedback form when tapped', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(FeedbackButton));
      await tester.pumpAndSettle();

      expect(find.byType(SentryFeedbackForm), findsOneWidget);
      expect(find.text('Feedback'), findsOneWidget);
    });

    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets('feedback form meets accessibility guidelines at $name '
          'text size', (tester) async {
        await tester.pumpApp(buildSubject(), textScale: scale);

        await tester.tap(find.byType(FeedbackButton));
        await tester.pumpAndSettle();

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
