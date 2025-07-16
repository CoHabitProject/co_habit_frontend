import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/data/models/depense_model.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:co_habit_frontend/presentation/providers/depenses_provider.dart';
import 'package:co_habit_frontend/presentation/providers/foyer_provider.dart';
import 'package:co_habit_frontend/presentation/screens/depenses/controller/depenses_controller.dart';
import 'package:co_habit_frontend/presentation/screens/depenses/widgets/add_category_modal.dart';
import 'package:co_habit_frontend/presentation/screens/depenses/widgets/depense_card.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DepensesScreen extends StatefulWidget {
  const DepensesScreen({super.key});

  @override
  State<DepensesScreen> createState() => _DepensesScreenState();
}

class _DepensesScreenState extends State<DepensesScreen> {
  late DepensesController _depensesController;
  bool _controllerInitialized = false;
  String selectedMonth = '';
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth = '${_getMonthName(now.month)} ${now.year}';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final colocId = context.read<FoyerProvider>().colocId;
      final user = context.read<AuthProvider>().user;

      if (colocId == null || user == null) return;

      _depensesController = DepensesController(
        getAllDepensesUc: getIt<GetAllDepensesUc>(),
        creerDepenseUc: getIt<CreerDepenseUc>(),
        depensesProvider: context.read<DepensesProvider>(),
        colocationId: colocId,
      );

      await _depensesController.loadDepenses();

      setState(() {
        _controllerInitialized = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    List<ListTile> actions = [
      ListTile(
        title: const Text('Ajouter une dépense',
            style: TextStyle(color: Colors.blue)),
        onTap: () {
          Navigator.pop(context);
          context.push('/creerDepense');
        },
      ),
      ListTile(
        title: const Text('Ajouter une nouvelle catégorie',
            style: TextStyle(color: Colors.blue)),
        onTap: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (_) => const AddCategoryModal(),
          );
        },
      ),
    ];

    context.read<FloatingNavbarController>().setActionForRoute(
      '/depenses',
      () {
        showDepensesMenu(context, actions);
      },
    );
  }

  void showDepensesMenu(BuildContext context, List<ListTile> actions) {
    if (_isBottomSheetOpen) return;
    _isBottomSheetOpen = true;
    showCustomActionSheet(
      context: context,
      title: 'Ajouter une nouvelle dépense',
      subTitle: 'Tu peux ajouter une dépense ou catégorie',
      actions: actions,
    ).whenComplete(() => _isBottomSheetOpen = false);
  }

  String _getMonthName(int month) {
    const months = [
      "JANVIER",
      "FÉVRIER",
      "MARS",
      "AVRIL",
      "MAI",
      "JUIN",
      "JUILLET",
      "AOÛT",
      "SEPTEMBRE",
      "OCTOBRE",
      "NOVEMBRE",
      "DÉCEMBRE"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (!_controllerInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final provider = context.watch<DepensesProvider>();
    final grouped =
        _depensesController.grouperParCategoriesConnues(provider.categories);
    final total = _depensesController.calculerTotalDepensesColoc();
    final user = context.read<AuthProvider>().user;
    final userTotal = user != null
        ? _depensesController.calculerTotalDepensesUtilisateur(user.id)
        : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const ScreenAppBar(title: 'Dépenses'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(total),
              const SizedBox(height: 16),
              _buildMesDepensesCard(userTotal),
              const SizedBox(height: 24),
              _buildCategorieList(grouped),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double total) {
    return Column(
      children: [
        PopupMenuButton<String>(
          onSelected: (value) => setState(() {
            selectedMonth = value;
          }),
          itemBuilder: (context) => [
            'Mars 2025',
            'Avril 2025',
            'Mai 2025',
            'Juin 2025'
          ].map((m) => PopupMenuItem(value: m, child: Text(m))).toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(selectedMonth, style: const TextStyle(color: Colors.grey)),
              const Icon(Icons.arrow_drop_down, size: 20)
            ],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            context.push('/repartitionDepenses');
          },
          child: Text(
            '€ ${total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 40),
          ),
        ),
      ],
    );
  }

  Widget _buildMesDepensesCard(double montant) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Mes dépenses \n € ${montant.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildCategorieList(Map<String, List<DepenseModel>> grouped) {
    final nonEmpty = grouped.entries.where((e) => e.value.isNotEmpty).toList();
    final empty = grouped.entries.where((e) => e.value.isEmpty).toList();

    if (nonEmpty.isEmpty && empty.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 48),
        child: Column(
          children: [
            Icon(Icons.info_outline, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text("Aucune dépense enregistrée",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...nonEmpty.map((e) => _buildCategorieSection(e.key, e.value)),
        if (empty.isNotEmpty) const SizedBox(height: 24),
        ...empty.map((e) => _buildCategorieSection(e.key, e.value)),
      ],
    );
  }

  Widget _buildCategorieSection(String category, List<DepenseModel> items) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (items.isNotEmpty) {
          context.push('/depenses/${Uri.encodeComponent(category)}');
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getCategoryIcon(category), size: 20),
                const SizedBox(width: 8),
                Text(category,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.grey),
                    SizedBox(width: 6),
                    Text("Aucune dépense dans cette catégorie",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            else
              Column(
                  children: items.map((d) => ExpenseCard(depense: d)).toList()),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'courses':
        return Icons.shopping_cart;
      case 'abonnements':
        return Icons.subscriptions;
      case 'sanscategorie':
        return Icons.help_outline;
      default:
        return Icons.receipt_long;
    }
  }
}
