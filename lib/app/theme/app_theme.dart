import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/app_colors.dart';
import 'package:moms_list/app/theme/app_spacing.dart';
import 'package:moms_list/app/theme/app_text_theme.dart';
import 'package:moms_list/app/theme/notepad_colors.dart';

/// The app's themes from Mom's List design system
/// (https://claude.ai/artifact/LAZBw61TibWwNXD6CKWv1G): a pad with a navy
/// cover, Lato throughout, plain and dense. [legalPad] is yellow for light
/// mode and [blackPad] is black for dark mode.
abstract final class AppTheme {
  /// Light mode: the yellow legal pad.
  static ThemeData legalPad() => _pad(AppColors.legalPad, Brightness.light);

  /// Dark mode: the black pad.
  static ThemeData blackPad() => _pad(AppColors.blackPad, Brightness.dark);

  static ThemeData _pad(AppColors colors, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      // Blue text and marks on the paper. The navy cover is set directly on
      // the app bar and filled buttons, since navy on black is 1.5:1.
      primary: colors.accent,
      onPrimary: colors.paper,
      secondary: colors.accent,
      onSecondary: colors.paper,
      secondaryContainer: colors.band,
      onSecondaryContainer: colors.ink,
      surface: colors.paper,
      onSurface: colors.ink,
      onSurfaceVariant: colors.inkMuted,
      surfaceContainerHighest: colors.band,
      error: colors.error,
      onError: colors.paper,
      outline: colors.ink,
      outlineVariant: colors.rule,
    );
    final textTheme = appTextTheme(color: colors.ink);
    const controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadii.sm)),
    );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: appFontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.paper,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.cover,
        foregroundColor: colors.onCover,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: colors.onCover),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.paperField,
        shape: controlShape,
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.cover,
          foregroundColor: colors.onCover,
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
      extensions: [NotepadColors.from(colors)],
      // Keep every tappable control at least 48x48, even on web.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
