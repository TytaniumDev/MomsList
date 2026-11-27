import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(RuledRow, () {
    testWidgets('is at least 48 tall and tappable', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        Scaffold(
          body: Column(
            children: [
              RuledRow(onTap: () => taps++, child: const Text('Eggs')),
            ],
          ),
        ),
      );

      expect(tester.getSize(find.byType(RuledRow)).height, 48);
      await tester.tap(find.text('Eggs'));
      expect(taps, 1);
    });

    testWidgets('grows with large text', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: Column(children: [RuledRow(child: Text('Eggs'))]),
        ),
        textScale: 3.12,
      );

      expect(tester.getSize(find.byType(RuledRow)).height, greaterThan(48));
    });
  });
}
