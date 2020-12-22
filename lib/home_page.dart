import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moms_list/repositories/notifiers.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
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
              Provider.of<HomeListViewModel>(context, listen: false)
                  .addList("Test");
            },
          )
        ],
      ),
      body: _HomePageLists(),
    );
  }
}

class _HomePageLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeListViewModel>(
      builder: (context, parentLists, child) {
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
                  Provider.of<HomeListViewModel>(context, listen: false)
                      .addList(text),

                },
              ),
            ),
            Expanded(
              child: ReorderableListView(
                children: [
                  for (final list in parentLists.lists)
                    ListTile(
                      key: ValueKey(list.title),
                      title: Text(list.title),
                    )
                ],
                onReorder:
                    Provider.of<HomeListViewModel>(context, listen: false)
                        .reorderList,
              ),
            ),
          ],
        );
      },
    );
  }
}
