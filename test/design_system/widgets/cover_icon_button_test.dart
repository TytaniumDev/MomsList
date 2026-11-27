import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(CoverIconButton, () {
    Future<void> pump(
      WidgetTester tester, {
      VoidCallback? onPressed,
      double textScale = 1,
      Brightness brightness = Brightness.light,
    }) => tester.pumpApp(
      Scaffold(
        body: Center(
          child: CoverIconButton(
            icon: Icons.add,
            tooltip: 'Add',
            onPressed: onPressed ?? () {},
          ),
        ),
      ),
      textScale: textScale,
      brightness: brightness,
    );

    testWidgets('calls onPressed when tapped', (tester) async {
      var presses = 0;
      await pump(tester, onPressed: () => presses++);

      await tester.tap(find.byTooltip('Add'));

      expect(presses, 1);
    });

    testWidgets('is navy in both themes', (tester) async {
      for (final brightness in brightnessesUnderTest.values) {
        await pump(tester, brightness: brightness);

        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(IconButton),
            matching: find.byType(Material),
          ),
        );
        expect(material.color, AppColors.legalPad.cover);
      }
    });

    testWidgets('grows its icon with the text', (tester) async {
      await pump(tester, textScale: 2);

      expect(tester.getSize(find.byIcon(Icons.add)).width, 48);
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
