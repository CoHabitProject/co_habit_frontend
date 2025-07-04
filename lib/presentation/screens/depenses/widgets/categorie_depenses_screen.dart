import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/presentation/providers/depenses_provider.dart';
import 'package:co_habit_frontend/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CategorieDepensesScreen extends StatefulWidget {
  final String categoryLabel;

  const CategorieDepensesScreen({super.key, required this.categoryLabel});

  @override
  State<CategorieDepensesScreen> createState() =>
      _CategorieDepensesScreenState();
}

class _CategorieDepensesScreenState extends State<CategorieDepensesScreen> {
  bool _isBottomSheetOpen = false;

  void _showDepensesMenu(BuildContext context, List<ListTile> actions) {
    if (_isBottomSheetOpen) return;
    _isBottomSheetOpen = true;
    showCustomActionSheet(
            context: context,
            title: 'Ajouter une nouvelle dépense',
            subTitle: 'Tu peux ajouter une dépense ou catégorie',
            actions: actions)
        .whenComplete(
      () => _isBottomSheetOpen = false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<FloatingNavbarController>().setActionForRoute(
      '/depenses/${widget.categoryLabel}',
      () {
        _showDepensesMenu(context, [
          ListTile(
            title: const Text('Ajouter une dépense',
                style: TextStyle(color: Colors.blue)),
            onTap: () {
              Navigator.pop(context);
              context.push('/creerDepense');
            },
          )
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allDepenses = context.watch<DepensesProvider>().depenses;

    final isSansCategorie = widget.categoryLabel == 'sansCategorie';
    final filtered = isSansCategorie
        ? allDepenses.where((d) => d.category == null).toList()
        : allDepenses
            .where((d) => d.category?.label == widget.categoryLabel)
            .toList();

    final total = filtered.fold<double>(0.0, (sum, d) => sum + d.amount);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: ScreenAppBar(title: widget.categoryLabel),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: filtered.isEmpty
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Aucune dépense dans cette catégorie',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total : € ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final d = filtered[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(
                                  d.description,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Par ${d.user.firstName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text('€ ${d.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
