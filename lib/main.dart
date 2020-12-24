import 'package:flutter/material.dart';
import 'package:moms_list/navigation.dart';
import 'package:moms_list/repositories/notifiers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeListViewModel())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<HomeListViewModel>(context, listen: false).init();
    return MaterialApp.router(
      title: "Mom's List",
      theme: ThemeData(),
      routerDelegate: MomsListRouterDelegate(),
      routeInformationParser: MomsListRouteInformationParser(),
    );
  }
}
