import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moms_list/main.dart';
import 'package:moms_list/repositories/app_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MomListViewModel with EquatableMixin {
  final String title;
  final String id;

  const MomListViewModel(this.title, this.id);

  @override
  List<Object?> get props => [title, id];

  @override
  bool? get stringify => true;
}

final orderedMomListProvider = Provider<Iterable<MomListViewModel>>((ref) {
  return ref
      .watch(appModelProvider.state)
      .lists
      .map((e) => MomListViewModel(e.title, e.id));
});

class HomePage extends Page {
  final ValueChanged<String> onListTapped;

  HomePage(this.onListTapped);

  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return HomePageContent(
          onListTapped: onListTapped,
        );
      },
    );
  }
}

class HomePageContent extends StatelessWidget {
  final ValueChanged<String> onListTapped;

  const HomePageContent({Key? key, required this.onListTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mom's List",
          style: TextStyle(color: Theme.of(context).textTheme.headline1?.color),
        ),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read(appModelProvider).addList(MomList("Test"));
            },
          )
        ],
      ),
      body: _HomePageLists(
        onListTapped: onListTapped,
      ),
    );
  }
}

class _HomePageLists extends HookWidget {
  final ValueChanged<String> onListTapped;

  const _HomePageLists({Key? key, required this.onListTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lists = useProvider(orderedMomListProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Add a List",
              labelStyle: TextStyle(color: Colors.black),
            ),
            onSubmitted: (text) => {
              context.read(appModelProvider).addList(MomList(text)),
            },
          ),
        ),
        Expanded(
          child: ReorderableListView(
            children: [
              for (final list in lists)
                ListTile(
                  key: ValueKey(list.title),
                  title: Text(list.title),
                  trailing: Icon(Icons.reorder_rounded),
                  onTap: () => onListTapped(list.id),
                )
            ],
            onReorder: (oldIndex, newIndex) =>
                context.read(appModelProvider).reorderList(oldIndex, newIndex),
          ),
        ),
      ],
    );
  }
}
