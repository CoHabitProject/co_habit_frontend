import 'package:co_habit_frontend/domain/entities/tache_entity.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class GetTacheByIdUc {
  final TacheRepository tachesRepository;

  GetTacheByIdUc({required this.tachesRepository});

  Future<TacheEntity> execute(int id, int colocationId) async =>
      await tachesRepository.getTacheById(id, colocationId);
}