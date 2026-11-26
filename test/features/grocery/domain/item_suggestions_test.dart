import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/item_suggestions.dart';
import 'package:moms_list/features/grocery/domain/store.dart';

void main() {
  final t0 = DateTime(2026, 11, 26);
  final stores = [
    Store(id: 'albertsons', name: 'Albertsons', createdAt: t0),
    Store(id: 'costco', name: 'Costco', createdAt: t0),
  ];

  GroceryItem item(String storeId, String name, {bool checked = false}) =>
      GroceryItem(
        id: GroceryItem.idFor(storeId: storeId, name: name),
        storeId: storeId,
        name: name,
        checked: checked,
        addedAt: t0,
      );

  final items = [
    item('albertsons', 'Milk'),
    item('albertsons', 'Almond milk', checked: true),
    item('costco', 'milk'),
    item('costco', 'Mild salsa'),
    item('gone', 'Milkshake'),
  ];

  List<ItemSuggestion> suggest(
    String query, {
    int limit = 3,
    bool allStores = true,
  }) => itemSuggestions(
    query: query,
    storeId: 'albertsons',
    items: items,
    stores: stores,
    limit: limit,
    allStores: allStores,
  );

  test('suggests nothing for an empty query', () {
    expect(suggest('  '), isEmpty);
  });

  test('ranks prefix matches first, this store first, and says where each '
      'came from', () {
    expect(suggest('mil'), const [
      ItemSuggestion(name: 'Milk', source: SuggestionSource.onThisList),
      ItemSuggestion(
        name: 'Mild salsa',
        source: SuggestionSource.otherStore,
        storeName: 'Costco',
      ),
      ItemSuggestion(
        name: 'Almond milk',
        source: SuggestionSource.boughtBefore,
      ),
    ]);
  });

  test('shows each name once, preferring this store', () {
    final names = suggest('milk', limit: 10).map((s) => s.name.toLowerCase());

    expect(names.where((name) => name == 'milk'), hasLength(1));
    expect(suggest('milk').first.source, SuggestionSource.onThisList);
  });

  test("prefers this store's item even when another store's comes first", () {
    final suggestions = itemSuggestions(
      query: 'milk',
      storeId: 'albertsons',
      items: [item('costco', 'milk'), item('albertsons', 'Milk')],
      stores: stores,
    );

    expect(suggestions, const [
      ItemSuggestion(name: 'Milk', source: SuggestionSource.onThisList),
    ]);
  });

  test('sorts matches of equal rank A to Z', () {
    final suggestions = itemSuggestions(
      query: 'b',
      storeId: 'albertsons',
      items: [item('albertsons', 'Butter'), item('albertsons', 'Bread')],
      stores: stores,
    );

    expect(suggestions.map((s) => s.name), ['Bread', 'Butter']);
  });

  test('skips items from deleted stores', () {
    expect(suggest('milkshake', limit: 10), isEmpty);
  });

  test('can stick to this store', () {
    expect(suggest('mil', allStores: false).map((s) => s.name), [
      'Milk',
      'Almond milk',
    ]);
  });

  test('stops at the limit', () {
    expect(suggest('m', limit: 2), hasLength(2));
  });

  test('compares by value', () {
    const a = ItemSuggestion(name: 'Milk', source: SuggestionSource.onThisList);

    expect(
      a,
      const ItemSuggestion(name: 'Milk', source: SuggestionSource.onThisList),
    );
    expect(
      a.hashCode,
      const ItemSuggestion(
        name: 'Milk',
        source: SuggestionSource.onThisList,
      ).hashCode,
    );
  });
}
