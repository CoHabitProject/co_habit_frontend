import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class GetAllDepensesUc {
  final DepensesRepository depensesRepository;

  GetAllDepensesUc({required this.depensesRepository});

  Future<List<DepenseEntity>> execute(int colocationId) async =>
      await depensesRepository.getAllDepenses(colocationId);
}
