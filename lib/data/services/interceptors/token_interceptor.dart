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
      log.warn('[TokenInterceptor] 401 detected – attempting token refresh...');

      try {
        final credentials = await authRepository.refreshToken();

        if (credentials != null && credentials.accessToken.isNotEmpty) {
          log.info('[TokenInterceptor] Token refreshed successfully.');

          final clone =
              await _retry(err.requestOptions, credentials.accessToken);
          log.debug(
              '[TokenInterceptor] Retrying original request with new token.');
          return handler.resolve(clone);
        } else {
          log.error(
              '[TokenInterceptor] Token was refreshed but credentials are invalid.');
        }
      } catch (e, stack) {
        log.error('[TokenInterceptor] Error during token refresh: $e',
            stackTrace: stack);
      }
    } else {
      log.warn('[TokenInterceptor] Non-401 error encountered: ${err.message}');
    }

    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String token) async {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        ...AppConstants.defaultHeaders,
        'Authorization': 'Bearer $token',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // IMPORTANT : ne pas ajouter d’interceptor ici pour éviter une boucle infinie
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(method: requestOptions.method),
    );
  }
}
