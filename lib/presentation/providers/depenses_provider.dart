import 'package:co_habit_frontend/data/models/depense_category_model.dart';
import 'package:co_habit_frontend/data/models/depense_model.dart';
import 'package:flutter/material.dart';

class DepensesProvider extends ChangeNotifier {
  final List<DepenseModel> _depenses = [];
  final List<DepenseCategoryModel> _categories = [
    DepenseCategoryModel(label: 'Courses', icon: 'shopping_cart'),
    DepenseCategoryModel(label: 'Abonnement', icon: 'subscriptions')
  ];

  List<DepenseModel> get depenses => _depenses;

  List<DepenseCategoryModel> get categories => _categories;

  void addCategory(DepenseCategoryModel category) {
    _categories.add(category);
    notifyListeners();
  }

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
