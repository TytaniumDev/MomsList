import 'package:material_ui/material_ui.dart';

/// A palette from Mom's List design system
/// (https://claude.ai/artifact/LAZBw61TibWwNXD6CKWv1G): [legalPad] for
/// light mode and [blackPad] for dark mode. Every text pair is at least
/// 7:1 in both.
///
/// Features read these through the theme (`ColorScheme` and
/// `NotepadColors`), not directly.
@immutable
class AppColors {
  const new({
    required this.paper,
    required this.paperField,
    required this.ink,
    required this.inkMuted,
    required this.cover,
    required this.onCover,
    required this.accent,
    required this.rule,
    required this.margin,
    required this.band,
    required this.error,
  });

  /// Light mode: a yellow legal pad with a navy cover.
  static const legalPad = AppColors(
    paper: Color(0xFFFFF4A8),
    paperField: Color(0xFFFFFBE0),
    ink: Color(0xFF1A1A1A),
    inkMuted: Color(0xFF4D4527),
    cover: Color(0xFF1D3557),
    onCover: Color(0xFFFFFFFF),
    accent: Color(0xFF1D3557),
    rule: Color(0xFF7FA7D1),
    margin: Color(0xFFC2362F),
    band: Color(0xFFDCE6F2),
    error: Color(0xFF9B1C1C),
  );

  /// Dark mode: a black pad with the same navy cover.
  static const blackPad = AppColors(
    paper: Color(0xFF121212),
    paperField: Color(0xFF1E1E1E),
    ink: Color(0xFFFFFFFF),
    inkMuted: Color(0xFFC2C2C2),
    cover: Color(0xFF1D3557),
    onCover: Color(0xFFFFFFFF),
    accent: Color(0xFF8FB3E0),
    rule: Color(0xFF3C5A80),
    margin: Color(0xFFB3443D),
    band: Color(0xFF263449),
    error: Color(0xFFFF8A80),
  );

  /// Page background: the pad's sheet.
  final Color paper;

  /// Text fields, dialogs and menus: a lighter sheet on top of [paper].
  final Color paperField;

  /// All main text and icons, heavy rules and field borders.
  final Color ink;

  /// Checked-off items, hints and counts. Never for anything to act on.
  final Color inkMuted;

  /// Navy notepad cover: the header and filled buttons.
  final Color cover;

  /// Text and icons on [cover].
  final Color onCover;

  /// Blue text and marks on [paper]: text buttons, check marks, the focused
  /// field border and the cursor.
  final Color accent;

  /// The blue rule under each row. Decorative only.
  final Color rule;

  /// The red margin line down the left of a list. Decorative only.
  final Color margin;

  /// Section headings (Got it) and the current store in the store menu.
  final Color band;

  /// Error text and destructive buttons.
  final Color error;
}
