import 'package:flutter/material.dart';

class navigationservice {
  late final GlobalKey<NavigatorState> navigationKey;

  static final navigationservice instance = navigationservice();

  navigationservice() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _rn) {
    return navigationKey.currentState!.pushReplacementNamed(_rn);
  }

  Future<dynamic> navigateTo(String _rn) {
    return navigationKey.currentState!.pushNamed(_rn);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _rn) {
    return navigationKey.currentState!.push(_rn);
  }

  goBack() {
    return navigationKey.currentState!.pop();
  }
}
