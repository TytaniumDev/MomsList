import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/grocery/application/grocery_controller.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/l10n/l10n.dart';

/// One item on a store's list, as an [ItemRow].
///
/// Tapping checks it off or puts it back. Holding it down offers to delete
/// it, for typos.
class GroceryItemTile extends ConsumerWidget {
  const new({required this.item, super.key});

  final GroceryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemRow(
      name: item.name,
      checked: item.checked,
      onTap: () => ref
          .read(groceryControllerProvider.notifier)
          .setChecked(item.id, checked: !item.checked),
      onLongPress: () => _confirmDelete(context, ref),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final delete = await showConfirmDialog(
      context,
      title: l10n.deleteItemDialogTitle(item.name),
      message: l10n.deleteItemDialogMessage,
      cancelLabel: l10n.deleteItemDialogCancelButton,
      confirmLabel: l10n.deleteItemDialogConfirmButton,
    );
    if (delete && context.mounted) {
      ref.read(groceryControllerProvider.notifier).deleteItem(item.id);
    }
  }
}
