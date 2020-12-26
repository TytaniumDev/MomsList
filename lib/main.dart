import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moms_list/navigation.dart';
import 'package:moms_list/repositories/app_model_repository.dart';

void main() {
  runApp(ProviderScope(observers: [Logger()], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Mom's List",
      theme: ThemeData(),
      routerDelegate: MomsListRouterDelegate(),
      routeInformationParser: MomsListRouteInformationParser(),
    );
  }
}

/// Creates an [AppModelRepository] and initialise it.
///
/// We are using [StateNotifierProvider] here as AppModel is a complex
/// object, with advanced business logic and functions.
final appModelProvider = StateNotifierProvider<AppModelRepository>((ref) {
  return AppModelRepository(null);
});

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object newValue) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
