import 'package:material_ui/material_ui.dart';

/// The ruled-paper colours of Mom's lists, so they look like the notepad
/// she is used to (and the app icon).
///
/// Read with `Theme.of(context).extension<NotepadColors>()!`, or
/// [NotepadColors.of].
@immutable
class NotepadColors extends ThemeExtension<NotepadColors> {
  const new({required this.paper, required this.ruleLine});

  /// Cream paper with blue rule lines.
  static const light = NotepadColors(
    paper: Color(0xFFFFFDF4),
    ruleLine: Color(0xFF8DB8E8),
  );

  /// Dark paper with dim blue rule lines.
  static const dark = NotepadColors(
    paper: Color(0xFF121212),
    ruleLine: Color(0xFF3E5F84),
  );

  /// Background of list pages.
  final Color paper;

  /// Line under each row. Decorative, so it doesn't need text contrast.
  final Color ruleLine;

  /// The [NotepadColors] of the nearest [Theme].
  static NotepadColors of(BuildContext context) =>
      Theme.of(context).extension<NotepadColors>()!;

  @override
  NotepadColors copyWith({Color? paper, Color? ruleLine}) => NotepadColors(
    paper: paper ?? this.paper,
    ruleLine: ruleLine ?? this.ruleLine,
  );

  @override
  NotepadColors lerp(NotepadColors? other, double t) {
    if (other == null) return this;
    return NotepadColors(
      paper: Color.lerp(paper, other.paper, t)!,
      ruleLine: Color.lerp(ruleLine, other.ruleLine, t)!,
    );
  }
}
