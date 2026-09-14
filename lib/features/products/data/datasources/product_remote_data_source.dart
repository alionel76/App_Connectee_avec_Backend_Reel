import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductDetails(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('https://dummyjson.com/products');
    if (response.statusCode == 200) {
      final List productsJson = response.data['products'];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final response = await dio.get('https://dummyjson.com/products/$id');
    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
