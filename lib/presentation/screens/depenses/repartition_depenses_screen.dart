import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/domain/entities/utilisateur_entity.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepartitionDepensesScreen extends StatelessWidget {
  const RepartitionDepensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final depensesProvider = context.watch<DepensesProvider>();
    final colocataires =
        Provider.of<FoyerProvider>(context, listen: false).foyer!.membres;

    // Appel à la fonction de répartition (à mettre dans un controller si tu veux)
    final Map<int, double> repartition =
        calculerRepartitionEquitable(colocataires, depensesProvider.depenses);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Répartition des dépenses"),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: repartition.entries.map((entry) {
            final user = colocataires.firstWhere((u) => u.id == entry.key);
            final montant = entry.value;
            final couleur = montant > 0
                ? Colors.green
                : (montant < 0 ? Colors.red : Colors.grey);

            return ListTile(
              leading: CircleAvatar(child: Text(user.initials)),
              title: Text("${user.firstName} ${user.lastName}"),
              subtitle: Text(
                montant > 0
                    ? "Doit recevoir ${montant.toStringAsFixed(2)} €"
                    : montant < 0
                        ? "Doit ${(-montant).toStringAsFixed(2)} €"
                        : "Équilibré",
              ),
              trailing: Text(
                "${montant.toStringAsFixed(2)} €",
                style: TextStyle(color: couleur, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Map<int, double> calculerRepartitionEquitable(
    List<UtilisateurEntity> colocataires,
    List depenses,
  ) {
    final repartition = <int, double>{
      for (final user in colocataires) user.id: 0.0
    };

    for (final depense in depenses) {
      final montantParPersonne = depense.amount / colocataires.length;

      for (final coloc in colocataires) {
        repartition[coloc.id] =
            (repartition[coloc.id] ?? 0) - montantParPersonne;
      }

      repartition[depense.user.id] =
          (repartition[depense.user.id] ?? 0) + depense.amount;
    }

    return repartition;
  }
}
