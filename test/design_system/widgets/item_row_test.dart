import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ItemRow, () {
    Future<void> pump(
      WidgetTester tester, {
      bool checked = false,
      VoidCallback? onTap,
      VoidCallback? onLongPress,
      Brightness brightness = Brightness.light,
    }) => tester.pumpApp(
      Scaffold(
        body: Column(
          children: [
            ItemRow(
              name: 'Eggs',
              checked: checked,
              onTap: onTap ?? () {},
              onLongPress: onLongPress,
            ),
          ],
        ),
      ),
      brightness: brightness,
    );

    testWidgets('shows an item to get in plain ink', (tester) async {
      await pump(tester);

      final text = tester.widget<Text>(find.text('Eggs'));
      expect(text.style?.decoration, isNot(TextDecoration.lineThrough));
      expect(text.style?.fontWeight, FontWeight.w400);
      expect(
        tester.getSemantics(find.byType(ItemRow)),
        isSemantics(hasCheckedState: true, isChecked: false),
      );
    });

    testWidgets('crosses out a checked item in muted ink', (tester) async {
      await pump(tester, checked: true);

      final text = tester.widget<Text>(find.text('Eggs'));
      expect(text.style?.decoration, TextDecoration.lineThrough);
      expect(text.style?.color, AppColors.legalPad.inkMuted);
      expect(
        tester.getSemantics(find.byType(ItemRow)),
        isSemantics(hasCheckedState: true, isChecked: true),
      );
    });

    testWidgets('calls onTap and onLongPress', (tester) async {
      var taps = 0;
      var holds = 0;
      await pump(tester, onTap: () => taps++, onLongPress: () => holds++);

      await tester.tap(find.text('Eggs'));
      await tester.longPress(find.text('Eggs'));

      expect(taps, 1);
      expect(holds, 1);
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      for (final checked in [false, true]) {
        testWidgets('meets accessibility guidelines on the $theme '
            '(checked: $checked)', (tester) async {
          await pump(tester, checked: checked, brightness: brightness);

          await tester.expectAccessibilityGuidelines();
        });
      }
    }
  });
}
