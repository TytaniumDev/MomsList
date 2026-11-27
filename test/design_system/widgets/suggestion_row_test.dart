import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SuggestionRow, () {
    Future<void> pump(
      WidgetTester tester, {
      VoidCallback? onTap,
      Brightness brightness = Brightness.light,
    }) => tester.pumpApp(
      Scaffold(
        body: Column(
          children: [
            SuggestionRow(
              name: 'Eggs',
              whereLabel: 'bought before',
              onTap: onTap ?? () {},
            ),
          ],
        ),
      ),
      brightness: brightness,
    );

    testWidgets('shows the name and where it came from', (tester) async {
      await pump(tester);

      expect(find.text('Eggs · bought before'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var taps = 0;
      await pump(tester, onTap: () => taps++);

      await tester.tap(find.byType(SuggestionRow));

      expect(taps, 1);
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      testWidgets('meets accessibility guidelines on the $theme', (
        tester,
      ) async {
        await pump(tester, brightness: brightness);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
