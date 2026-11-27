import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/features/grocery/application/grocery_controller.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/presentation/delete_item_dialog.dart';
import 'package:moms_list/features/grocery/presentation/ruled_row.dart';

/// One item on a store's list, written like a line on a notepad.
///
/// Tapping checks it off (crossed out and greyed) or puts it back. Holding
/// it down offers to delete it, for typos.
class GroceryItemTile extends ConsumerWidget {
  const new({required this.item, super.key});

  final GroceryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = item.checked
        ? theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            decoration: TextDecoration.lineThrough,
            decorationColor: theme.colorScheme.onSurface,
          )
        : theme.textTheme.bodyLarge;

    return Semantics(
      checked: item.checked,
      child: RuledRow(
        onTap: () => ref
            .read(groceryControllerProvider.notifier)
            .setChecked(item.id, checked: !item.checked),
        onLongPress: () => _confirmDelete(context, ref),
        child: Text(item.name, style: style),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final delete = await showDeleteItemDialog(context, itemName: item.name);
    if (delete && context.mounted) {
      ref.read(groceryControllerProvider.notifier).deleteItem(item.id);
    }
  }
}
