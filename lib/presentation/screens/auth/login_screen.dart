import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/domain/entities/user_credentials.dart';
import 'package:co_habit_frontend/domain/usecases/auth/login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  final String? initialMessage;
  const LoginScreen({Key? key, this.initialMessage}) : super(key:key);
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController=TextEditingController();
  bool _isLoading=false;
  
  Future<void> _handleLogin() async {
    final loginUseCase = getIt<LoginUseCase>();
    
    final success=await loginUseCase(
      UserCredentials(
        username:_usernameController.text.trim(),
        password:_passwordController.text.trim(),
      ),
    );

    setState(() => _isLoading = false);

    if(success){
      context.go('/choixInitial');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La connexion a échoué')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.initialMessage!)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:const Text('Connexion')),
      body:Padding(
        padding:const EdgeInsets.all(16.0),
        child:Column(children:[
          TextField(
            controller:_usernameController,
            decoration:const InputDecoration(labelText:'Nom d\'utilisateur'),
          ),
          TextField(
            controller:_passwordController,
            obscureText: true,
            decoration:const InputDecoration(labelText:'Mot de passe'),
          ),
          const SizedBox(height:20),
          _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Connexion'
            ),
          ),
          TextButton(
              onPressed: () {
                context.go('/signup');
              },
              child: const Text('Pas encore de compte ? Inscrivez-vous ici.')
          ),
        ]),
      ),
    );
  }
}
