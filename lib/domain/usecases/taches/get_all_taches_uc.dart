import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/repositories/repositories.dart';

class GetAllTachesUc {
  final TacheRepository tachesRepository;

  GetAllTachesUc({required this.tachesRepository});

  Future<List<TacheEntity>> execute(int colocationId) async =>
      await tachesRepository.getAllTaches(colocationId);
}