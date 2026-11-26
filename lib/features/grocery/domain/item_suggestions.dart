import 'package:flutter/foundation.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/store.dart';

/// Where a suggested name was entered before.
enum SuggestionSource() {
  /// Unchecked on this store's list already.
  onThisList,

  /// Checked off on this store's list: bought here before.
  boughtBefore,

  /// Only entered at another store, named by [ItemSuggestion.storeName].
  otherStore,
}

/// A previously entered item offered while Mom types.
@immutable
class const ItemSuggestion({
  /// The name as Mom last typed it.
  required final String name,
  required final SuggestionSource source,

  /// The other store's name, for [SuggestionSource.otherStore].
  final String? storeName,
}) {
  @override
  bool operator ==(Object other) =>
      other is ItemSuggestion &&
      other.name == name &&
      other.source == source &&
      other.storeName == storeName;

  @override
  int get hashCode => Object.hash(name, source, storeName);
}

/// Up to [limit] previously entered names that match [query], for the store
/// [storeId].
///
/// Each name appears once (compared with [GroceryItem.normalize]). Names
/// that start with the query come before names that only contain it, then
/// this store's items before other stores', then A to Z. To suggest only
/// this store's items, pass `allStores: false`.
List<ItemSuggestion> itemSuggestions({
  required String query,
  required String storeId,
  required List<GroceryItem> items,
  required List<Store> stores,
  int limit = 3,
  bool allStores = true,
}) {
  final needle = GroceryItem.normalize(query);
  if (needle.isEmpty) return const [];
  final storeNames = {for (final store in stores) store.id: store.name};

  // One candidate per name, preferring this store's item.
  final byName = <String, GroceryItem>{};
  for (final item in items) {
    final here = item.storeId == storeId;
    if (!here && (!allStores || !storeNames.containsKey(item.storeId))) {
      continue;
    }
    final key = GroceryItem.normalize(item.name);
    if (!key.contains(needle)) continue;
    final existing = byName[key];
    if (existing == null || (here && existing.storeId != storeId)) {
      byName[key] = item;
    }
  }

  final matches = byName.entries.toList()
    ..sort((a, b) {
      final aPrefix = a.key.startsWith(needle) ? 0 : 1;
      final bPrefix = b.key.startsWith(needle) ? 0 : 1;
      if (aPrefix != bPrefix) return aPrefix - bPrefix;
      final aHere = a.value.storeId == storeId ? 0 : 1;
      final bHere = b.value.storeId == storeId ? 0 : 1;
      if (aHere != bHere) return aHere - bHere;
      return a.key.compareTo(b.key);
    });

  return [
    for (final MapEntry(value: item) in matches.take(limit))
      if (item.storeId != storeId)
        ItemSuggestion(
          name: item.name,
          source: .otherStore,
          storeName: storeNames[item.storeId],
        )
      else
        ItemSuggestion(
          name: item.name,
          source: item.checked ? .boughtBefore : .onThisList,
        ),
  ];
}
