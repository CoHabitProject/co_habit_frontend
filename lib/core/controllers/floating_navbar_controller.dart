import 'package:flutter/material.dart';

class FloatingNavbarController extends ChangeNotifier {
  VoidCallback? _onPressed;
  bool _visible = true;
  Map<String, VoidCallback> _routeActions = {};

  VoidCallback? get onPressed => _onPressed;
  bool get visible => _visible;

  void show({VoidCallback? action}) {
    _visible = true;
    _onPressed = action;
    notifyListeners();
  }

  void hide() {
    _visible = false;
    _onPressed = null;
    notifyListeners();
  }

  void trigger() {
    _onPressed?.call();
  }

  void setActionForRoute(String route, VoidCallback action) {
    _routeActions[route] = action;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visible = true;
      notifyListeners();
    });
  }

  void triggerForRoute(String route) {
    _routeActions[route]?.call();
  }
}
