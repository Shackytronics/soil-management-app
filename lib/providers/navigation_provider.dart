import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    5,
    (_) => GlobalKey<NavigatorState>(),
  );

  int get currentIndex => _currentIndex;

  void switchTab(int index) {
    if (_currentIndex == index) {
      // Tapping the active tab pops to its root screen.
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
