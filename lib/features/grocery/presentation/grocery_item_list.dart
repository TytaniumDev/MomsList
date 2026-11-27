import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/presentation/grocery_item_tile.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Every item at [storeId]: what to get at the top, then everything already
/// checked off under a "Got it" heading.
class GroceryItemList extends ConsumerWidget {
  const new({required this.storeId, super.key});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = ref.watch(storeItemsProvider(storeId)).value ?? const [];
    final toGet = items.where((item) => !item.checked).toList();
    final gotIt = items.where((item) => item.checked).toList();

    return MarginLine(
      child: ListView(
        children: [
          for (final item in toGet) _tile(item),
          if (toGet.isEmpty) EmptyState(message: l10n.groceryListEmptyMessage),
          if (gotIt.isNotEmpty)
            GotItBand(label: l10n.gotItHeading(gotIt.length)),
          for (final item in gotIt) _tile(item),
        ],
      ),
    );
  }

  Widget _tile(GroceryItem item) =>
      GroceryItemTile(key: ValueKey(item.id), item: item);
}
