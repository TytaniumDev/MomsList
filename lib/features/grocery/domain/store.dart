import 'package:flutter/foundation.dart';

/// A store Mom shops at, such as Costco, with its own list of items.
@immutable
class const Store({
  required final String id,
  required final String name,

  /// Stores are listed in the order they were added.
  required final DateTime createdAt,
}) {
  @override
  bool operator ==(Object other) =>
      other is Store &&
      other.id == id &&
      other.name == name &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, name, createdAt);
}
