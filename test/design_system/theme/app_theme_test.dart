import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';

void main() {
  group(AppTheme, () {
    group('legalPad', () {
      final theme = AppTheme.legalPad();

      test('is a yellow legal pad with a navy cover', () {
        const colors = AppColors.legalPad;

        expect(theme.colorScheme.brightness, Brightness.light);
        expect(theme.scaffoldBackgroundColor, colors.paper);
        expect(theme.colorScheme.surface, colors.paper);
        expect(theme.colorScheme.onSurface, colors.ink);
        expect(theme.colorScheme.primary, colors.accent);
        expect(theme.appBarTheme.backgroundColor, colors.cover);
        expect(theme.appBarTheme.foregroundColor, colors.onCover);
        expect(theme.textTheme.bodyLarge?.color, colors.ink);
        expect(theme.extension<NotepadColors>(), NotepadColors.from(colors));
      });

      test('uses Lato at the sizes Mom reads in her old app', () {
        final text = theme.textTheme;

        expect(text.bodyLarge?.fontFamily, 'Lato');
        expect(text.bodyLarge?.fontSize, 18);
        expect(text.bodyLarge?.fontWeight, FontWeight.w400);
        expect(text.titleLarge?.fontSize, 20);
        expect(text.titleLarge?.fontWeight, FontWeight.w900);
        expect(text.titleSmall?.fontSize, 17);
        expect(text.labelLarge?.fontWeight, FontWeight.w700);
        expect(text.bodyMedium?.fontSize, 15);
        expect(text.bodyLarge!.fontSize! * text.bodyLarge!.height!, 24);
      });

      test('keeps tap targets padded to the minimum size', () {
        expect(theme.materialTapTargetSize, MaterialTapTargetSize.padded);
      });
    });

    group('blackPad', () {
      final theme = AppTheme.blackPad();

      test('is a black pad with the same navy cover', () {
        const colors = AppColors.blackPad;

        expect(theme.colorScheme.brightness, Brightness.dark);
        expect(theme.scaffoldBackgroundColor, colors.paper);
        expect(theme.colorScheme.onSurface, colors.ink);
        expect(theme.colorScheme.primary, colors.accent);
        expect(theme.appBarTheme.backgroundColor, AppColors.legalPad.cover);
        expect(theme.textTheme.bodyLarge?.color, colors.ink);
        expect(theme.extension<NotepadColors>(), NotepadColors.from(colors));
      });

      test('uses the same type as legalPad', () {
        expect(
          theme.textTheme.bodyLarge?.fontSize,
          AppTheme.legalPad().textTheme.bodyLarge?.fontSize,
        );
      });
    });
  });
}
