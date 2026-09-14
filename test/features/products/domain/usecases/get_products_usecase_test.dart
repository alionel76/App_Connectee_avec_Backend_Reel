import 'package:app_connectee_avec_backend_reel/core/usecases/usecase.dart';
import 'package:app_connectee_avec_backend_reel/features/products/domain/entities/product.dart';
import 'package:app_connectee_avec_backend_reel/features/products/domain/repositories/product_repository.dart';
import 'package:app_connectee_avec_backend_reel/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockProductRepository);
  });

  const tProducts = [
    Product(
      id: 1,
      title: 'Product 1',
      description: 'Desc 1',
      price: 15.0,
      thumbnail: 'url1',
      category: 'cat1',
    )
  ];

  test('should get products from the repository', () async {
    when(() => mockProductRepository.getProducts()).thenAnswer((_) async => const Right(tProducts));

    final result = await useCase(NoParams());

    expect(result, const Right(tProducts));
    verify(() => mockProductRepository.getProducts());
    verifyNoMoreInteractions(mockProductRepository);
  });
}
