import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/grocery_repository.dart';
import 'package:moms_list/features/grocery/domain/store.dart';

/// [GroceryRepository] in Cloud Firestore, under the signed-in user:
///
/// - `users/{uid}/stores/{storeId}`: `name`, `createdAt`
/// - `users/{uid}/items/{itemId}`: `storeId`, `name`, `checked`,
///   `addedAt`, `checkedAt`
///
/// Items are one collection rather than one per store, so suggestions can
/// come from every store with a single listener. Firestore keeps a local
/// cache, so the list works offline and syncs when the connection is back.
class FirestoreGroceryRepository({
  required final FirebaseFirestore _firestore,

  /// The signed-in user's id.
  required final String _userId,
}) implements GroceryRepository {
  DocumentReference<Map<String, dynamic>> get _user =>
      _firestore.collection('users').doc(_userId);

  CollectionReference<Map<String, dynamic>> get _stores =>
      _user.collection('stores');

  CollectionReference<Map<String, dynamic>> get _items =>
      _user.collection('items');

  @override
  Stream<List<Store>> watchStores() => _stores
      .orderBy('createdAt')
      .snapshots()
      .map((snapshot) => [for (final doc in snapshot.docs) _toStore(doc)]);

  @override
  Stream<List<GroceryItem>> watchItems() => _items.snapshots().map(
    (snapshot) => [for (final doc in snapshot.docs) _toItem(doc)],
  );

  @override
  Future<void> addStore({required String id, required String name}) => _stores
      .doc(id)
      .set({'name': name.trim(), 'createdAt': Timestamp.fromDate(clock.now())});

  @override
  Future<void> renameStore({required String id, required String name}) =>
      _stores.doc(id).update({'name': name.trim()});

  @override
  Future<void> deleteStore(String id) async {
    final items = await _items.where('storeId', isEqualTo: id).get();
    final batch = _firestore.batch();
    for (final doc in items.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_stores.doc(id));
    await batch.commit();
  }

  /// Keeps the name as typed this time, so the list shows Mom's latest
  /// spelling.
  @override
  Future<void> addItem({required String storeId, required String name}) =>
      _items.doc(GroceryItem.idFor(storeId: storeId, name: name)).set({
        'storeId': storeId,
        'name': name.trim(),
        'checked': false,
        'addedAt': Timestamp.fromDate(clock.now()),
        'checkedAt': null,
      });

  @override
  Future<void> setChecked(String itemId, {required bool checked}) =>
      _items.doc(itemId).update({
        'checked': checked,
        'checkedAt': checked ? Timestamp.fromDate(clock.now()) : null,
      });

  @override
  Future<void> deleteItem(String itemId) => _items.doc(itemId).delete();
}

Store _toStore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Store(
    id: doc.id,
    name: data['name'] as String,
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );
}

GroceryItem _toItem(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return GroceryItem(
    id: doc.id,
    storeId: data['storeId'] as String,
    name: data['name'] as String,
    checked: data['checked'] as bool,
    addedAt: (data['addedAt'] as Timestamp).toDate(),
    checkedAt: (data['checkedAt'] as Timestamp?)?.toDate(),
  );
}
