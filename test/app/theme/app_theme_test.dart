import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/app.dart';

void main() {
  group(AppTheme, () {
    final theme = AppTheme.legalPad();

    test('is a yellow legal pad with a navy cover', () {
      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, AppColors.paper);
      expect(theme.colorScheme.surface, AppColors.paper);
      expect(theme.colorScheme.onSurface, AppColors.ink);
      expect(theme.appBarTheme.backgroundColor, AppColors.cover);
      expect(theme.appBarTheme.foregroundColor, AppColors.onCover);
      expect(theme.extension<NotepadColors>(), NotepadColors.legalPad);
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
}
