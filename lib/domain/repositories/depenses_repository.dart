import 'package:co_habit_frontend/data/models/requests/depense_request.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';

abstract class DepensesRepository {
  Future<List<DepenseEntity>> getAllDepenses(int colocationId);
  Future<DepenseEntity> save(DepenseRequest request, int colocationId);
}
