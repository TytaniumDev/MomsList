import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(StoreRow, () {
    Future<void> pump(
      WidgetTester tester, {
      bool selected = false,
      VoidCallback? onTap,
      Brightness brightness = Brightness.light,
    }) => tester.pumpApp(
      Scaffold(
        body: Column(
          children: [
            StoreRow(
              name: 'Costco',
              countLabel: '3 to get',
              selected: selected,
              onTap: onTap ?? () {},
            ),
          ],
        ),
      ),
      brightness: brightness,
    );

    testWidgets('shows the name and count', (tester) async {
      await pump(tester);

      expect(find.text('Costco'), findsOneWidget);
      expect(find.text('3 to get'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('ticks and highlights the selected store', (tester) async {
      await pump(tester, selected: true);

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(StoreRow)),
        isSemantics(hasSelectedState: true, isSelected: true),
      );
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var taps = 0;
      await pump(tester, onTap: () => taps++);

      await tester.tap(find.text('Costco'));

      expect(taps, 1);
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      testWidgets('meets accessibility guidelines on the $theme', (
        tester,
      ) async {
        await pump(tester, selected: true, brightness: brightness);

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
