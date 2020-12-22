import 'package:equatable/equatable.dart';

/// The model for a single List/Note in the context of our app.
class ListModel with EquatableMixin {
  const ListModel(
    this.title, {
    this.listItems = const {},
  });

  /// The title of the list.
  ///
  /// This also serves as the unique identifier for this object.
  final String title;

  /// A set of all of the [ListItem]s contained in this list.
  ///
  /// [ListItem]s, like [ListModel]s, are uniquely identified by their title.
  /// This set will always be unsorted!
  final Set<ListItem> listItems;

  @override
  List<Object?> get props => [title];
}

/// The model for a individual line item inside of a List.
class ListItem  with EquatableMixin {
  const ListItem(
    this.title, {
    this.isChecked = false,
  });

  /// The title of the item.
  ///
  /// This also serves as the unique identifier for this object.
  final String title;

  /// If this item is checked off or not.
  final bool isChecked;

  @override
  List<Object?> get props => [title];
}