import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(GotItBand, () {
    testWidgets('is a heading on the blue band', (tester) async {
      await tester.pumpApp(
        const Scaffold(body: GotItBand(label: 'Got it (84)')),
      );

      expect(find.text('Got it (84)'), findsOneWidget);
      expect(
        tester.getSemantics(find.text('Got it (84)')),
        isSemantics(isHeader: true, label: 'Got it (84)'),
      );
      final box = tester.widget<Container>(find.byType(Container));
      expect((box.decoration! as BoxDecoration).color, AppColors.legalPad.band);
    });

    for (final MapEntry(key: theme, value: brightness)
        in brightnessesUnderTest.entries) {
      testWidgets('meets accessibility guidelines on the $theme', (
        tester,
      ) async {
        await tester.pumpApp(
          const Scaffold(body: GotItBand(label: 'Got it (84)')),
          brightness: brightness,
        );

        await tester.expectAccessibilityGuidelines();
      });
    }
  });
}
