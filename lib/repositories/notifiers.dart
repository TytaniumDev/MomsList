import 'package:flutter/foundation.dart';
import 'package:moms_list/model/parent_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeListViewModel with ChangeNotifier {
  static const String listsKey = "HomeLists";
  List<ListModel> _lists = [];

  List<ListModel> get lists => _lists;

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _lists = prefs.getStringList(listsKey).map((e) => ListModel(e)).toList();
    notifyListeners();
  }

  void addList(String title) {
    if (title.isEmpty) return;
    _lists.add(ListModel(title));
    addToSharedPrefs(title);
    notifyListeners();
  }

  void addToSharedPrefs(String title) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(listsKey, _lists.map((e) => e.title).toList());
  }

  void removeList(String title) {
    _lists = [
      for (final parentList in _lists)
        if (parentList.title != title) parentList,
    ];
    notifyListeners();
  }

  void reorderList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    final ListModel element = _lists.removeAt(oldIndex);
    _lists.insert(newIndex, element);
    notifyListeners();
  }
}
