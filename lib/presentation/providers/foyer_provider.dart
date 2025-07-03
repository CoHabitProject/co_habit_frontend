import 'package:co_habit_frontend/data/models/models.dart';
import 'package:flutter/material.dart';

class FoyerProvider extends ChangeNotifier {
  FoyerModel? _foyer;

  FoyerModel? get foyer => _foyer;
  int? get colocId => _foyer?.id;

  void setFoyer(FoyerModel foyer) {
    _foyer = foyer;
    notifyListeners();
  }

  void clearFoyer() {
    _foyer = null;
    notifyListeners();
  }
}
