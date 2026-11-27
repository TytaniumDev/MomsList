import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/app.dart';
import 'package:moms_list/features/grocery/presentation/margin_line.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(MarginLine, () {
    testWidgets('paints the red margin line over its child', (tester) async {
      await tester.pumpApp(const MarginLine(child: SizedBox.expand()));

      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(MarginLine),
          matching: find.byType(CustomPaint),
        ),
      );
      final painter = paint.foregroundPainter! as MarginLinePainter;
      expect(painter.color, AppColors.legalPad.margin);
      expect(
        find.byType(MarginLine),
        paints..rect(rect: const Rect.fromLTWH(12, 0, 2, 874)),
      );
    });

    test('repaints only when the colour changes', () {
      final red = MarginLinePainter(color: AppColors.legalPad.margin);

      expect(
        red.shouldRepaint(MarginLinePainter(color: AppColors.legalPad.margin)),
        isFalse,
      );
      expect(
        red.shouldRepaint(MarginLinePainter(color: AppColors.legalPad.rule)),
        isTrue,
      );
    });
  });
}
