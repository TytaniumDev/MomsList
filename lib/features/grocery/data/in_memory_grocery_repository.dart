import 'dart:async';

import 'package:clock/clock.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/grocery_repository.dart';
import 'package:moms_list/features/grocery/domain/store.dart';

/// [GroceryRepository] kept in memory, for builds without Firebase config
/// and for tests. Nothing is saved when the app closes.
class InMemoryGroceryRepository() implements GroceryRepository {
  final _stores = <String, Store>{};
  final _items = <String, GroceryItem>{};
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<List<Store>> watchStores() => _watch(
    () =>
        _stores.values.toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
  );

  @override
  Stream<List<GroceryItem>> watchItems() =>
      _watch(() => _items.values.toList());

  @override
  Future<void> addStore({required String id, required String name}) async {
    _stores[id] = Store(id: id, name: name.trim(), createdAt: clock.now());
    _changed();
  }

  @override
  Future<void> renameStore({required String id, required String name}) async {
    final store = _stores[id];
    if (store == null) return;
    _stores[id] = Store(id: id, name: name.trim(), createdAt: store.createdAt);
    _changed();
  }

  @override
  Future<void> deleteStore(String id) async {
    _stores.remove(id);
    _items.removeWhere((_, item) => item.storeId == id);
    _changed();
  }

  @override
  Future<void> addItem({required String storeId, required String name}) async {
    final id = GroceryItem.idFor(storeId: storeId, name: name);
    _items[id] = GroceryItem(
      id: id,
      storeId: storeId,
      name: name.trim(),
      checked: false,
      addedAt: clock.now(),
    );
    _changed();
  }

  @override
  Future<void> setChecked(String itemId, {required bool checked}) async {
    final item = _items[itemId];
    if (item == null) return;
    _items[itemId] = GroceryItem(
      id: item.id,
      storeId: item.storeId,
      name: item.name,
      checked: checked,
      addedAt: item.addedAt,
      checkedAt: checked ? clock.now() : null,
    );
    _changed();
  }

  @override
  Future<void> deleteItem(String itemId) async {
    _items.remove(itemId);
    _changed();
  }

  /// The current value of [read], then a new one after every change.
  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    yield* _changes.stream.map((_) => read());
  }

  void _changed() => _changes.add(null);
}
