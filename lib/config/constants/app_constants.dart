class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8080/api';
  static const int apiTimeout = 30000; // 30 seconds

  // API Auth routes
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String refresh = '$auth/refresh';
  static const String userStatus = '/interne/profile';

  // API foyer routes
  static const String colocations = '/interne/colocations';

  // API Stock routes
  static String creerStockRoute(int colocationId) =>
      '/interne/colocations/$colocationId/stocks';

  // Keycloak Auth
  static const String clientId = 'co-habit-confidential';
  static const String clientSecret = 'secret';

  // Default headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Private constructor to prevent instantiation
  AppConstants._();
}
