import 'package:collection/collection.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/domain/store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_store.g.dart';

/// The id of the store Mom last picked, or null before she picks one.
/// App-wide, so the list stays on that store while the app is open.
@Riverpod(keepAlive: true)
class SelectedStoreId extends _$SelectedStoreId {
  @override
  String? build() => null;

  // A method, not a setter, as Riverpod recommends for notifiers.
  // ignore: use_setters_to_change_properties
  void select(String storeId) => state = storeId;
}

/// The store whose list is showing: the one Mom picked, else the first
/// store, or null when there are no stores yet.
@riverpod
AsyncValue<Store?> currentStore(Ref ref) {
  final selectedId = ref.watch(selectedStoreIdProvider);
  return ref
      .watch(storesProvider)
      .whenData(
        (stores) =>
            stores.firstWhereOrNull((store) => store.id == selectedId) ??
            stores.firstOrNull,
      );
}
