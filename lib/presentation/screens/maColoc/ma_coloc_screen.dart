import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/usecases/stock/get_all_stock_items_uc.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/controllers/stock_controller.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/widgets/stock_card.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MaColocScreen extends StatefulWidget {
  const MaColocScreen({super.key});

  @override
  State<MaColocScreen> createState() => _MaColocScreenState();
}

class _MaColocScreenState extends State<MaColocScreen> {
  FoyerEntity? foyer;
  bool _isBottomSheetOpen = false;
  // Stock controller
  late final StockController stockController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<FloatingNavbarController>().setActionForRoute(
      '/maColoc',
      () {
        showStockMenu(context, [
          ListTile(
            title: const Text('Ajouter un type de stock',
                style: TextStyle(color: Colors.blue)),
            onTap: () {
              Navigator.pop(context);
              context.push('/creerStock');
            },
          ),
        ]);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFoyer();
  }

  void showStockMenu(BuildContext context, List<ListTile> actions) {
    if (_isBottomSheetOpen) return;
    _isBottomSheetOpen = true;
    showCustomActionSheet(
            context: context,
            title: 'Ajout stock',
            subTitle: 'Vous pouvez ajouter un nouveau type de stock',
            actions: actions)
        .whenComplete(
      () => _isBottomSheetOpen = false,
    );
  }

  Future<void> _loadFoyer() async {
    try {
      final savedFoyer = context.read<FoyerProvider>().foyer;

      if (savedFoyer != null) {
        setState(() {
          foyer = savedFoyer;
        });

        _initController(savedFoyer.id);
        await stockController.loadAllStocksAndItems();
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  void _initController(int colocationId) {
    stockController = StockController(
        getAllStockUc: getIt<GetAllStockUc>(),
        getAllStockItemsUc: getIt<GetAllStockItemsUc>(),
        stockProvider: context.read<StockProvider>(),
        colocationId: colocationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(title: foyer?.name ?? ''),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCodeSection(foyer?.code ?? '12345'),
              const SizedBox(height: 20),
              _buildSectionTitle('Membres'),
              const SizedBox(height: 12),
              _buildMembresSection(foyer?.membres ?? []),
              const SizedBox(height: 20),
              _buildSectionTitle('Stock'),
              const SizedBox(height: 12),
              _buildStockSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeSection(String code) {
    return Column(
      children: [
        const Text("Code", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Text(
          code,
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black26)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildStockSection(BuildContext context) {
    final stock = context.watch<StockProvider>().stock;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stock.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2),
      itemBuilder: (context, index) {
        final s = stock[index];
        return StockCard(
          title: s.title,
          itemCount: s.itemCount,
          totalItems: s.totalItems,
          color: s.color,
          imageAsset: s.imageAsset,
          itemCountPercentage: s.itemCountPercentage,
          onTap: () {
            context.push('/maColoc/stock/${s.id}');
          },
        );
      },
    );
  }

  Widget _buildMembresSection(List<UtilisateurEntity> membres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 20,
        runSpacing: 20,
        children: membres.map((m) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  m.initials,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                m.firstName,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              Text(
                m.lastName,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                softWrap: true,
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}
