import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Dio dio;

  AuthInterceptor({required this.storage, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'jwt_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken != null) {
        try {
          // Attempt to refresh token
          final response = await dio.post('https://dummyjson.com/auth/refresh', data: {
            'refreshToken': refreshToken,
            'expiresInMins': 30,
          });

          if (response.statusCode == 200) {
            final newToken = response.data['token'];
            final newRefreshToken = response.data['refreshToken'];
            
            await storage.write(key: 'jwt_token', value: newToken);
            await storage.write(key: 'refresh_token', value: newRefreshToken);

            // Retry original request
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final cloneReq = await dio.fetch(err.requestOptions);
            return handler.resolve(cloneReq);
          }
        } catch (e) {
          // If refresh fails, logout
          await storage.deleteAll();
        }
      }
    }
    return handler.next(err);
  }
}
