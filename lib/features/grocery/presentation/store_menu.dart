import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/grocery/application/current_store.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/presentation/new_store_field.dart';
import 'package:moms_list/features/grocery/presentation/store_tile.dart';

/// The store dropdown under the list's name: every store, to switch lists,
/// and a box to add a new store. [onDone] runs once Mom picks or adds one,
/// with that store's list already showing.
class StoreMenu extends ConsumerWidget {
  const new({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stores = ref.watch(storesProvider).value ?? const [];
    final currentId = ref.watch(currentStoreProvider).value?.id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MarginLine(
          child: Column(
            children: [
              for (final store in stores)
                StoreTile(
                  key: ValueKey(store.id),
                  store: store,
                  selected: store.id == currentId,
                  onTap: () {
                    ref.read(selectedStoreIdProvider.notifier).select(store.id);
                    onDone();
                  },
                ),
            ],
          ),
        ),
        NewStoreField(onAdded: onDone),
      ],
    );
  }
}
