import 'package:co_habit_frontend/data/models/depense_category_model.dart';
import 'package:co_habit_frontend/data/models/depense_model.dart';
import 'package:co_habit_frontend/data/models/requests/depense_request.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';

class DepensesController {
  final GetAllDepensesUc getAllDepensesUc;
  final CreerDepenseUc creerDepenseUc;
  final DepensesProvider depensesProvider;
  final int colocationId;

  DepensesController(
      {required this.getAllDepensesUc,
      required this.creerDepenseUc,
      required this.depensesProvider,
      required this.colocationId});

  Future<void> loadDepenses() async {
    final depenses = await getAllDepensesUc.execute(colocationId);
    final depensesList = depenses.whereType<DepenseModel>().toList();
    depensesProvider.setDepenses(depensesList);
  }

  Future<void> creerDepense(
      DepenseRequest request, DepenseCategoryModel category) async {
    final DepenseModel created =
        await creerDepenseUc.execute(request) as DepenseModel;

    created.category = category;

    depensesProvider.addDepense(created);
  }

  double calculerTotalDepensesColoc() {
    return depensesProvider.depenses.fold(0.0, (total, d) => total + d.amount);
  }

  double calculerTotalDepensesUtilisateur(int userId) {
    return depensesProvider.depenses
        .where((d) => d.user.id == userId)
        .fold(0.0, (total, d) => total + d.amount);
  }

  void addDepense(DepenseModel depense) {
    depensesProvider.addDepense(depense);
  }

  void updateDepense(DepenseModel depense) {
    depensesProvider.updateDepense(depense);
  }

  void removeDepense(int depenseId) {
    depensesProvider.removeDepense(depenseId);
  }

  void clearDepenses() {
    depensesProvider.clearDepenses();
  }

  Map<String, List<DepenseModel>> grouperParCategoriesConnues(
      List<DepenseCategoryModel> categories) {
    final grouped = <String, List<DepenseModel>>{};
    final depenses = depensesProvider.depenses;

    for (final cat in categories) {
      grouped[cat.label] =
          depenses.where((d) => d.category?.label == cat.label).toList();
    }

    // Ajouter un groupe "Sans catégorie"
    final sansCategorie = depenses.where((d) => d.category == null).toList();
    if (sansCategorie.isNotEmpty) {
      grouped['sansCategorie'] = sansCategorie;
    }

    return grouped;
  }
}
