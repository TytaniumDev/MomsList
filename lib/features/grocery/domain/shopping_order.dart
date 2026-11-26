import 'package:moms_list/features/grocery/domain/grocery_item.dart';

/// [items] in the order Mom's list shows them: unchecked items first, the
/// most recently added at the top, then checked items, the most recently
/// checked first, so a mis-tap is easy to find and undo.
///
/// Ties keep a stable order by name. To show checked items A to Z instead,
/// change [_compareChecked].
List<GroceryItem> shoppingOrder(Iterable<GroceryItem> items) {
  final unchecked = items.where((item) => !item.checked).toList()
    ..sort(_compareUnchecked);
  final checked = items.where((item) => item.checked).toList()
    ..sort(_compareChecked);
  return [...unchecked, ...checked];
}

int _compareUnchecked(GroceryItem a, GroceryItem b) {
  final byAdded = b.addedAt.compareTo(a.addedAt);
  return byAdded != 0 ? byAdded : _compareNames(a, b);
}

int _compareChecked(GroceryItem a, GroceryItem b) {
  final aTime = a.checkedAt ?? a.addedAt;
  final bTime = b.checkedAt ?? b.addedAt;
  final byChecked = bTime.compareTo(aTime);
  return byChecked != 0 ? byChecked : _compareNames(a, b);
}

int _compareNames(GroceryItem a, GroceryItem b) =>
    GroceryItem.normalize(a.name).compareTo(GroceryItem.normalize(b.name));
