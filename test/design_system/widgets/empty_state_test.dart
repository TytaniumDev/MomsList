import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(EmptyState, () {
    Future<void> pump(
      WidgetTester tester, {
      bool isError = false,
      Brightness brightness = Brightness.light,
    }) => tester.pumpApp(
      Scaffold(
        body: EmptyState(message: 'Nothing to get', isError: isError),
      ),
      brightness: brightness,
    );

    testWidgets('shows the message in ink', (tester) async {
      await pump(tester);

      final text = tester.widget<Text>(find.text('Nothing to get'));
      expect(text.style?.color, AppColors.legalPad.ink);
    });

    testWidgets('shows an error in the error colour', (tester) async {
      await pump(tester, isError: true);

      final text = tester.widget<Text>(find.text('Nothing to get'));
      expect(text.style?.color, AppColors.legalPad.error);
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      for (final isError in [false, true]) {
        testWidgets(
          'meets accessibility guidelines on the $theme (error: $isError)',
          (tester) async {
            await pump(tester, isError: isError, brightness: brightness);

            await tester.expectAccessibilityGuidelines();
          },
        );
      }
    }
  });
}
