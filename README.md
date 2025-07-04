# Co-Habit frontend

**Co-Habit** est une application Flutter de gestion de colocation pensée pour simplifier le quotidien des colocataires : gestion des stocks, des tâches, des dépenses, et bien plus encore — avec une interface moderne et une architecture scalable.

## Fonctionnalités principales

- Authentification utilisateur
- Création et gestion de colocation (foyer)
- Système de tâches collaboratives
- Gestion des stocks partagés (courses, entretien, hygiène…)
- Onboarding fluide
- Architecture Clean Architecture pour une meilleure séparation des responsabilités

## Architecture du projet

Le projet suit les principes de la **Clean Architecture** :

```
lib/
├── main.dart
├── config/             # Thèmes, routes, constantes
├── core/               # Services, erreurs, injection
├── data/               # Models, repositories, datasources (local & remote)
├── domain/             # Entités, interfaces de repository, usecases
└── presentation/       # UI (screens, widgets), logique de présentation
```

## Installation locale

1. Clone le repo :

   ```bash
   git clone https://github.com/CoHabitProject/co_habit_frontend.git
   cd co_habit_frontend
   ```

2. Installe les dépendances :

   ```bash
   flutter pub get
   ```

3. Lance le projet :

   ```bash
   flutter run
   ```

> Assure-toi que ton backend (Keycloak, PostgreSQL, etc.) est correctement configuré si tu veux faire fonctionner l’app avec toutes ses fonctionnalités.

## 📄 Licence

MIT
