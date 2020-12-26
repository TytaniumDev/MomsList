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

  void addList(MomList list) {
    final newAppModel = state.copyWith(
      lists: removeDuplicates([
        ...state.lists,
        list,
      ]).toList(),
    );

    state = newAppModel;
    writeToSharedPrefs();
  }

  void writeToSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(listsKey, state.toJson());
  }

  void readFromSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    state = AppModel.fromJson(prefs.getString(listsKey));
  }

  void removeList(MomList list) {
    final newAppModel = state.copyWith(
      lists: [
        ...state.lists.where((element) => element != list),
      ],
    );


    state = newAppModel;
    writeToSharedPrefs();
  }

  void reorderList(int oldIndex, int newIndex) {
    var existingList = state.lists;
    if (newIndex > oldIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    final MomList element = existingList.removeAt(oldIndex);
    existingList.insert(newIndex, element);

    print(
        "*** Old list: ${state.lists.map((e) => e.title)}\n\n*** New list:${existingList.map((e) => e.title)}");

    state = state.copyWith(lists: existingList);
    writeToSharedPrefs();
  }
}
