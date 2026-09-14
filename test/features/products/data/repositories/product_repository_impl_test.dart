import 'package:app_connectee_avec_backend_reel/core/network/network_info.dart';
import 'package:app_connectee_avec_backend_reel/features/products/data/datasources/product_local_data_source.dart';
import 'package:app_connectee_avec_backend_reel/features/products/data/datasources/product_remote_data_source.dart';
import 'package:app_connectee_avec_backend_reel/features/products/data/models/product_model.dart';
import 'package:app_connectee_avec_backend_reel/features/products/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockLocalDataSource extends Mock implements ProductLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tProductModel = ProductModel(
    id: 1,
    title: 'Test Product',
    description: 'Description',
    price: 10.0,
    thumbnail: 'thumb.jpg',
    category: 'test',
  );
  const tProductModelList = [tProductModel];

  group('getProducts', () {
    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getProducts()).thenAnswer((_) async => tProductModelList);
      when(() => mockLocalDataSource.cacheProducts(any())).thenAnswer((_) async => {});

      await repository.getProducts();

      verify(() => mockNetworkInfo.isConnected);
    });

    test('should return remote data when the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getProducts()).thenAnswer((_) async => tProductModelList);
      when(() => mockLocalDataSource.cacheProducts(any())).thenAnswer((_) async => {});

      final result = await repository.getProducts();

      verify(() => mockRemoteDataSource.getProducts());
      expect(result, equals(const Right(tProductModelList)));
    });

    test('should return cached data when the device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedProducts()).thenAnswer((_) async => tProductModelList);

      final result = await repository.getProducts();

      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDataSource.getCachedProducts());
      expect(result, equals(const Right(tProductModelList)));
    });
  });
}
