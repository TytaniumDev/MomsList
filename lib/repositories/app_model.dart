import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

/// The model for all information that makes up the whole app's state.
///
/// All of the fields should be persisted across app launches. If there is app
/// state that doesn't need to be persisted, it probably doesn't need to be
/// included here.
class AppModel {
  const AppModel({
    this.lists = const [],
  });

  /// An ordered list of all of the [MomListItem]s contained in this list.
  ///
  /// [MomListItem]s, like [MomList]s, are uniquely identified by their title.
  final List<MomList> lists;

  AppModel copyWith({
    List<MomList>? lists,
  }) =>
      AppModel(
        lists: lists ?? this.lists,
      );

  @override
  bool operator ==(Object other) {
    final decision = identical(this, other) ||
        other is AppModel &&
            runtimeType == other.runtimeType &&
            lists == other.lists;

    print("***Doing equality operation, result is $decision");

    return decision;
  }

  @override
  int get hashCode => lists.hashCode;
}

/// The model for a single List/Note in the context of our app.
class MomList with EquatableMixin {
  MomList(
    this.title, {
    this.listItems = const {},
    this.currentSort = const MomListSort(),
    String? id,
  }) : id = id ?? _uuid.v4();

  /// The unique ID of this list.
  final String id;

  /// The title of the list.
  ///
  /// This also serves as the unique identifier for this object.
  final String title;

  /// The current sort status of the list.
  final MomListSort currentSort;

  /// A set of all of the [MomListItem]s contained in this list.
  ///
  /// [MomListItem]s, like [MomList]s, are uniquely identified by their title.
  /// This set will always be unsorted!
  final Set<MomListItem> listItems;

  @override
  List<Object?> get props => [id];

  MomList copyWith({
    String? title,
    MomListSort? currentSort,
    Set<MomListItem>? listItems,
    String? id,
  }) =>
      MomList(
        title ?? this.title,
        listItems: listItems ?? this.listItems,
        currentSort: currentSort ?? this.currentSort,
        id: id ?? this.id,
      );
}

/// The model for a individual line item inside of a List.
class MomListItem with EquatableMixin {
  MomListItem(
    this.title, {
    this.isChecked = false,
    String? id,
  }) : id = id ?? _uuid.v4();

  /// The unique ID of this list item.
  final String id;

  /// The title of the item.
  ///
  /// This also serves as the unique identifier for this object.
  final String title;

  /// If this item is checked off or not.
  final bool isChecked;

  @override
  List<Object?> get props => [id];

  MomListItem copyWith({String? title, bool? isChecked, String? id}) =>
      MomListItem(
        title ?? this.title,
        isChecked: isChecked ?? this.isChecked,
        id: id ?? this.id,
      );
}

class MomListSort {
  const MomListSort({
    this.sortType = ListSort.alphabetical,
    this.autoSortEnabled = true,
  });

  final ListSort sortType;

  final bool autoSortEnabled;
}

enum ListSort {
  alphabetical,
  status,
}
