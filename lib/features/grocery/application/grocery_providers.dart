import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moms_list/app/services/firebase.dart';
import 'package:moms_list/features/account/account.dart';
import 'package:moms_list/features/grocery/data/firestore_grocery_repository.dart';
import 'package:moms_list/features/grocery/data/in_memory_grocery_repository.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/grocery_repository.dart';
import 'package:moms_list/features/grocery/domain/item_suggestions.dart';
import 'package:moms_list/features/grocery/domain/shopping_order.dart';
import 'package:moms_list/features/grocery/domain/store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'grocery_providers.g.dart';

/// The signed-in user's stores and items in Firestore, or an in-memory list
/// while signed out or without Firebase config. App-wide, so kept alive.
@Riverpod(keepAlive: true)
GroceryRepository groceryRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  final userId = ref.watch(authUserProvider.select((user) => user.value?.id));
  if (firestore == null || userId == null) return InMemoryGroceryRepository();
  return FirestoreGroceryRepository(firestore: firestore, userId: userId);
}

/// Every store, in the order they were added.
@riverpod
Stream<List<Store>> stores(Ref ref) =>
    ref.watch(groceryRepositoryProvider).watchStores();

/// Every item at every store.
@riverpod
Stream<List<GroceryItem>> groceryItems(Ref ref) =>
    ref.watch(groceryRepositoryProvider).watchItems();

/// The items at [storeId], in [shoppingOrder].
@riverpod
AsyncValue<List<GroceryItem>> storeItems(Ref ref, String storeId) => ref
    .watch(groceryItemsProvider)
    .whenData(
      (items) => shoppingOrder(items.where((item) => item.storeId == storeId)),
    );

/// Up to [limit] previously entered names matching [query] at [storeId].
/// See [itemSuggestions].
@riverpod
List<ItemSuggestion> itemSuggestionsFor(
  Ref ref, {
  required String storeId,
  required String query,
  int limit = 3,
}) => itemSuggestions(
  query: query,
  storeId: storeId,
  items: ref.watch(groceryItemsProvider).value ?? const [],
  stores: ref.watch(storesProvider).value ?? const [],
  limit: limit,
);
