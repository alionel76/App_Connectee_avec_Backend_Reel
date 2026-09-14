import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> cacheToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  @override
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  @override
  Future<void> clearToken() async {
    await storage.delete(key: 'jwt_token');
  }
}
