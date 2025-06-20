import 'dart:convert';
import 'package:co_habit_frontend/config/router/app_router.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  // init des dépéndences du projet
  setUpDependencies();
  runApp(ChangeNotifierProvider(
    create: (_) => FloatingNavbarController(),
    child: const MyApp(),
  ));
}

const FlutterAppAuth appAuth = FlutterAppAuth();

// === Keycloak config ===
const String clientId = 'co-habit-confidential';
const String clientSecret = 'secret'; // Ajout du client secret
const String redirectUrl = 'cohabit://oauth2redirect';
const String issuer =
    'http://10.0.2.2:8088/realms/co-habit'; // http://localhost:8088/realms/co-habit
const List<String> scopes = ['openid', 'profile', 'email'];
// à la place de 10.0.2.2:
const String apiBaseUrl =
    "http://10.0.2.2:8080"; // pour accéder à l'hôte depuis l'émulateur Android

String? _accessToken;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Keycloak Demo',
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _username;
  String? _error;

  Future<void> _login() async {
    try {
      // Configuration manuelle au lieu de passer par issuer
      final request = AuthorizationTokenRequest(
        clientId,
        redirectUrl,
        clientSecret: clientSecret,
        serviceConfiguration: const AuthorizationServiceConfiguration(
          authorizationEndpoint: '$issuer/protocol/openid-connect/auth',
          tokenEndpoint: '$issuer/protocol/openid-connect/token',
        ),
        scopes: scopes,
        allowInsecureConnections: true,
        promptValues: ['login'],
      );

      final result = await appAuth.authorizeAndExchangeCode(request);

      if (result.accessToken != null) {
        _accessToken = result.accessToken;

        // Vérifier si le token contient 'profile'
        if (_accessToken!.contains('profile')) {
        } else {}

        _fetchHello();
      } else {
        setState(() => _error = 'Pas de token reçu');
      }
    } catch (e) {
      setState(() => _error = 'Erreur login : $e');
    }
  }

  Future<void> _fetchHello() async {
    try {
      // Utiliser le nouvel endpoint
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/customers'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          setState(() {
            _username =
                "Bienvenue ${data['username']}!\nEmail: ${data['email']}";
            _error = null;
          });
        } catch (e) {
          // Si la réponse n'est pas du JSON
          setState(() {
            _username = "Réponse: ${response.body}";
            _error = null;
          });
        }
      } else if (response.statusCode == 404) {
        // Essayer l'endpoint API principal
        final fallbackResponse = await http.get(
          Uri.parse('$apiBaseUrl/api/hello'),
          headers: {'Authorization': 'Bearer $_accessToken'},
        );

        if (fallbackResponse.statusCode == 200) {
          setState(() {
            _username = fallbackResponse.body;
            _error = null;
          });
        } else {
          setState(() => _error =
              'Erreur API: ${fallbackResponse.statusCode} - ${fallbackResponse.body}');
        }
      } else {
        setState(() => _error =
            'Erreur API : ${response.statusCode} - Corps de la réponse : ${response.body}');
      }
    } catch (e) {
      setState(() => _error = 'Erreur requête : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Keycloak')),
      body: Center(
        child: _username != null
            ? Text(_username!, style: const TextStyle(fontSize: 22))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      try {
                        _login();
                      } catch (e) {
                        setState(() => _error = 'Erreur onPressed: $e');
                      }
                    },
                    child: const Text('Se connecter avec Keycloak'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      _testPublicEndpoint();
                    },
                    child: const Text('Tester endpoint public'),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center),
                  ]
                ],
              ),
      ),
    );
  }

  Future<void> _testPublicEndpoint() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/public'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _username = 'Endpoint public accessible: ${response.body}';
          _error = null;
        });
      } else {
        setState(() => _error =
            'Erreur API publique: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() => _error = 'Erreur requête publique: $e');
    }
  }
}
