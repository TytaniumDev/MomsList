import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/app_colors.dart';

/// The legal pad's colours that Material's [ColorScheme] has no slot for.
///
/// Read with [NotepadColors.of].
@immutable
class NotepadColors extends ThemeExtension<NotepadColors> {
  const new({
    required this.paperField,
    required this.ruleLine,
    required this.marginLine,
  });

  /// The Legal pad theme's values.
  static const legalPad = NotepadColors(
    paperField: AppColors.paperField,
    ruleLine: AppColors.rule,
    marginLine: AppColors.margin,
  );

  /// Fill of text fields and dialogs: a lighter sheet on the paper.
  final Color paperField;

  /// Line under each row. Decorative, so it doesn't need text contrast.
  final Color ruleLine;

  /// Red line down the left of a list. Decorative.
  final Color marginLine;

  /// The [NotepadColors] of the nearest [Theme].
  static NotepadColors of(BuildContext context) =>
      Theme.of(context).extension<NotepadColors>()!;

  @override
  NotepadColors copyWith({
    Color? paperField,
    Color? ruleLine,
    Color? marginLine,
  }) => NotepadColors(
    paperField: paperField ?? this.paperField,
    ruleLine: ruleLine ?? this.ruleLine,
    marginLine: marginLine ?? this.marginLine,
  );

  @override
  NotepadColors lerp(NotepadColors? other, double t) {
    if (other == null) return this;
    return NotepadColors(
      paperField: Color.lerp(paperField, other.paperField, t)!,
      ruleLine: Color.lerp(ruleLine, other.ruleLine, t)!,
      marginLine: Color.lerp(marginLine, other.marginLine, t)!,
    );
  }
}
