import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/data/models/tache_category_model.dart';
import 'package:co_habit_frontend/domain/usecases/taches/create_tache_uc.dart';
import 'package:co_habit_frontend/domain/usecases/taches/get_all_taches_uc.dart';
import 'package:co_habit_frontend/domain/usecases/taches/get_last_created_taches_uc.dart';
import 'package:co_habit_frontend/domain/usecases/taches/get_tache_by_id_uc.dart';
import 'package:co_habit_frontend/presentation/providers/taches_provider.dart';
import 'package:co_habit_frontend/presentation/screens/taches/utils/tache_status_enum.dart';
import 'package:flutter/foundation.dart';

class TachesController {
  final CreerTacheUc creerTacheUC;
  final GetAllTachesUc getAllTachesUC;
  final GetLastCreatedTachesUc getLastCreatedTachesUc;
  final GetTacheByIdUc getTacheByIdUC;

  final TachesProvider tachesProvider;
  final int colocationId;

  TachesController({
    required this.creerTacheUC,
    required this.getAllTachesUC,
    required this.getLastCreatedTachesUc,
    required this.getTacheByIdUC,
    required this.tachesProvider,
    required this.colocationId
  });

  Future<void> loadTaches() async {
    // ==> FONCTIONNEMENT NORMAL
    // final taches = await getLastCreatedTachesUc.execute(colocationId);
    // final tachesList = taches.whereType<TacheModel>().toList();
    // tachesProvider.setTaches(tachesList);
    final tachesList = [
      TacheModel(
        id: 1,
        firstName: "Alice",
        lastName: "B.",
        title: "Passer l'aspirateur",
        date: DateTime.now(),
        category: "Tâche ménagère",
        status: TacheStatus.enCours,
      ),
      TacheModel(
        id: 2,
        firstName: "Bob",
        lastName: "C.",
        title: "Sortir les poubelles",
        date: DateTime.now().add(const Duration(days: 1)),
        category: "Tâche ménagère",
        status: TacheStatus.enAttente,
      ),
    ];

    tachesProvider.setTaches(tachesList);
  }

  Future<void> loadLastCreatedTaches() async {
    final taches = await getLastCreatedTachesUc.execute(colocationId);
    final tachesList = taches.whereType<TacheModel>().toList();
    tachesProvider.setTaches(tachesList);
  }

  Future<void> creerTache(TacheModel tache) async
  {
    await creerTacheUC.execute(tache, colocationId);
    tachesProvider.addTache(tache);
  }

  void addTache(TacheModel tache) {
    tachesProvider.addTache(tache);
  }

  void updateTache(TacheModel tache) {
    tachesProvider.updateTache(tache);
  }

  void removeTache(int idTache){
    tachesProvider.removeTache(idTache);
  }

  void clearTaches() {
    tachesProvider.clearTaches();
  }
}