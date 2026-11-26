import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';

void main() {
  group(GroceryItem, () {
    final t0 = DateTime(2026, 11, 26);

    test('names that differ in case or spacing share an id', () {
      expect(
        GroceryItem.idFor(storeId: 's', name: '  Peanut   Butter '),
        GroceryItem.idFor(storeId: 's', name: 'peanut butter'),
      );
      expect(
        GroceryItem.idFor(storeId: 's', name: 'Milk'),
        isNot(GroceryItem.idFor(storeId: 't', name: 'Milk')),
      );
    });

    test('ids are safe for Firestore', () {
      final id = GroceryItem.idFor(storeId: 's', name: 'AC/DC .. __x__');

      expect(id, isNot(contains('/')));
      expect(id, startsWith('s_'));
    });

    test('compares by value', () {
      GroceryItem item({bool checked = false}) => GroceryItem(
        id: '1',
        storeId: 's',
        name: 'Milk',
        checked: checked,
        addedAt: t0,
      );

      expect(item(), item());
      expect(item().hashCode, item().hashCode);
      expect(item(), isNot(item(checked: true)));
    });
  });
}
