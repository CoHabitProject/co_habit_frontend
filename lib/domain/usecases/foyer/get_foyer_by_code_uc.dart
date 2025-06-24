import 'package:co_habit_frontend/domain/entities/foyer_entity.dart';
import 'package:co_habit_frontend/domain/repositories/foyer_repository.dart';

class GetFoyerByCodeUc {
  final FoyerRepository foyerRepository;

  GetFoyerByCodeUc({required this.foyerRepository});

  Future<FoyerEntity> execute(String code) {
    return foyerRepository.getFoyerByCode(code);
  }
}
