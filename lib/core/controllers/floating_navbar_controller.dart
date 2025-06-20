import 'package:flutter/material.dart';

class FloatingNavbarController extends ChangeNotifier {
  VoidCallback? _onPressed;
  bool _visible = true;

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
}
