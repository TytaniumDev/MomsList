// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:moms_list/model/parent_list.dart';

final homeListsProvider = StateNotifierProvider((ref) => HomeListsNotifier());

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final List<ParentList> homeLists = watch(homeListsProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mom's List"),
      ),
      body: ReorderableListView(
        children: [
          for (final list in homeLists)
            ListTile(
              key: ValueKey(list.title),
              title: Text(list.title),
            )
        ],
        onReorder: context.read(homeListsProvider).reorderList,
      ),
    );
  }
}
