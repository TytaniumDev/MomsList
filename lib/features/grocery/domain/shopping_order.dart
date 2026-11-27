import 'package:moms_list/features/grocery/domain/grocery_item.dart';

/// [items] in the order Mom's list shows them: items still to get first,
/// then checked items, each group A to Z (ignoring case and spacing).
List<GroceryItem> shoppingOrder(Iterable<GroceryItem> items) {
  final unchecked = items.where((item) => !item.checked).toList()
    ..sort(_compareNames);
  final checked = items.where((item) => item.checked).toList()
    ..sort(_compareNames);
  return [...unchecked, ...checked];
}

int _compareNames(GroceryItem a, GroceryItem b) =>
    GroceryItem.normalize(a.name).compareTo(GroceryItem.normalize(b.name));
