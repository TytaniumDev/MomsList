
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moms_list/model/parent_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mom's List"),
      ),
      body: _HomePageLists(),
    );
  }
}

class _HomePageLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeListModel>(
      builder: (context, parentLists, child) {
        return ReorderableListView(
          children: [
            for (final list in parentLists.lists)
              ListTile(
                key: ValueKey(list.title),
                title: Text(list.title),
              )
          ],
          onReorder: Provider.of<HomeListModel>(context, listen: false).reorderList,
        );
      },
    );
  }
}

