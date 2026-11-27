import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/app.dart';

void main() {
  group(NotepadColors, () {
    const other = NotepadColors(
      paperField: Color(0xFFFFFFFF),
      ruleLine: Color(0xFF000000),
      marginLine: Color(0xFF00FF00),
    );

    test('copyWith replaces only the given colours', () {
      final copy = NotepadColors.legalPad.copyWith(paperField: Colors.white);

      expect(copy.paperField, Colors.white);
      expect(copy.ruleLine, AppColors.rule);
      expect(copy.marginLine, AppColors.margin);
      expect(
        NotepadColors.legalPad.copyWith(ruleLine: Colors.black).ruleLine,
        Colors.black,
      );
      expect(
        NotepadColors.legalPad.copyWith(marginLine: Colors.green).marginLine,
        Colors.green,
      );
    });

    test('lerp blends towards the other colours', () {
      final end = NotepadColors.legalPad.lerp(other, 1);

      expect(end.paperField, other.paperField);
      expect(end.ruleLine, other.ruleLine);
      expect(end.marginLine, other.marginLine);
      expect(NotepadColors.legalPad.lerp(null, 0.5), NotepadColors.legalPad);
    });

    testWidgets('of reads the theme', (tester) async {
      late NotepadColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.legalPad(),
          home: Builder(
            builder: (context) {
              colors = NotepadColors.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(colors, NotepadColors.legalPad);
    });
  });
}
