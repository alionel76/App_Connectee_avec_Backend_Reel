import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right<Failure, List<Product>>(remoteProducts);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        return Right<Failure, List<Product>>(localProducts);
      } catch (e) {
        return Left(NetworkFailure('No network connection and no cache available'));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getProductDetails(id);
        return Right<Failure, Product>(remoteProduct);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(const NetworkFailure('No network connection'));
    }
  }
}
