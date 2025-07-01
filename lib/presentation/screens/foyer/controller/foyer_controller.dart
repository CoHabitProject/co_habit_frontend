import 'package:co_habit_frontend/data/models/foyer_model.dart';
import 'package:co_habit_frontend/data/models/requests/creer_foyer_request.dart';
import 'package:co_habit_frontend/data/models/requests/stock_request.dart';
import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';

class FoyerController {
  final CreerFoyerUseCase creerFoyerUc;
  final CreerStockUc creerStockUc;
  final GetFoyerByCodeUc? getFoyerByCodeUc;
  final FoyerProvider foyerProvider;
  final StockProvider stockProvider;

  FoyerController(
      {this.getFoyerByCodeUc,
      required this.creerFoyerUc,
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
          color: '0xFF369FFF',
          maxCapacity: 50),
      StockRequest(
          title: 'Entretien',
          imageAsset: 'assets/images/stock/soap.png',
          color: '0xFFFF993A',
          maxCapacity: 50),
      StockRequest(
          title: 'Courses',
          imageAsset: 'assets/images/stock/soap.png',
          color: '0xFF8AC53E',
          maxCapacity: 100),
    ];

    // Création + récupération des models
    final createdStocks = await Future.wait(
      defaultStockRequests.map((stock) async {
        final entity = await creerStockUc.execute(stock, foyer.id);
        return StockModel.fromEntity(entity);
      }),
    );
    stockProvider.setStock(createdStocks);
  }

  Future<void> rejoindreColoc(String code) async {
    if (getFoyerByCodeUc == null) {
      throw Exception("GetFoyerByCodeUc non initialisé");
    }
    final foyer = await getFoyerByCodeUc!.execute(code);
    foyerProvider.setFoyer(foyer as FoyerModel);
  }
}
