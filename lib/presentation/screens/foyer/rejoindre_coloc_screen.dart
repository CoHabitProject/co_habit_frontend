import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/widgets/common/cohabit_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class RejoindreColocScreen extends StatefulWidget {
  const RejoindreColocScreen({super.key});

  @override
  State<RejoindreColocScreen> createState() => _RejoindreColocScreenState();
}

class _RejoindreColocScreenState extends State<RejoindreColocScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
              style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            CohabitButton(
                text: 'Valider',
                buttonType: ButtonType.gradient,
                onPressed: () {
                  // TODO : Implementer la logique de validation du code
                })
          ],
        ),
      )),
    );
  }
}
