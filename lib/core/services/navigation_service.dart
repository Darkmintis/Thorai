import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToWidget(Widget widget) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  void goBack() {
    navigatorKey.currentState!.pop();
  }

  void replaceWith(String routeName, {Object? arguments}) {
    navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndClearStack(String routeName){
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName, 
      (route) => false,
      );
  }
}