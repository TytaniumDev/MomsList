import 'package:flutter/foundation.dart';

/// Something Mom has ever added to a store's list. Items are kept after
/// they are checked off, so they can be added again with one tap.
@immutable
class const GroceryItem({
  required final String id,
  required final String storeId,
  required final String name,
  required final bool checked,

  /// When the item was last added, or added again.
  required final DateTime addedAt,

  /// When the item was last checked off, or null while unchecked.
  final DateTime? checkedAt,
}) {
  /// The id of the item called [name] at [storeId]. Names that differ only
  /// in case or spacing share an id, so adding an old item again un-checks
  /// it instead of making a duplicate. Safe to use as a Firestore document
  /// id.
  static String idFor({required String storeId, required String name}) =>
      '${storeId}_${Uri.encodeComponent(normalize(name))}';

  /// [name] in lower case, trimmed, with runs of spaces collapsed.
  static String normalize(String name) =>
      name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  @override
  bool operator ==(Object other) =>
      other is GroceryItem &&
      other.id == id &&
      other.storeId == storeId &&
      other.name == name &&
      other.checked == checked &&
      other.addedAt == addedAt &&
      other.checkedAt == checkedAt;

  @override
  int get hashCode =>
      Object.hash(id, storeId, name, checked, addedAt, checkedAt);
}
