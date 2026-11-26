import 'package:material_ui/material_ui.dart';
import 'package:moms_list/app/theme/notepad_colors.dart';

/// One tappable line of the notepad: full width, a rule line underneath and
/// almost no padding, so as much text as possible fits on screen.
///
/// Rows are at least 48 tall so they are easy to tap at small text sizes,
/// and grow with the text at large ones.
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
  static const padding = EdgeInsets.symmetric(horizontal: 8, vertical: 2);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: padding,
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: NotepadColors.of(context).ruleLine,
                width: 2,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
