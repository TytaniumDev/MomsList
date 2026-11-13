import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/feedback/feedback.dart';
import 'package:moms_list/home/home.dart';

import '../../helpers/helpers.dart';

void main() {
  group(HomePage, () {
    testWidgets('renders the empty lists message', (tester) async {
      await tester.pumpApp(const HomePage());

      expect(
        find.text('Your grocery lists will show up here.'),
        findsOneWidget,
      );
    });

    testWidgets('shows the feedback button in the app bar', (tester) async {
      await tester.pumpApp(const HomePage());

      expect(find.byType(FeedbackButton), findsOneWidget);
    });

    for (final MapEntry(key: name, value: scale)
        in textScalesUnderTest.entries) {
      testWidgets('meets accessibility guidelines at $name text size', (
        tester,
      ) async {
        await tester.pumpApp(const HomePage(), textScale: scale);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
