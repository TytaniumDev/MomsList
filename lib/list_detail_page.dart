import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListDetailPage extends Page {
  final String listId;

  ListDetailPage({
    required this.listId,
  }) : super(key: ValueKey(listId));

  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return ListDetailContent(
          listId: listId,
        );
      },
    );
  }
}

class ListDetailContent extends StatelessWidget {
  final String listId;

  const ListDetailContent({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: Icon(Icons.sort), onPressed: () {}),
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Text("This is where the title goes"),
        ],
      ),
    );
  }
}
