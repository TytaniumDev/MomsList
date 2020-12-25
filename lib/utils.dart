Iterable<T> removeDuplicates<T>(Iterable<T> iterable) sync* {
  Set<T> items = {};
  for (T item in iterable) {
    if (!items.contains(item)) yield item;
    items.add(item);
  }
}