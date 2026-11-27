import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/app_colors.dart';
import 'package:moms_list/app/theme/app_spacing.dart';
import 'package:moms_list/app/theme/app_text_theme.dart';
import 'package:moms_list/app/theme/notepad_colors.dart';

/// The app's one theme, Legal pad, from Mom's List design system
/// (https://claude.ai/artifact/LAZBw61TibWwNXD6CKWv1G): a yellow legal pad
/// with a navy cover, Lato throughout, plain and dense.
abstract final class AppTheme {
  static ThemeData legalPad() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.cover,
      onPrimary: AppColors.onCover,
      secondary: AppColors.cover,
      onSecondary: AppColors.onCover,
      secondaryContainer: AppColors.band,
      onSecondaryContainer: AppColors.ink,
      surface: AppColors.paper,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkMuted,
      surfaceContainerHighest: AppColors.band,
      error: AppColors.error,
      onError: AppColors.onCover,
      outline: AppColors.ink,
      outlineVariant: AppColors.rule,
    );
    final textTheme = appTextTheme();
    const controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadii.sm)),
    );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: appFontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.paper,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cover,
        foregroundColor: AppColors.onCover,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.onCover,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.paperField,
        shape: controlShape,
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: controlShape,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size.square(AppSpacing.tapTarget),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: controlShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: controlShape,
          // As tall as the text boxes they sit beside.
          minimumSize: const Size.square(AppSpacing.tapTarget),
        ),
      ),
      extensions: const [NotepadColors.legalPad],
      // Keep every tappable control at least 48x48, even on web.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
