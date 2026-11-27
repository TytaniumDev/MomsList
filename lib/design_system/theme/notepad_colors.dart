import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/tokens/app_colors.dart';

/// The pad's colours that Material's [ColorScheme] has no slot for.
///
/// Read with [NotepadColors.of].
@immutable
class NotepadColors extends ThemeExtension<NotepadColors> {
  const new({
    required this.paperField,
    required this.ruleLine,
    required this.marginLine,
    required this.cover,
    required this.onCover,
  });

  /// The colours of [palette].
  new from(AppColors palette)
    : this(
        paperField: palette.paperField,
        ruleLine: palette.rule,
        marginLine: palette.margin,
        cover: palette.cover,
        onCover: palette.onCover,
      );

  /// Fill of text fields and dialogs: a lighter sheet on the paper.
  final Color paperField;

  /// Line under each row. Decorative, so it doesn't need text contrast.
  final Color ruleLine;

  /// Red line down the left of a list. Decorative.
  final Color marginLine;

  /// Navy cover, for filled buttons such as the add button. Blue marks on
  /// the paper use `ColorScheme.primary` instead.
  final Color cover;

  /// Text and icons on [cover].
  final Color onCover;

  /// The [NotepadColors] of the nearest [Theme].
  static NotepadColors of(BuildContext context) =>
      Theme.of(context).extension<NotepadColors>()!;

  @override
  NotepadColors copyWith({
    Color? paperField,
    Color? ruleLine,
    Color? marginLine,
    Color? cover,
    Color? onCover,
  }) => NotepadColors(
    paperField: paperField ?? this.paperField,
    ruleLine: ruleLine ?? this.ruleLine,
    marginLine: marginLine ?? this.marginLine,
    cover: cover ?? this.cover,
    onCover: onCover ?? this.onCover,
  );

  @override
  NotepadColors lerp(NotepadColors? other, double t) {
    if (other == null) return this;
    return NotepadColors(
      paperField: Color.lerp(paperField, other.paperField, t)!,
      ruleLine: Color.lerp(ruleLine, other.ruleLine, t)!,
      marginLine: Color.lerp(marginLine, other.marginLine, t)!,
      cover: Color.lerp(cover, other.cover, t)!,
      onCover: Color.lerp(onCover, other.onCover, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is NotepadColors &&
      other.paperField == paperField &&
      other.ruleLine == ruleLine &&
      other.marginLine == marginLine &&
      other.cover == cover &&
      other.onCover == onCover;

  @override
  int get hashCode =>
      Object.hash(paperField, ruleLine, marginLine, cover, onCover);
}
