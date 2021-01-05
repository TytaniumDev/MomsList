import 'dart:convert';

import 'package:collection/collection.dart';
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
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is AppModel && listEquals(o.lists, lists);
  }

  @override
  int get hashCode => lists.hashCode;

  /// Generated Code

  Map<String, dynamic> toMap() {
    return {
      'lists': lists.map((x) => x.toMap()).toList(),
    };
  }

  factory AppModel.fromMap(Map<String, dynamic> map) {
    return AppModel(
      lists: List<MomList>.from(map['lists']?.map((x) => MomList.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppModel.fromJson(String source) =>
      AppModel.fromMap(json.decode(source));

  @override
  String toString() => 'AppModel(lists: $lists)';
}

/// The model for a single List/Note in the context of our app.
class MomList with EquatableMixin {
  MomList(
    this.title, {
    this.listItems = const [],
    this.currentSort = const MomListSort(),
    String? id,
  }) : id = id ?? _uuid.v4();

  /// The unique ID of this list.
  final String id;

  /// The title of the list.
  final String title;

  /// The current sort status of the list.
  final MomListSort currentSort;

  /// A set of all of the [MomListItem]s contained in this list.
  final List<MomListItem> listItems;

  @override
  List<Object> get props => [id, title, currentSort, listItems];

  MomList copyWith({
    String? title,
    MomListSort? currentSort,
    List<MomListItem>? listItems,
    String? id,
  }) =>
      MomList(
        title ?? this.title,
        listItems: listItems ?? this.listItems,
        currentSort: currentSort ?? this.currentSort,
        id: id ?? this.id,
      );

  /// Generated Code

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'currentSort': currentSort.toMap(),
      'listItems': listItems.map((x) => x.toMap()).toList(),
    };
  }

  factory MomList.fromMap(Map<String, dynamic> map) {
    return MomList(
      map['title'],
      id: map['id'],
      currentSort: MomListSort.fromMap(map['currentSort']),
      listItems: List<MomListItem>.from(
          map['listItems']?.map((x) => MomListItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MomList.fromJson(String source) =>
      MomList.fromMap(json.decode(source));

  @override
  bool get stringify => true;
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
  final String title;

  /// If this item is checked off or not.
  final bool isChecked;

  @override
  List<Object> get props => [id, title, isChecked];

  MomListItem copyWith({
    String? id,
    String? title,
    bool? isChecked,
  }) =>
      MomListItem(
        title ?? this.title,
        id: id ?? this.id,
        isChecked: isChecked ?? this.isChecked,
      );

  /// Generated Code

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isChecked': isChecked,
    };
  }

  factory MomListItem.fromMap(Map<String, dynamic> map) {
    return MomListItem(
      map['title'],
      id: map['id'],
      isChecked: map['isChecked'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MomListItem.fromJson(String source) =>
      MomListItem.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}

class MomListSort {
  const MomListSort({
    this.sortType = ListSort.alphabetical,
    this.autoSortEnabled = true,
  });

  final ListSort sortType;

  final bool autoSortEnabled;

  MomListSort copyWith({
    ListSort? sortType,
    bool? autoSortEnabled,
  }) =>
      MomListSort(
        sortType: sortType ?? this.sortType,
        autoSortEnabled: autoSortEnabled ?? this.autoSortEnabled,
      );

  /// Generated Code

  Map<String, dynamic> toMap() {
    return {
      'sortType': sortType.toString(),
      'autoSortEnabled': autoSortEnabled,
    };
  }

  factory MomListSort.fromMap(Map<String, dynamic> map) {
    return MomListSort(
      sortType: ListSort.values.firstWhere((element) => element.toString() == map['sortType']),
      autoSortEnabled: map['autoSortEnabled'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MomListSort.fromJson(String source) =>
      MomListSort.fromMap(json.decode(source));

  @override
  String toString() =>
      'MomListSort(sortType: $sortType, autoSortEnabled: $autoSortEnabled)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MomListSort &&
        o.sortType == sortType &&
        o.autoSortEnabled == autoSortEnabled;
  }

  @override
  int get hashCode => sortType.hashCode ^ autoSortEnabled.hashCode;
}

enum ListSort {
  alphabetical,
  status,
}
