import 'package:flutter_riverpod/all.dart';

class ParentList {
  const ParentList(this.title);
  final String title;
}

class HomeListsNotifier extends StateNotifier<List<ParentList>> {
  HomeListsNotifier()
      : super([
          ParentList("Costco"),
          ParentList("Safeway"),
          ParentList("Vons"),
          ParentList("Ralph's"),
          ParentList("Traber Jerbs"),
        ]);

  void addList(String title) {
    state = [
      ...state + [ParentList(title)]
    ];
  }

  void removeList(String title) {
    state = [
      for (final parentList in state)
        if (parentList.title != title) parentList,
    ];
  }

  void reorderList(int oldIndex, int newIndex) {
    var existingList = state;
    if (newIndex > oldIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    final ParentList element = existingList.removeAt(oldIndex);
    existingList.insert(newIndex, element);
    state = existingList;
  }
}
