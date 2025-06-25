import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final TokenService tokenService;
  final AuthRepository authRepository;

  TokenInterceptor({required this.tokenService, required this.authRepository});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenService.getAccessToken();

    // Vérification du token
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;

    if (isUnauthorized) {
      final refreshed = await authRepository.refreshToken();

      if (refreshed) {
        final newToken = await tokenService.getAccessToken();

        final clone = await _retry(err.requestOptions, newToken!);
        return handler.resolve(clone);
      }
    }

    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String token) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers..['Authorization'] = 'Bearer $token',
    );

    final dio = Dio();
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
