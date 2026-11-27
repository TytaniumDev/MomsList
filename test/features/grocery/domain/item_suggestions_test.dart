import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/item_suggestions.dart';

void main() {
  final t0 = DateTime(2026, 11, 26);

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
    item('albertsons', 'Mints'),
    item('costco', 'Mild salsa'),
  ];

  List<ItemSuggestion> suggest(String query, {int limit = 3}) =>
      itemSuggestions(
        query: query,
        storeId: 'albertsons',
        items: items,
        limit: limit,
      );

  test('suggests nothing for an empty query', () {
    expect(suggest('  '), isEmpty);
  });

  test('ranks prefix matches first and says where each is on the list', () {
    expect(suggest('mil'), const [
      ItemSuggestion(name: 'Milk', source: SuggestionSource.onThisList),
      ItemSuggestion(
        name: 'Almond milk',
        source: SuggestionSource.boughtBefore,
      ),
    ]);
  });

  test("never suggests another store's items", () {
    expect(suggest('salsa'), isEmpty);
  });

  test('sorts matches of equal rank A to Z, ignoring case', () {
    expect(suggest('m', limit: 10).map((s) => s.name), [
      'Milk',
      'Mints',
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
    expect(
      a,
      isNot(
        const ItemSuggestion(
          name: 'Milk',
          source: SuggestionSource.boughtBefore,
        ),
      ),
    );
  });
}
