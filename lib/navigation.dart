import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moms_list/home_page.dart';
import 'package:moms_list/list_detail_page.dart';

class MomsListRouteInformationParser
    extends RouteInformationParser<MomsListRoutePath> {
  @override
  Future<MomsListRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return MomsListRoutePath.home();
    }

    // Handle '/list/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'list') return MomsListRoutePath.unknown();
      var listId = uri.pathSegments[1];
      return MomsListRoutePath.details(listId);
    }

    // Handle unknown routes
    return MomsListRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(MomsListRoutePath path) {
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/list/${path.listId}');
    }
    return RouteInformation(location: '/404');
  }
}

class MomsListRouterDelegate extends RouterDelegate<MomsListRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MomsListRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  String? _selectedListId;
  bool show404 = false;

  MomsListRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  MomsListRoutePath get currentConfiguration {
    if (show404) {
      return MomsListRoutePath.unknown();
    }
    return _selectedListId == null
        ? MomsListRoutePath.home()
        : MomsListRoutePath.details(_selectedListId);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        HomePage(_handleListTapped),
        if (show404)
          CupertinoPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
        else if (_selectedListId != null)
          ListDetailPage(listId: _selectedListId!, navigateHome: _navigateHome)
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        _selectedListId = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(MomsListRoutePath path) async {
    if (path.isUnknown) {
      _selectedListId = null;
      show404 = true;
      return;
    }

    if (path.isDetailsPage) {
      if (path.listId == null) {
        show404 = true;
        return;
      }

      _selectedListId = path.listId;
    } else {
      _selectedListId = null;
    }

    show404 = false;
  }

  void _navigateHome() {
    _selectedListId = null;
    notifyListeners();
  }

  void _handleListTapped(String listId) {
    _selectedListId = listId;
    notifyListeners();
  }
}

class MomsListRoutePath {
  final String? listId;
  final bool isUnknown;

  MomsListRoutePath.home()
      : listId = null,
        isUnknown = false;

  MomsListRoutePath.details(this.listId) : isUnknown = false;

  MomsListRoutePath.unknown()
      : listId = null,
        isUnknown = true;

  bool get isHomePage => listId == null;

  bool get isDetailsPage => listId != null;
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}