import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/tokens/app_spacing.dart';

/// The heading between the items to get and the items already checked
/// off, such as "Got it (84)": a blue band with a heavy ink rule on top.
class GotItBand extends StatelessWidget {
  const new({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.textInset,
        AppSpacing.md,
        AppSpacing.row,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.onSurface,
            width: AppStrokes.heavy,
          ),
        ),
      ),
      child: Semantics(
        header: true,
        child: Text(label, style: theme.textTheme.titleSmall),
      ),
    );
  }
}
