import 'package:flutter/material.dart';

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

    return ThemeData(
      colorScheme: colorScheme,
      // Keep every tappable control at least 48x48, even on desktop/web.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
