import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/app.dart';

void main() {
  group(AppTheme, () {
    test('light theme has light brightness', () {
      expect(AppTheme.light().colorScheme.brightness, Brightness.light);
    });

    test('dark theme has dark brightness', () {
      expect(AppTheme.dark().colorScheme.brightness, Brightness.dark);
    });

    test('high contrast changes the color scheme', () {
      expect(
        AppTheme.light(highContrast: true).colorScheme.primary,
        isNot(AppTheme.light().colorScheme.primary),
      );
    });

    test('keeps tap targets padded to the minimum size', () {
      expect(
        AppTheme.light().materialTapTargetSize,
        MaterialTapTargetSize.padded,
      );
    });
  });
}
