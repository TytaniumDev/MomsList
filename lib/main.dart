import 'package:flutter/material.dart';
import 'package:moms_list/home_page.dart';
import 'package:moms_list/repositories/notifiers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeListViewModel())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeListViewModel>(context, listen: false)
        .init();
    return MaterialApp(
      title: "Mom's List",
      theme: ThemeData(
      ),
      home: HomePage(),
    );
  }
}
