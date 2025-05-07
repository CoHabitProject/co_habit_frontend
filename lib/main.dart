import 'dart:math' as Math;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

final FlutterAppAuth appAuth = FlutterAppAuth();

// === Keycloak config ===
const String clientId = 'co-habit-confidential';
const String clientSecret = 'secret'; // Ajout du client secret
const String redirectUrl = 'cohabit://oauth2redirect';
const String issuer = 'http://10.0.2.2:8088/realms/co-habit'; // http://localhost:8088/realms/co-habit
const List<String> scopes = ['openid', 'profile', 'email'];
// à la place de 10.0.2.2:
const String apiBaseUrl = "http://10.0.2.2:8080"; // pour accéder à l'hôte depuis l'émulateur Android


String? _accessToken;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Keycloak Demo',
      home: const LoginPage(),
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
      print('Tentative de connexion à Keycloak...');
      print('URL: $issuer');
      print('Client ID: $clientId');
      print('Client Secret: $clientSecret');
      print('Redirect URL: $redirectUrl');
      print('Scopes: $scopes');

      // Configuration manuelle au lieu de passer par issuer
      final request = AuthorizationTokenRequest(
        clientId,
        redirectUrl,
        clientSecret: clientSecret,
        serviceConfiguration: AuthorizationServiceConfiguration(
          authorizationEndpoint: '$issuer/protocol/openid-connect/auth',
          tokenEndpoint: '$issuer/protocol/openid-connect/token',
        ),
        scopes: scopes,
        allowInsecureConnections: true,
        promptValues: ['login'],
      );

      print('Envoi de la demande d\'autorisation...');
      final result = await appAuth.authorizeAndExchangeCode(request);
      print('Réponse reçue de Keycloak');

      if (result != null && result.accessToken != null) {
        _accessToken = result.accessToken;
        print('Token reçu: ${_accessToken}');
        print('Premiers caractères: ${_accessToken!.substring(0, Math.min(30, _accessToken!.length))}...');

        // Vérifier si le token contient 'profile'
        if (_accessToken!.contains('profile')) {
          print('Le token contient le scope profile');
        } else {
          print('Le token NE contient PAS le scope profile');
        }

        _fetchHello();
      } else {
        print('Pas de token reçu!');
        setState(() => _error = 'Pas de token reçu');
      }
    } catch (e, stackTrace) {
      print('Exception lors de l\'authentification:');
      print('Type d\'erreur: ${e.runtimeType}');
      print('Message: $e');
      print('Stack trace:');
      print(stackTrace.toString().split('\n').take(10).join('\n'));

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

      print('Réponse API: ${response.statusCode}');
      print('Corps: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          setState(() {
            _username = "Bienvenue ${data['username']}!\nEmail: ${data['email']}";
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
          setState(() => _error = 'Erreur API: ${fallbackResponse.statusCode} - ${fallbackResponse.body}');
        }
      } else {
        setState(() => _error = 'Erreur API : ${response.statusCode} - Corps de la réponse : ${response.body}');
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
                  print('Erreur dans onPressed: $e');
                  setState(() => _error = 'Erreur onPressed: $e');
                }
              },
              child: const Text('Se connecter avec Keycloak'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _testPublicEndpoint();
              },
              child: const Text('Tester endpoint public'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
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
      print('Réponse API publique: ${response.statusCode}');
      print('Corps: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _username = 'Endpoint public accessible: ${response.body}';
          _error = null;
        });
      } else {
        setState(() => _error = 'Erreur API publique: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() => _error = 'Erreur requête publique: $e');
    }
  }
}
