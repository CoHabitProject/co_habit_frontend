import 'package:flutter/material.dart';

enum TacheStatus { termine, enCours, enAttente, annule }

extension TacheStatusExtension on TacheStatus {
  Color get color {
    switch (this) {
      case TacheStatus.termine:
        return Colors.green;
      case TacheStatus.enCours:
        return Colors.orange;
      case TacheStatus.enAttente:
        return Colors.grey;
      case TacheStatus.annule:
        return Colors.red;
    }
  }

  String get label {
    switch (this) {
      case TacheStatus.termine:
        return 'Terminé';
      case TacheStatus.enCours:
        return 'En cours';
      case TacheStatus.enAttente:
        return 'En attente';
      case TacheStatus.annule:
        return 'Annulé';
    }
  }
}
