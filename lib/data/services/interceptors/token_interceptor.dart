import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  //Liste des endpoints publics
  final publicEndpoints = ['/auth/register','/auth/register','/public'];

  TokenInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'jwt');
    final isPublic = publicEndpoints.any((url)=>options.path.contains(url));

    // On ajoute le token à la requête uniquement si on cherche à joindre un endpoint public
    // sinon on se prend une 401
    if(token!=null && !isPublic){
      options.headers['Authorization']='Bearer $token';
      // print('>>> TOKEN AJOUTE AU HEADER : $token');
    }
    //else {
    //  print('>>> AUCUN TOKEN TROUVE');
    //}
    return handler.next(options);
  }
}