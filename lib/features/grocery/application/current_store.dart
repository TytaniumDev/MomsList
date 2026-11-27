import 'dart:async';

import 'package:collection/collection.dart';
import 'package:moms_list/features/grocery/application/grocery_providers.dart';
import 'package:moms_list/features/grocery/data/last_store_storage.dart';
import 'package:moms_list/features/grocery/domain/store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_store.g.dart';

/// Where the last opened store is saved on this phone.
@Riverpod(keepAlive: true)
LastStoreStorage lastStoreStorage(Ref ref) => LastStoreStorage();

/// The id of the store Mom had open when she last used the app, read once
/// at launch. Null if none was saved or it couldn't be read.
@Riverpod(keepAlive: true)
Future<String?> lastStoreId(Ref ref) async {
  try {
    return await ref.watch(lastStoreStorageProvider).read();
  } on Object {
    return null;
  }
}

/// The id of the store Mom picked since the app opened, or null before she
/// picks one. App-wide, so the list stays on that store while the app is
/// open. Each pick is also saved for next launch.
@Riverpod(keepAlive: true)
class SelectedStoreId extends _$SelectedStoreId {
  @override
  String? build() => null;

  void select(String storeId) {
    state = storeId;
    unawaited(ref.read(lastStoreStorageProvider).write(storeId));
  }
}

/// The store whose list is showing: the one Mom picked, else the one she had
/// open last time, else the first store, or null when there are no stores.
@riverpod
AsyncValue<Store?> currentStore(Ref ref) {
  final stores = ref.watch(storesProvider);
  final lastId = ref.watch(lastStoreIdProvider);
  final selectedId = ref.watch(selectedStoreIdProvider) ?? lastId.value;
  // Wait for the saved store so the list doesn't open on another first.
  if (selectedId == null && lastId.isLoading) return const AsyncLoading();
  return stores.whenData(
    (stores) =>
        stores.firstWhereOrNull((store) => store.id == selectedId) ??
        stores.firstOrNull,
  );
}
