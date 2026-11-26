import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/store.dart';

/// Mom's stores and every item she has added to them.
///
/// Writes complete once the change is saved on the server, which can take a
/// while offline. Callers don't wait for them: the streams show a change as
/// soon as it is made on this device.
abstract interface class GroceryRepository {
  /// Every store, in the order they were added.
  Stream<List<Store>> watchStores();

  /// Every item at every store, in no particular order.
  Stream<List<GroceryItem>> watchItems();

  Future<void> addStore({required String id, required String name});

  Future<void> renameStore({required String id, required String name});

  /// Deletes the store and all of its items.
  Future<void> deleteStore(String id);

  /// Adds [name] to the store's list, unchecked. An item with the same name
  /// that was added before (see [GroceryItem.idFor]) is un-checked and moves
  /// back to the top instead.
  Future<void> addItem({required String storeId, required String name});

  Future<void> setChecked(String itemId, {required bool checked});

  Future<void> deleteItem(String itemId);
}
