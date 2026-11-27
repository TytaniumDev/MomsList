import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

void main() {
  group(NotepadColors, () {
    final legalPad = NotepadColors.from(AppColors.legalPad);
    const other = NotepadColors(
      paperField: Color(0xFFFFFFFF),
      ruleLine: Color(0xFF000000),
      marginLine: Color(0xFF00FF00),
      cover: Color(0xFF0000FF),
      onCover: Color(0xFFFF0000),
    );

    test('from takes the palette colours', () {
      expect(legalPad.paperField, AppColors.legalPad.paperField);
      expect(legalPad.ruleLine, AppColors.legalPad.rule);
      expect(legalPad.marginLine, AppColors.legalPad.margin);
      expect(legalPad.cover, AppColors.legalPad.cover);
      expect(legalPad.onCover, AppColors.legalPad.onCover);
    });

    test('copyWith replaces only the given colours', () {
      expect(legalPad.copyWith(), legalPad);
      expect(
        legalPad.copyWith(
          paperField: other.paperField,
          ruleLine: other.ruleLine,
          marginLine: other.marginLine,
          cover: other.cover,
          onCover: other.onCover,
        ),
        other,
      );
    });

    test('lerp blends towards the other colours', () {
      expect(legalPad.lerp(other, 1), other);
      expect(legalPad.lerp(other, 0), legalPad);
      expect(legalPad.lerp(null, 0.5), legalPad);
    });

    test('compares by value', () {
      expect(legalPad, NotepadColors.from(AppColors.legalPad));
      expect(
        legalPad.hashCode,
        NotepadColors.from(AppColors.legalPad).hashCode,
      );
      expect(legalPad, isNot(NotepadColors.from(AppColors.blackPad)));
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

      expect(colors, legalPad);
    });
  });
}
