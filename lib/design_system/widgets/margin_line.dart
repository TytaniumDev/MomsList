import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/theme/notepad_colors.dart';
import 'package:moms_list/design_system/tokens/app_spacing.dart';

/// Draws the legal pad's red margin line down the left of [child], the
/// whole way down like on paper. Row text starts just past it, at
/// [AppSpacing.textInset].
class MarginLine extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: MarginLinePainter(
        color: NotepadColors.of(context).marginLine,
      ),
      child: child,
    );
  }
}

/// Paints a [AppStrokes.rule]-wide line [AppSpacing.row] from the left.
@visibleForTesting
class MarginLinePainter extends CustomPainter {
  new({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(AppSpacing.row, 0, AppStrokes.rule, size.height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(MarginLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
