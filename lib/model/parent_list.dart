import 'package:flutter/cupertino.dart';

/// The model for a single List/Note in the context of our app.
class ListModel {
  const ListModel(
    this.title, {
    this.listItems = const [],
  });

  /// The title of the list.
  final String title;

  final List<ListItem> listItems;
}

class ListItem {
  const ListItem(
    this.title, {
    this.isChecked = false,
  });

  final String title;
  final bool isChecked;
}

class HomeListModel with ChangeNotifier {
  List<ListModel> _lists = [
    ListModel("Costco"),
    ListModel("Safeway"),
    ListModel("Vons"),
    ListModel("Ralph's"),
    ListModel("Traber Jerbs"),
  ];

  List<ListModel> get lists => _lists;

  void addList(String title) {
    _lists += [ListModel(title)];
    notifyListeners();
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
