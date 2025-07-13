import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/models/tache_category_model.dart';
import 'package:flutter/cupertino.dart';

class TachesProvider extends ChangeNotifier {
  final List<TacheModel> _taches = [];
  final List<TacheCategoryModel> _categories = [
    TacheCategoryModel(label: 'Tâche ménagère'),
    TacheCategoryModel(label: 'Quotidien'),
    TacheCategoryModel(label: 'Ravitaillement')
  ];

  List<TacheModel> get taches => _taches;

  List<TacheCategoryModel> get categories => _categories;

  void addCategory(TacheCategoryModel category) {
    _categories.add(category);
    notifyListeners();
  }

  void setTaches(List<TacheModel> taches) {
    _taches
      ..clear()
      ..addAll(taches);
    notifyListeners();
  }

  void addTache(TacheModel tache) {
    _taches.add(tache);
    notifyListeners();
  }

  void updateTache(TacheModel updatedTache) {
    final index = _taches.indexWhere((t) => t.id == updatedTache.id);
    if(index!=1){
      _taches[index]=updatedTache;
      notifyListeners();
    }
  }

  void removeTache(int id){
    _taches.removeWhere((t)=>t.id==id);
    notifyListeners();
  }

  void clearTaches() {
    _taches.clear();
    notifyListeners();
  }
}