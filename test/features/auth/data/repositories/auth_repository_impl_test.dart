import 'package:app_connectee_avec_backend_reel/core/error/failures.dart';
import 'package:app_connectee_avec_backend_reel/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:app_connectee_avec_backend_reel/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:app_connectee_avec_backend_reel/features/auth/data/models/user_model.dart';
import 'package:app_connectee_avec_backend_reel/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tUserModel = UserModel(
    id: 1,
    username: 'testuser',
    email: 'test@test.com',
    firstName: 'Test',
    lastName: 'User',
    token: 'jwt_token_123',
  );

  group('login', () {
    const tUsername = 'testuser';
    const tPassword = 'password123';

    test('should return remote data and cache token when call to remote data source is successful', () async {
      when(() => mockRemoteDataSource.login(any(), any())).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.cacheToken(any())).thenAnswer((_) async => {});

      final result = await repository.login(tUsername, tPassword);

      verify(() => mockRemoteDataSource.login(tUsername, tPassword));
      verify(() => mockLocalDataSource.cacheToken(tUserModel.token));
      expect(result, equals(const Right(tUserModel)));
    });

    test('should return ServerFailure when call to remote data source is unsuccessful', () async {
      when(() => mockRemoteDataSource.login(any(), any())).thenThrow(Exception('Server error'));

      final result = await repository.login(tUsername, tPassword);

      verify(() => mockRemoteDataSource.login(tUsername, tPassword));
      expect(result, equals(const Left(ServerFailure('Server error'))));
    });
  });

  group('isAuthenticated', () {
    test('should return true when there is a cached token', () async {
      when(() => mockLocalDataSource.getToken()).thenAnswer((_) async => 'token123');

      final result = await repository.isAuthenticated();

      verify(() => mockLocalDataSource.getToken());
      expect(result, true);
    });

    test('should return false when there is no cached token', () async {
      when(() => mockLocalDataSource.getToken()).thenAnswer((_) async => null);

      final result = await repository.isAuthenticated();

      verify(() => mockLocalDataSource.getToken());
      expect(result, false);
    });
  });
}
