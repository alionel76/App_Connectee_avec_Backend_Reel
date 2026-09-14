import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message ?? 'Unknown error';
      throw Exception(errorMessage);
    }
  }
}
