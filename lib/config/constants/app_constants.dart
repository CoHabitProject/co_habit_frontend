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
  static String creerRejoindreRoute(String code) => '$colocations/join/$code';
  static String getFoyerByIdRoute(int id) => '$colocations/$id';

  // API Stock routes
  static String stockMainRoute(int colocationId) =>
      '/interne/colocations/$colocationId/stocks';

  static String stockItemMainRoute(int colocationId, int stockId) =>
      '/interne/colocations/$colocationId/stocks/$stockId/items';

  static String updateStockItemRoute(
          int colocationId, int stockId, int itemId) =>
      '/interne/colocations/$colocationId/stocks/$stockId/items/$itemId';

  static String deleteStockItemRoute(
          int colocationId, int stockId, int itemId) =>
      '/interne/colocations/$colocationId/stocks/$stockId/items/$itemId';

  static String updateStockRoute(int colocationId, int stockId) =>
      '/interne/colocations/$colocationId/stocks/$stockId';

  // API Depenses routes
  static const String creerDepenseRoute = '/expenses';

  static String getAndDeleteDepeseParIdRoute(int depenseId) =>
      '/expenses/$depenseId';

  static String getDepensesDuFoyerRoute(int colocationId) =>
      '/expenses/space/$colocationId';

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
