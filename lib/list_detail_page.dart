import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:moms_list/main.dart';
import 'package:moms_list/repositories/app_model.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

final listDetailPageIdProvider = StateProvider<String>((ref) => "");

final _listDetailProvider = Provider<MomList>((ref) {
  final listId = ref.watch(listDetailPageIdProvider).state;
  final appModel = ref.watch(appModelProvider.state);
  return appModel.lists.firstWhere((element) => element.id == listId);
});

final _listItemsProvider = Provider<List<MomListItem>>((ref) {
  final listId = ref.watch(listDetailPageIdProvider).state;
  final appModel = ref.watch(appModelProvider.state);
  return appModel.lists.firstWhere((element) => element.id == listId).listItems;
});

final _sortedListItemsProvider = Provider<List<MomListItem>>((ref) {
  final listItems = ref.watch(_listItemsProvider);
  final sortOrder = ref.watch(_listDetailProvider).currentSort.sortType;

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

final _editModeProvider = StateProvider.autoDispose<bool>((_) => false);

class ListDetailPage extends Page {
  final Function navigateHome;

  ListDetailPage(this.navigateHome);

  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return ListDetailContent(
          navigateHome: navigateHome,
        );
      },
    );
  }
}

class ListDetailContent extends HookWidget {
  final Function navigateHome;

  const ListDetailContent({Key? key, required this.navigateHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listId = useProvider(listDetailPageIdProvider).state;
    final momList = useProvider(_listDetailProvider);
    final editMode = useProvider(_editModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: ListDetailPageTitle(),
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
          //TODO: Make this an overflow menu
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
                  border: OutlineInputBorder(),
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

class ListDetailPageTitle extends HookWidget {
  const ListDetailPageTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editModeEnabled = useProvider(_editModeProvider).state;
    final momList = useProvider(_listDetailProvider);
    final textController = useTextEditingController(text: momList.title);

    if (editModeEnabled) {
      return SizedBox(
        height: 48,
        child: Theme(
          data: ThemeData(primaryColor: Colors.black),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: textController,
            onSubmitted: (text) => {
              context.read(appModelProvider).setListTitle(momList.id, text),
            },
          ),
        ),
      );
    } else {
      return Text(momList.title);
    }
  }
}

class MomListItems extends HookWidget {
  final String listId;

  const MomListItems({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listItems = useProvider(_sortedListItemsProvider);
    final editModeEnabled = useProvider(_editModeProvider).state;

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
            direction: editModeEnabled
                ? DismissDirection.endToStart
                : DismissDirection.none,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border(
                bottom:
                    Divider.createBorderSide(context, color: Colors.black38),
              )),
              child: CheckboxListTile(
                key: ValueKey(listItem.id),
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
    final editModeEnabled = useProvider(_editModeProvider).state;
    final listItem = useProvider(listItemProvider);
    final textController = useTextEditingController(text: listItem.title);

    if (editModeEnabled) {
      return SizedBox(
        height: 38,
        child: TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
          controller: textController,
          onSubmitted: (text) => {
            context.read(appModelProvider).updateListItemTitle(listItem.id, text),
          },
        ),
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
