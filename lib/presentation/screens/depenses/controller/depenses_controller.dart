import 'package:co_habit_frontend/data/models/depense_model.dart';
import 'package:co_habit_frontend/domain/usecases/depenses/get_all_depenses_uc.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';

class DepensesController {
  final GetAllDepensesUc getAllDepensesUc;
  final DepensesProvider depensesProvider;
  final int colocationId;

  DepensesController(
      {required this.getAllDepensesUc,
      required this.depensesProvider,
      required this.colocationId});

  Future<void> loadDepenses() async {
    final depenses = await getAllDepensesUc.execute(colocationId);
    final depensesList = depenses.whereType<DepenseModel>().toList();
    depensesProvider.setDepenses(depensesList);
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
}
