import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:moms_list/main.dart';
import 'package:moms_list/repositories/app_model.dart';

final listDetailProvider = Provider.family<MomList, String>((ref, listId) {
   final appModel = ref.watch(appModelProvider.state);
   return appModel.lists.firstWhere((element) => element.id == listId);
});

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

class ListDetailContent extends HookWidget {
  final String listId;

  const ListDetailContent({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final momList = useProvider(listDetailProvider(listId));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            labelText: momList.title,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: Icon(Icons.sort), onPressed: () {}),
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Text(momList.title, style: Theme.of(context).textTheme.headline1,),
        ],
      ),
    );
  }
}
