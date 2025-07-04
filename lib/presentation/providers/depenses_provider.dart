import 'package:co_habit_frontend/data/models/depense_model.dart';
import 'package:flutter/material.dart';

class DepensesProvider extends ChangeNotifier {
  final List<DepenseModel> _depenses = [];

  List<DepenseModel> get depenses => _depenses;

  void setDepenses(List<DepenseModel> depenseList) {
    _depenses
      ..clear()
      ..addAll(depenseList);
    notifyListeners();
  }

  void addDepense(DepenseModel depense) {
    _depenses.add(depense);
    notifyListeners();
  }

  void updateDepense(DepenseModel update) {
    final index = _depenses.indexWhere((d) => d.id == update.id);
    if (index != 1) {
      _depenses[index] = update;
      notifyListeners();
    }
  }

  void removeDepense(int id) {
    _depenses.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  void clearDepenses() {
    _depenses.clear();
    notifyListeners();
  }
}
