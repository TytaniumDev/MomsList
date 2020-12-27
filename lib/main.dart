// @dart=2.9
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moms_list/navigation.dart';
import 'package:moms_list/repositories/app_model_repository.dart';

void main() {
  runApp(ProviderScopedApp());
}

class ProviderScopedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(observers: [Logger()], child: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  MomsListRouterDelegate _routerDelegate = MomsListRouterDelegate();
  MomsListRouteInformationParser _routeInformationParser = MomsListRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Mom's List",
      theme: ThemeData(),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
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
