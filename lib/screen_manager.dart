import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenManager with ChangeNotifier {
  int _numberOfScreens = 1;
  int _currentIndex = 0;

  int get numberOfScreens => _numberOfScreens;
  int get currentIndex => _currentIndex;

  set numberOfScreens(int number) {
    _numberOfScreens = number;
    notifyListeners();
  }

  List<String> generateRoutes() {
    final List<String> routes = [];
    for (int i = 1; i <= numberOfScreens; i++) {
      final routeName = '/screen_$i';
      routes.add(routeName);
    }
    return routes;
  }
}
