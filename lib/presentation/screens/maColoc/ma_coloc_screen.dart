import 'dart:io';

import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/screens/maColoc/widgets/stock_card.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class MaColocScreen extends StatefulWidget {
  const MaColocScreen({super.key});

  @override
  State<MaColocScreen> createState() => _MaColocScreenState();
}

class _MaColocScreenState extends State<MaColocScreen> {
  List<StockEntity> stock = [];
  FoyerEntity? foyer;

  @override
  void initState() {
    super.initState();
    _loadStock();
    _loadFoyer();
  }

  Future<void> _loadFoyer() async {
    try {
      final useCase = getIt<GetFoyerByCodeUc>();
      final foyerData = await useCase.execute('code');

      setState(() {
        foyer = foyerData;
      });
    } catch (e) {
      stderr.write('Error : $e');
    }
  }

  Future<void> _loadStock() async {
    try {
      final useCase = getIt<GetAllStockUc>();
      final stockData = await useCase.execute();

      setState(() {
        stock = stockData;
      });
    } catch (e) {
      stderr.write('Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          foyer?.name ?? 'Ma coloc',
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
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
              _buildStockSection(stock),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        elevation: 4,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavbar(showCenterButton: true),
    );
  }

  Widget _buildCodeSection(String code) {
    return Column(
      children: [
        const Text("Code", style: TextStyle(color: Colors.grey)),
        const SizedBox(
          height: 5,
        ),
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

  Widget _buildStockSection(List<StockEntity> stock) {
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
            imageAsset: s.imageAsset);
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
