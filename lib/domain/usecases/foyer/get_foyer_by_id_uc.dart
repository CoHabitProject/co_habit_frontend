import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class GetFoyerByIdUc {
  final FoyerRepository foyerRepository;

  GetFoyerByIdUc({required this.foyerRepository});

  Future<FoyerEntity> execute(int id) async {
    return await foyerRepository.getFoyerById(id);
  }
}
