import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:moms_list/main.dart';
import 'package:moms_list/repositories/app_model.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

final listDetailProvider = Provider.family<MomList, String>((ref, listId) {
  final appModel = ref.watch(appModelProvider.state);
  return appModel.lists.firstWhere((element) => element.id == listId);
});

final listItemsProvider =
    Provider.family<List<MomListItem>, String>((ref, listId) {
  final appModel = ref.watch(appModelProvider.state);
  return appModel.lists.firstWhere((element) => element.id == listId).listItems;
});

final sortedListItemsProvider =
    Provider.family<List<MomListItem>, String>((ref, listId) {
  final listItems = ref.watch(listItemsProvider(listId));
  final sortOrder = ref.watch(listDetailProvider(listId)).currentSort.sortType;

  // Make a new empty list if there aren't any items in the list currently.
  final unsortedListItems = listItems.isEmpty ? <MomListItem>[] : listItems;

  switch (sortOrder) {
    case ListSort.alphabetical:
      return unsortedListItems..sort((a, b) => a.title.compareTo(b.title));
    case ListSort.status:
      return unsortedListItems
        ..sort((a, b) {
          if (a.isChecked == b.isChecked) {
            return a.title.compareTo(b.title);
          } else if (a.isChecked) {
            return 1;
          } else {
            return -1;
          }
        });
  }
});

final editModeProvider = StateProvider<bool>((_) => false);

class ListDetailPage extends Page {
  final String listId;
  final Function navigateHome;

  ListDetailPage({
    required this.listId,
    required this.navigateHome,
  }) : super(key: ValueKey(listId));

  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return ListDetailContent(
          listId: listId,
          navigateHome: navigateHome,
        );
      },
    );
  }
}

class ListDetailContent extends HookWidget {
  final String listId;
  final Function navigateHome;

  const ListDetailContent(
      {Key? key, required this.listId, required this.navigateHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final momList = useProvider(listDetailProvider(listId));
    final editMode = useProvider(editModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(momList.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              editMode.state = !editMode.state;
            },
          ),
          IconButton(
            icon: Icon(
              momList.currentSort.sortType == ListSort.alphabetical
                  ? Icons.playlist_add_check
                  : Icons.sort_by_alpha,
            ),
            onPressed: () {
              context.read(appModelProvider).setSortOrder(
                    listId,
                    momList.currentSort.copyWith(
                      sortType:
                          momList.currentSort.sortType == ListSort.alphabetical
                              ? ListSort.status
                              : ListSort.alphabetical,
                    ),
                  );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Delete Item"),
                    content: Text(
                        "Are you sure you want to delete ${momList.title}?"),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      FlatButton(
                        onPressed: () {
                          context.read(appModelProvider).removeList(listId);
                          navigateHome();
                        },
                        child: Text("Delete"),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (editMode.state)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Add a List Item",
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onSubmitted: (text) => {
                  context
                      .read(appModelProvider)
                      .addListItem(listId, MomListItem(text)),
                },
              ),
            ),
          Expanded(
            child: MomListItems(listId: listId),
          ),
        ],
      ),
    );
  }
}

class MomListItems extends HookWidget {
  final String listId;

  const MomListItems({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listItems = useProvider(sortedListItemsProvider(listId));
    final editModeEnabled = useProvider(editModeProvider).state;

    return ImplicitlyAnimatedList<MomListItem>(
      items: listItems,
      areItemsTheSame: (a, b) => a == b,
      itemBuilder: (context, animation, listItem, index) {
        return SizeFadeTransition(
          sizeFraction: 0.7,
          curve: Curves.easeInOutSine,
          animation: animation,
          child: Dismissible(
            key: ValueKey(listItem.id),
            background: Container(
              color: Colors.red,
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.delete),
              ),
            ),
            onDismissed: (_) {
              context.read(appModelProvider).removeListItem(listItem.id);
            },
            resizeDuration: null,
            direction: editModeEnabled ? DismissDirection.endToStart : DismissDirection.none,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border(
                bottom:
                    Divider.createBorderSide(context, color: Colors.black38),
              )),
              child: CheckboxListTile(
                key: ValueKey(listItem.title),
                title: ProviderScope(
                  overrides: [listItemProvider.overrideWithValue(listItem)],
                  child: const ListItemTitle(),
                ),
                onChanged: (bool? value) {
                  if (value != null)
                    context
                        .read(appModelProvider)
                        .toggleListItem(listItem.id, value);
                },
                value: listItem.isChecked,
              ),
            ),
          ),
        );
      },
    );
  }
}

final listItemProvider = ScopedProvider<MomListItem>(null);

class ListItemTitle extends HookWidget {
  const ListItemTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editModeEnabled = useProvider(editModeProvider).state;
    final listItem = useProvider(listItemProvider);

    if (editModeEnabled) {
      return TextField(
        decoration: InputDecoration(
          labelText: listItem.title,
        ),
        onSubmitted: (text) => {
          context.read(appModelProvider).updateListItemTitle(listItem.id, text),
        },
      );
    } else {
      return Text(
        listItem.title,
        style: TextStyle(
          decoration: listItem.isChecked
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      );
    }
  }
}
