import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  TokenInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'jwt');
    if(token!=null){
      options.headers['Authorization']='Bearer $token';
      // print('>>> TOKEN AJOUTE AU HEADER : $token');
    }
    //else {
    //  print('>>> AUCUN TOKEN TROUVE');
    //}
    return handler.next(options);
  }
}