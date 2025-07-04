import 'package:co_habit_frontend/data/models/requests/depense_request.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class CreerDepenseUc {
  final DepensesRepository depensesRepository;

  CreerDepenseUc({required this.depensesRepository});

  Future<DepenseEntity> execute(DepenseRequest request) async =>
      await depensesRepository.save(request);
}
