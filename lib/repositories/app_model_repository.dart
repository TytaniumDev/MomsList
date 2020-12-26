import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:moms_list/repositories/app_model.dart';
import 'package:moms_list/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModelRepository extends StateNotifier<AppModel> {
  static const String listsKey = "HomeLists";

  AppModelRepository(AppModel? initialModel)
      : super(initialModel ?? AppModel()) {
    init();
  }

  void init() async {
    readFromSharedPrefs();
  }

  /// List CRUD functions:

  void addList(MomList list) {
    final newAppModel = state.copyWith(
      lists: removeDuplicates([
        ...state.lists,
        list,
      ]).toList(),
    );

    updateState(newAppModel);
  }

  void removeList(String listId) {
    final newAppModel = state.copyWith(
      lists: [
        ...state.lists.where((element) => element.id != listId),
      ],
    );

    updateState(newAppModel);
  }

  void reorderList(int oldIndex, int newIndex) {
    var existingList = state.lists;
    if (newIndex > oldIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    final MomList element = existingList.removeAt(oldIndex);
    existingList.insert(newIndex, element);

    updateState(state.copyWith(lists: existingList));
  }

  void setSortOrder(String listId, MomListSort sort) {
    final newAppModel = state.copyWith(lists: [
      for (final momList in state.lists)
        if (momList.id == listId)
          momList.copyWith(currentSort: sort)
        else
          momList
    ]);

    updateState(newAppModel);
  }

  /// List Item CRUD functions:

  void addListItem(String listId, MomListItem item) {
    final newAppModel = state.copyWith(lists: [
      for (final momList in state.lists)
        if (momList.id == listId)
          momList.copyWith(
              listItems:
                  removeDuplicates([...momList.listItems, item]).toList())
        else
          momList
    ]);

    updateState(newAppModel);
  }

  void toggleListItem(String listItemId, bool checked) {
    final newAppModel = state.copyWith(lists: [
      for (final momList in state.lists)
        if (momList.listItems.any((element) => element.id == listItemId))
          momList.copyWith(listItems: [
            for (final momListItem in momList.listItems)
              if (momListItem.id == listItemId)
                momListItem.copyWith(isChecked: checked)
              else
                momListItem
          ])
        else
          momList
    ]);

    updateState(newAppModel);
  }
  
  void updateListItemTitle(String listItemId, String newTitle) {
    final newAppModel = state.copyWith(lists: [
      for (final momList in state.lists)
        if (momList.listItems.any((element) => element.id == listItemId))
          momList.copyWith(listItems: [
            for (final momListItem in momList.listItems)
              if (momListItem.id == listItemId)
                momListItem.copyWith(title: newTitle)
              else
                momListItem
          ])
        else
          momList
    ]);

    updateState(newAppModel);
  }

  /// Update the [AppModel] state, and write that new state to
  /// SharedPreferences.
  void updateState(AppModel newState) {
    state = newState;
    writeToSharedPrefs();
  }

  /// Write the JSON representation of [AppModel] to SharedPreferences.
  void writeToSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(listsKey, state.toJson());
  }

  /// Read the JSON representation of [AppModel] from SharedPreferences and
  /// update the app state to that value.
  void readFromSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    state = AppModel.fromJson(prefs.getString(listsKey));
  }
}
