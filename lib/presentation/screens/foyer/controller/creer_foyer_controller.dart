import 'dart:ui';

import 'package:co_habit_frontend/data/models/foyer_model.dart';
import 'package:co_habit_frontend/data/models/requests/creer_foyer_request.dart';
import 'package:co_habit_frontend/data/models/requests/stock_request.dart';
import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';

class CreerFoyerController {
  final CreerFoyerUseCase creerFoyerUc;
  final CreerStockUc creerStockUc;
  final FoyerProvider foyerProvider;
  final StockProvider stockProvider;

  CreerFoyerController(
      {required this.creerFoyerUc,
      required this.creerStockUc,
      required this.foyerProvider,
      required this.stockProvider});

  Future<void> creerFoyerEtStocks(CreerFoyerRequest request) async {
    // création du foyer
    final foyer = await creerFoyerUc.execute(request);
    foyerProvider.setFoyer(foyer as FoyerModel);

    // création de stocks par défaut
    final defaultStockRequests = [
      StockRequest(
          title: 'Hygiène',
          imageAsset: 'assets/images/stock/soap.png',
          color: const Color(0xFF369FFF).toString(),
          maxCapacity: 50),
      StockRequest(
          title: 'Entretien',
          imageAsset: 'assets/images/stock/soap.png',
          color: const Color(0xFFFF993A).toString(),
          maxCapacity: 50),
      StockRequest(
          title: 'Courses',
          imageAsset: 'assets/images/stock/soap.png',
          color: const Color(0xFF8AC53E).toString(),
          maxCapacity: 100),
    ];

    // Création + récupération des models
    final List<StockModel> createdStocks = [];
    for (final req in defaultStockRequests) {
      final stock = await creerStockUc.execute(req);
      if (stock is StockModel) {
        createdStocks.add(stock);
      }
    }

    stockProvider.setStock(createdStocks);
  }
}
