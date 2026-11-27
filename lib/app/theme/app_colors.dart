import 'package:material_ui/material_ui.dart';

/// The Legal pad palette from Mom's List design system. Every text pair is
/// at least 7:1.
///
/// Features read these through the theme (`ColorScheme` and
/// `NotepadColors`), not directly.
abstract final class AppColors {
  /// Page background: the yellow legal pad sheet.
  static const paper = Color(0xFFFFF4A8);

  /// Text fields, dialogs and menus: a lighter sheet on top of [paper].
  static const paperField = Color(0xFFFFFBE0);

  /// All main text and icons, heavy rules and field borders.
  static const ink = Color(0xFF1A1A1A);

  /// Checked-off items, hints and counts. Never for anything to act on.
  static const inkMuted = Color(0xFF4D4527);

  /// Navy notepad cover: the header, primary buttons and selected marks.
  static const cover = Color(0xFF1D3557);

  /// Text and icons on [cover].
  static const onCover = Color(0xFFFFFFFF);

  /// The blue rule under each row. Decorative only.
  static const rule = Color(0xFF7FA7D1);

  /// The red margin line down the left of a list. Decorative only.
  static const margin = Color(0xFFC2362F);

  /// Section headings (Got it) and the current store in the picker.
  static const band = Color(0xFFDCE6F2);

  /// Error text and destructive buttons.
  static const error = Color(0xFF9B1C1C);
}
