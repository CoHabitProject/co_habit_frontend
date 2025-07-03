import 'package:co_habit_frontend/data/models/foyer_model.dart';
import 'package:co_habit_frontend/data/models/requests/creer_foyer_request.dart';
import 'package:co_habit_frontend/data/models/requests/stock_request.dart';
import 'package:co_habit_frontend/data/models/stock_model.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoyerController {
  final CreerFoyerUseCase creerFoyerUc;
  final CreerStockUc creerStockUc;
  final GetFoyerByCodeUc? getFoyerByCodeUc;
  final GetFoyerByIdUc? getFoyerByIdUc;
  final FoyerProvider foyerProvider;
  final StockProvider stockProvider;

  FoyerController(
      {this.getFoyerByCodeUc,
      this.getFoyerByIdUc,
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
          color: const Color(0xFF369FFF).toHexString(),
          maxCapacity: 50),
      StockRequest(
          title: 'Entretien',
          imageAsset: 'assets/images/stock/soap.png',
          color: const Color(0xFFFF993A).toHexString(),
          maxCapacity: 50),
      StockRequest(
          title: 'Courses',
          imageAsset: 'assets/images/stock/soap.png',
          color: const Color(0xFF8AC53E).toHexString(),
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

    // On fait la sauvegarde aussi dans SharedPreferences pour check lors du lancement de l'application
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('foyerId', foyer.id);
  }

  Future<void> rejoindreColoc(String code) async {
    if (getFoyerByCodeUc == null) {
      throw Exception('GetFoyerByCodeUc non initialisé');
    }
    final foyer = await getFoyerByCodeUc!.execute(code);
    foyerProvider.setFoyer(foyer as FoyerModel);
    // On fait la sauvegarde aussi dans SharedPreferences pour check lors du lancement de l'application
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('foyerId', foyer.id);
  }

  Future<void> setFoyerFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('foyerId');
    if (getFoyerByIdUc == null) {
      throw Exception('GetFoyerByIdUc non initialisé');
    }

    if (id == null) {
      throw Exception('id du foyer pas présent dans shared preférences');
    }
    final foyer = await getFoyerByIdUc!.execute(id);
    foyerProvider.setFoyer(foyer as FoyerModel);
  }
}
