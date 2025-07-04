import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/core/services/log_service.dart';
import 'package:co_habit_frontend/domain/usecases/usecases.dart';
import 'package:co_habit_frontend/presentation/providers/providers.dart';
import 'package:co_habit_frontend/presentation/screens/foyer/controller/foyer_controller.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class RejoindreColocScreen extends StatefulWidget {
  const RejoindreColocScreen({super.key});

  @override
  State<RejoindreColocScreen> createState() => _RejoindreColocScreenState();
}

class _RejoindreColocScreenState extends State<RejoindreColocScreen> {
  late final TextEditingController _controller;
  // controller
  late final FoyerController _foyerController;

  final _log = GetIt.instance<LogService>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _foyerController = FoyerController(
        getFoyerByCodeUc: getIt<GetFoyerByCodeUc>(),
        creerFoyerUc: getIt<CreerFoyerUseCase>(),
        creerStockUc: getIt<CreerStockUc>(),
        foyerProvider: context.read<FoyerProvider>(),
        stockProvider: context.read<StockProvider>());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  Future<void> _submitForm() async {
    try {
      final String code = _controller.text.trim();
      await _foyerController.rejoindreColoc(code);

      if (mounted) {
        context.go('/home');
      }
    } catch (e, stack) {
      if (e.toString().contains('409')) {
        _showErrorMessage('ERROR : Vous êtes déjà membre de cette colocation');
      } else if (e.toString().contains('404')) {
        _showErrorMessage('ERROR : Code de colocation invalide');
      }
      _log.error('[RejoindreColoc] Error while trying to join coloc: $e',
          stackTrace: stack);
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Entrez le code',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: Text(
                'Demandez à un colocataire de vous fournir le code dans "Ma coloc"',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            Pinput(
              length: 5,
              controller: _controller,
              defaultPinTheme: PinTheme(
                width: 70,
                height: 80,
                textStyle: const TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkPrimaryColor,
                    fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                ),
              ),
              showCursor: false,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 40),
            CohabitButton(
                text: 'Valider',
                buttonType: ButtonType.gradient,
                onPressed: _submitForm)
          ],
        ),
      )),
    );
  }
}
