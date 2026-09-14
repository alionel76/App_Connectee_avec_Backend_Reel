import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final userModel = await remoteDataSource.login(username, password);
      await localDataSource.cacheToken(userModel.token);
      return Right<Failure, User>(userModel);
    } catch (e) {
      final message = e is Exception ? e.toString().replaceAll('Exception: ', '') : e.toString();
      return Left(ServerFailure(message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearToken();
      return const Right<Failure, void>(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    return token != null;
  }
}
