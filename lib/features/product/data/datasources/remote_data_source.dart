import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/product_model.dart';


class RemoteDataSource {
  final Dio dio;

  RemoteDataSource({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
    String? category,
    String? search,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (category != null && category.isNotEmpty) {
        queryParameters['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      final response = await dio.get(
        '$baseUrl/api/products',
        queryParameters: queryParameters,
      );
      return (response.data as List<dynamic>)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await dio.get('$baseUrl/api/products/categories');
      return (response.data as List<dynamic>).cast<String>();
    } catch (e) {
      throw ServerException('Failed to fetch categories: $e');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/products',
        data: product.toJson(),
      );
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to create product: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(int, productId, ProductModel product) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/products/$productId',
        data: product.toJson(),
      );
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await dio.delete('$baseUrl/api/products/$productId');
    } catch (e) {
      throw ServerException('Failed to delete product: $e');
    }
  }
}
