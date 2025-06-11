class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://localhost:8080/api';
  static const int apiTimeout = 30000; // 30 seconds

  // Default headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Private constructor to prevent instantiation
  AppConstants._();
}
