import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final TokenService tokenService;
  final AuthRepository authRepository;
  final LogService log;

  TokenInterceptor({
    required this.tokenService,
    required this.authRepository,
    required this.log,
  });

  final excludedPaths = [
    AppConstants.login,
    AppConstants.register,
    AppConstants.refresh
  ];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Si route dans excludedPaths => donc on envoie pas de token
    if (excludedPaths.any((path) => options.path.endsWith(path))) {
      log.debug(
          '[TokenInterceptor] Skipping token attachment for ${options.path}.');
      return handler.next(options);
    }
    final token = await tokenService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      log.debug('[TokenInterceptor] Adding token to headers.');
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      log.warn(
          '[TokenInterceptor] No token found, sending request without auth header.');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;

    if (isUnauthorized) {
      log.warn('[TokenInterceptor] 401 detected – trying to refresh token...');

      final refreshed = await authRepository.refreshToken();

      if (refreshed) {
        log.info('[TokenInterceptor] Token refreshed successfully.');

        final newToken = await tokenService.getAccessToken();
        if (newToken != null) {
          final clone = await _retry(err.requestOptions, newToken);
          log.debug(
              '[TokenInterceptor] Retrying original request with new token.');
          return handler.resolve(clone);
        } else {
          log.error(
              '[TokenInterceptor] Token was refreshed but not retrievable.');
        }
      } else {
        log.error('[TokenInterceptor] Token refresh failed.');
      }
    } else {
      log.warn('[TokenInterceptor] Non-401 error: ${err.message}');
    }

    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String token) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers..['Authorization'] = 'Bearer $token',
    );

    final dio =
        Dio(); // Attention : ici tu crées un nouveau Dio (sans interceptor)
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
