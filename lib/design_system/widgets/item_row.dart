import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/widgets/ruled_row.dart';

/// One item on a store's list, written like a line on a legal pad.
///
/// A [checked] item is crossed out in muted ink. There's no checkbox: the
/// strike-through and the Got it section say what's done, and VoiceOver
/// reads the checked state.
class ItemRow extends StatelessWidget {
  const new({
    required this.name,
    required this.checked,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final String name;
  final bool checked;

  /// Usually checks the item off or puts it back.
  final VoidCallback? onTap;

  /// Usually offers to delete the item.
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = checked
        ? theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            decoration: TextDecoration.lineThrough,
            decorationColor: theme.colorScheme.onSurface,
          )
        : theme.textTheme.bodyLarge;

    return Semantics(
      checked: checked,
      child: RuledRow(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Text(name, style: style),
      ),
    );
  }
}
