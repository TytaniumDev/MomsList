import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/design_system.dart';
import 'package:moms_list/features/feedback/feedback.dart';
import 'package:moms_list/features/grocery/application/current_store.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/presentation/new_store_field.dart';
import 'package:moms_list/features/grocery/presentation/store_tile.dart';
import 'package:moms_list/l10n/l10n.dart';

/// Every store, to switch lists or add a new store. Picking or adding one
/// goes back to its list.
class StorePickerPage extends ConsumerWidget {
  const new({super.key});

  /// Opens the picker over the current page.
  static Future<void> open(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => const StorePickerPage()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stores = ref.watch(storesProvider).value ?? const [];
    final currentId = ref.watch(currentStoreProvider).value?.id;
    void close() => Navigator.of(context).pop();

    return PageScaffold(
      title: context.l10n.storePickerTitle,
      actions: const [FeedbackButton()],
      body: ListView(
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
                      ref
                          .read(selectedStoreIdProvider.notifier)
                          .select(store.id);
                      close();
                    },
                  ),
              ],
            ),
          ),
          NewStoreField(onAdded: close),
        ],
      ),
    );
  }
}
