import 'dart:io';

import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:co_habit_frontend/presentation/screens/home/widgets/custom_app_bar.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/controllers/stock_controller.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/widgets/stock_card.dart';
import 'package:co_habit_frontend/presentation/screens/taches/widgets/taches_card.dart';
import 'package:co_habit_frontend/presentation/widgets/common/flexible_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StockController _stockController;
  List<TacheEntity> tachesRecentes = [];
  bool tachesIsLoading = true;
  List<StockModel> lowestStock = [];
  UtilisateurModel? currentUser;

  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      currentUser = authProvider.user;
    }
    _loadRecentTaches();
    _loadLowestStock();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller =
          Provider.of<FloatingNavbarController>(context, listen: false);
      controller.hide(); // Cache le bouton sur cet écran
    });
  }

  Future<void> _loadRecentTaches() async {
    try {
      final useCase = getIt<GetLastCreatedTachesUc>();
      final taches = await useCase.execute();

      setState(() {
        tachesRecentes = taches;
        tachesIsLoading = false;
      });
    } catch (e) {
      stderr.write("Error : $e");
    }
  }

  Future<void> _loadLowestStock() async {
    final prefs = await SharedPreferences.getInstance();
    final colocId = prefs.getInt('foyerId');

    if (!mounted || colocId == null) return;

    _stockController = StockController(
      getAllStockUc: getIt<GetAllStockUc>(),
      getAllStockItemsUc: getIt<GetAllStockItemsUc>(),
      stockProvider: context.read<StockProvider>(),
      colocationId: colocId,
    );

    final stock = await _stockController.getLowestStock();

    setState(() {
      lowestStock = stock;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            firstName: currentUser!.firstName,
            lastName: currentUser!.lastName,
            avatarColor: Colors.blueAccent),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _BuildHeaderCards(),
                const SizedBox(height: 12),
                _buildSectionTitle('Tâches Récentes'),
                const SizedBox(height: 12),
                if (tachesIsLoading)
                  const CircularProgressIndicator()
                else if (tachesRecentes.isEmpty)
                  const Text('Aucune tâche récente')
                else
                  ...tachesRecentes.map(
                    (tache) => TachesCard(
                        title: tache.title,
                        titleWeight: FontWeight.w700,
                        titleSize: 18,
                        text: tache.category,
                        textColor: Colors.blueGrey,
                        date: tache.date,
                        status: tache.status,
                        initials: _getInitials(tache.firstName, tache.lastName),
                        width: 150,
                        height: 90,
                        borderRadius: 20,
                        avatarColor: Colors.grey),
                  ),
                const SizedBox(height: 10),
                _buildSectionTitle('Stock'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: lowestStock
                      .map((stock) => StockCard(
                            title: stock.title,
                            itemCount: stock.itemCount,
                            totalItems: stock.totalItems,
                            color: stock.color,
                            imageAsset: stock.imageAsset,
                            itemCountPercentage: stock.itemCountPercentage,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
      ),
    );
  }

  String _getInitials(String first, String last) {
    return '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}';
  }
}

class _BuildHeaderCards extends StatelessWidget {
  const _BuildHeaderCards();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        FlexibleCard(
          title: 'Dépenses',
          width: 200,
          height: 125,
          text: '725.46',
          icon: Icons.euro,
          borderRadius: 10,
          iconPosition: IconPosition.left,
          titleColor: Colors.black,
          titleSize: 17,
          titleWeight: FontWeight.normal,
          cardColor: AppTheme.homeCardBackroundColor,
          iconColor: Colors.black,
          textSize: 30,
          textWeight: FontWeight.bold,
        ),
        SizedBox(
          width: 10,
        ),
        FlexibleCard(
          title: 'Mes tâches',
          width: 170,
          height: 125,
          text: '03',
          icon: null,
          borderRadius: 10,
          textSize: 40,
          padding: EdgeInsets.all(15),
          textWeight: FontWeight.bold,
          titleSize: 17,
          cardColor: AppTheme.homeCardBackroundColor,
          textColor: AppTheme.darkPrimaryColor,
        )
      ],
    );
  }
}
