import 'package:flutter_test/flutter_test.dart';
import 'package:moms_list/features/grocery/domain/grocery_item.dart';
import 'package:moms_list/features/grocery/domain/shopping_order.dart';

void main() {
  final t0 = DateTime(2026, 11, 26);
  DateTime at(int minute) => t0.add(Duration(minutes: minute));

  GroceryItem item(String name, {required int added, int? checked}) =>
      GroceryItem(
        id: name,
        storeId: 's',
        name: name,
        checked: checked != null,
        addedAt: at(added),
        checkedAt: checked == null ? null : at(checked),
      );

  test('puts items to get first, then checked items, each A to Z', () {
    final ordered = shoppingOrder([
      item('Bread', added: 1, checked: 5),
      item('Milk', added: 2),
      item('Eggs', added: 3),
      item('Apples', added: 0, checked: 9),
    ]);

    expect(ordered.map((item) => item.name), [
      'Eggs',
      'Milk',
      'Apples',
      'Bread',
    ]);
  });

  test('ignores case when sorting', () {
    final ordered = shoppingOrder([
      item('milk', added: 1),
      item('Bread', added: 2),
      item('eggs', added: 0, checked: 2),
      item('Apples', added: 0, checked: 3),
    ]);

    expect(ordered.map((item) => item.name), [
      'Bread',
      'milk',
      'Apples',
      'eggs',
    ]);
  });
}
