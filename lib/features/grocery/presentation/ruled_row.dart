import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/app_spacing.dart';
import 'package:moms_list/app/theme/notepad_colors.dart';

/// One tappable line of the notepad: full width, a rule line underneath and
/// almost no padding, so as much text as possible fits on screen.
///
/// A one-line row is exactly 48 tall (a 24px line with 12px above and
/// below) and grows with the text. Text starts past the margin line; put
/// rows inside a `MarginLine` to draw it.
class RuledRow extends StatelessWidget {
  const new({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Background behind the row. Transparent (the paper) by default.
  final Color? color;

  /// Space around a row's text. Kept small on purpose.
  static const padding = EdgeInsetsDirectional.fromSTEB(
    AppSpacing.textInset,
    AppSpacing.row,
    AppSpacing.row,
    AppSpacing.row,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.tapTarget),
          padding: padding,
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: NotepadColors.of(context).ruleLine,
                width: AppStrokes.rule,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
