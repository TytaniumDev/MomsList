import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moms_list/repositories/notifiers.dart';
import 'package:provider/provider.dart';

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
          style: TextStyle(color: Theme
              .of(context)
              .textTheme
              .headline1
              ?.color),
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
      body: _HomePageLists(onListTapped: onListTapped,),
    );
  }
}

class _HomePageLists extends StatelessWidget {
  final ValueChanged<String> onListTapped;

  const _HomePageLists({Key? key, required this.onListTapped})
      : super(key: key);

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
                onSubmitted: (text) =>
                {
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
                      onTap: () => onListTapped(list.title),
                    )
                ],
                onReorder:
                Provider
                    .of<HomeListViewModel>(context, listen: false)
                    .reorderList,
              ),
            ),
          ],
        );
      },
    );
  }
}
