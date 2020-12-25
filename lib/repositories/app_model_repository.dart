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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // _lists = prefs.getStringList(listsKey).map((e) => ListModel(e)).toList();
  }

  void addList(MomList list) {
    final newAppModel = state.copyWith(
      lists: removeDuplicates([
        ...state.lists,
        list,
      ]).toList(),
    );

    // addToSharedPrefs(list);

    state = newAppModel;
  }

  // void addToSharedPrefs(String title) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList(listsKey, _lists.map((e) => e.title).toList());
  // }

  void removeList(MomList list) {
    final newAppModel = state.copyWith(
      lists: [
        ...state.lists.where((element) => element != list),
      ],
    );

    // Remove from shared prefs

    state = newAppModel;
  }

  void reorderList(int oldIndex, int newIndex) {
    var existingList = state.lists;
    if (newIndex > oldIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    final MomList element = existingList.removeAt(oldIndex);
    existingList.insert(newIndex, element);

    print("*** Old list: ${state.lists.map((e) => e.title)}\n\n*** New list:${existingList.map((e) => e.title)}");

    state = state.copyWith(lists: existingList);
  }
}
