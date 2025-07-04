import 'package:co_habit_frontend/config/router/app_router.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpDependencies();

  final authProvider = getIt<AuthProvider>();
  await authProvider.initAuth();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FloatingNavbarController()),
        ChangeNotifierProvider(
            create: (_) => StockProvider(stockRepository: getIt())),
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => FoyerProvider()),
        ChangeNotifierProvider(create: (_) => DepensesProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'CoHabit',
    );
  }
}
