import 'package:flutter/foundation.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';

/// Where on this store's list a suggested name already is.
enum SuggestionSource() {
  /// Unchecked on the list already.
  onThisList,

  /// Checked off: bought here before.
  boughtBefore,
}

/// A previously entered item offered while Mom types.
@immutable
class const ItemSuggestion({
  /// The name as Mom last typed it.
  required final String name,
  required final SuggestionSource source,
}) {
  @override
  bool operator ==(Object other) =>
      other is ItemSuggestion && other.name == name && other.source == source;

  @override
  int get hashCode => Object.hash(name, source);
}

/// Up to [limit] names entered before at the store [storeId] that match
/// [query]. Other stores' items are never suggested.
///
/// Names that start with the query come before names that only contain it,
/// then A to Z.
List<ItemSuggestion> itemSuggestions({
  required String query,
  required String storeId,
  required List<GroceryItem> items,
  int limit = 3,
}) {
  final needle = GroceryItem.normalize(query);
  if (needle.isEmpty) return const [];

  final matches =
      [
        for (final item in items)
          if (item.storeId == storeId &&
              GroceryItem.normalize(item.name).contains(needle))
            (key: GroceryItem.normalize(item.name), item: item),
      ]..sort((a, b) {
        final aPrefix = a.key.startsWith(needle) ? 0 : 1;
        final bPrefix = b.key.startsWith(needle) ? 0 : 1;
        if (aPrefix != bPrefix) return aPrefix - bPrefix;
        return a.key.compareTo(b.key);
      });

  return [
    for (final (:item, key: _) in matches.take(limit))
      ItemSuggestion(
        name: item.name,
        source: item.checked ? .boughtBefore : .onThisList,
      ),
  ];
}
