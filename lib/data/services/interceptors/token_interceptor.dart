import 'dart:async';
import 'package:co_habit_frontend/config/constants/app_constants.dart';
import 'package:co_habit_frontend/core/services/services.dart';
import 'package:co_habit_frontend/domain/repositories/auth_repository.dart';
import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class TokenInterceptor extends Interceptor {
  final TokenService tokenService;
  final AuthRepository authRepository;
  final LogService log;
  Completer<void>? _refreshCompleter;

  TokenInterceptor({
    required this.tokenService,
    required this.authRepository,
    required this.log,
  });

  final excludedPaths = [
    AppConstants.login,
    AppConstants.register,
    AppConstants.refresh,
  ];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (excludedPaths.any((path) => options.path.endsWith(path))) {
      log.debug(
          '[TokenInterceptor] Skipping token attachment for ${options.path}');
      return handler.next(options);
    }

    final token = await tokenService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      log.debug('[TokenInterceptor] Adding token to headers.');
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      log.warn(
          '[TokenInterceptor] No token found – sending without Authorization header.');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;

    if (!isUnauthorized) {
      log.warn('[TokenInterceptor] Non-401 error: ${err.message}');
      return handler.next(err);
    }

    log.warn('[TokenInterceptor] 401 detected – attempting token refresh...');

    try {
      String? refreshedToken;

      if (_refreshCompleter != null) {
        log.debug('[TokenInterceptor] Awaiting ongoing refresh...');
        await _refreshCompleter!.future;
        refreshedToken = await tokenService.getAccessToken();
      } else {
        _refreshCompleter = Completer();

        final credentials = await authRepository.refreshToken();
        if (credentials != null && credentials.accessToken.isNotEmpty) {
          refreshedToken = credentials.accessToken;
          _refreshCompleter!.complete();
        } else {
          _refreshCompleter!
              .completeError('[TokenInterceptor] Token refresh failed.');
          forceLogout();
          return handler.reject(err);
        }

        _refreshCompleter = null;
      }

      if (refreshedToken != null) {
        final clone = await _retry(err.requestOptions, refreshedToken);
        log.debug('[TokenInterceptor] Retried request with new token.');
        return handler.resolve(clone);
      }
    } catch (e, stack) {
      _refreshCompleter?.completeError(e);
      _refreshCompleter = null;
      log.error('[TokenInterceptor] Exception during refresh: $e',
          stackTrace: stack);
      forceLogout();
      return handler.reject(err);
    }

    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String token) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $token',
      },
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      extra: requestOptions.extra,
      followRedirects: requestOptions.followRedirects,
      listFormat: requestOptions.listFormat,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      sendTimeout: requestOptions.sendTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
      validateStatus: requestOptions.validateStatus,
    );

    final dio = Dio();
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  void forceLogout() {
    log.warn('[TokenInterceptor] Forcing logout due to token refresh failure');
    final authProvider = GetIt.I<AuthProvider>();
    authProvider.logout();
  }
}
