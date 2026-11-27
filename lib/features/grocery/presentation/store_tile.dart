import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/domain/store.dart';
import 'package:moms_list/l10n/l10n.dart';

/// A store in the store menu, as a [StoreRow] with how many items are
/// left to get there.
class StoreTile extends ConsumerWidget {
  const new({
    required this.store,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Store store;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(storeItemsProvider(store.id)).value ?? const [];
    final toGet = items.where((item) => !item.checked).length;

    return StoreRow(
      name: store.name,
      countLabel: context.l10n.storeItemsToGet(toGet),
      selected: selected,
      onTap: onTap,
    );
  }
}
