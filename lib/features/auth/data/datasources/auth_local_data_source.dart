import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheTokens({required String token, String? refreshToken});
  Future<String?> getToken();
  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> cacheTokens({required String token, String? refreshToken}) async {
    await storage.write(key: 'jwt_token', value: token);
    if (refreshToken != null) {
      await storage.write(key: 'refresh_token', value: refreshToken);
    }
  }

  @override
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  @override
  Future<void> clearAll() async {
    await storage.deleteAll();
  }
}
