import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(PageScaffold, () {
    testWidgets('shows the title, actions and body', (tester) async {
      await tester.pumpApp(
        PageScaffold(
          title: 'Stores',
          actions: [
            IconButton(
              onPressed: () {},
              tooltip: 'Send feedback',
              icon: const Icon(Icons.feedback),
            ),
          ],
          body: const Text('Body'),
        ),
      );

      expect(find.text('Stores'), findsOneWidget);
      expect(find.byTooltip('Send feedback'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
    });

    testWidgets('drops titleDropdown down from under the header', (
      tester,
    ) async {
      await tester.pumpApp(
        PageScaffold(
          title: 'Costco',
          titleDropdown: (_) => const Text('Albertsons'),
          titleTapHint: 'Switch store',
          body: const SizedBox(),
        ),
      );

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      await tester.tap(find.text('Costco'));
      await tester.pump();

      expect(
        tester.getTopLeft(find.text('Albertsons')).dy,
        greaterThanOrEqualTo(tester.getBottomLeft(find.byType(AppBar)).dy),
      );
    });

    testWidgets('grows the header to fit a long title', (tester) async {
      await tester.pumpApp(
        const PageScaffold(
          title: 'Albertsons on Main Street by the old post office',
          body: SizedBox(),
        ),
        textScale: 3.12,
      );

      expect(tester.getSize(find.byType(AppBar)).height, greaterThan(150));
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      testWidgets('meets accessibility guidelines on the $theme', (
        tester,
      ) async {
        await tester.pumpApp(
          PageScaffold(
            title: 'Costco',
            titleDropdown: (_) => const SizedBox(),
            body: const Text('Body'),
          ),
          brightness: brightness,
        );

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
