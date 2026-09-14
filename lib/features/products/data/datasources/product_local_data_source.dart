import 'package:hive/hive.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> productsToCache);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box<ProductModel> productBox;

  ProductLocalDataSourceImpl({required this.productBox});

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    if (productBox.values.isNotEmpty) {
      return productBox.values.toList();
    } else {
      throw Exception('No cached products found');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) async {
    await productBox.clear();
    await productBox.addAll(productsToCache);
  }
}
