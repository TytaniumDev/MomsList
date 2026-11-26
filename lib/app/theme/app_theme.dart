import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/notepad_colors.dart';

/// Builds the app's [ThemeData] variants from a single seed colour.
///
/// High-contrast variants are used automatically when the device has
/// "Increase Contrast" turned on.
abstract final class AppTheme {
  static const Color _seedColor = Color(0xFF2E7D32);

  static ThemeData light({bool highContrast = false}) =>
      _build(Brightness.light, highContrast: highContrast);

  static ThemeData dark({bool highContrast = false}) =>
      _build(Brightness.dark, highContrast: highContrast);

  static ThemeData _build(Brightness brightness, {required bool highContrast}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
      contrastLevel: highContrast ? 1 : 0,
    );
    final notepad = brightness == Brightness.light
        ? NotepadColors.light
        : NotepadColors.dark;
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: notepad.paper,
      // A solid green header, like the cover of Mom's notepad.
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      extensions: [notepad],
      // Keep every tappable control at least 48x48, even on web.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
