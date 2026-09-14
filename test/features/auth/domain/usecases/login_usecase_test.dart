import 'package:app_connectee_avec_backend_reel/features/auth/domain/entities/user.dart';
import 'package:app_connectee_avec_backend_reel/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_connectee_avec_backend_reel/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUseCase(mockAuthRepository);
  });

  const tUser = User(
    id: 1,
    username: 'alionel76',
    email: 'test@test.com',
    firstName: 'Lionel',
    lastName: 'A',
    token: 'token123',
  );

  test('should get user from the repository when logging in', () async {
    when(() => mockAuthRepository.login(any(), any())).thenAnswer((_) async => const Right(tUser));

    final result = await useCase(LoginParams(username: 'alionel76', password: 'password123'));

    expect(result, const Right(tUser));
    verify(() => mockAuthRepository.login('alionel76', 'password123'));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
