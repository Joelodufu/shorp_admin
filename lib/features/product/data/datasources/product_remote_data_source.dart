import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? category, String? search});
  Future<List<String>> getCategories();
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(int productId, ProductModel product);
  Future<void> deleteProduct(int productId);
  Future<String> uploadProductImage(File image);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  Future<String> uploadProductImage(File image) async {
    final dio = Dio();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path),
      'upload_preset': 'oltron',
    });
    final response = await dio.post(
      'https://api.cloudinary.com/v1_1/emerald-codelines/image/upload',
      data: formData,
    );
    if (response.statusCode == 200) {
      return response.data['secure_url'] as String;
    } else {
      throw Exception('Failed to upload image');
    }
  }

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
      print("The Cartegory Is 🔥🔥🔥 : $response \n");
      return (response.data as List<dynamic>).cast<String>();
    } catch (e) {
      if (isDevelopment) {
        print("The Error Extends to Here: ❌❌ $e \n");
      }
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
  Future<ProductModel> updateProduct(
    int productId,
    ProductModel product,
  ) async {
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

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      await dio.delete('$baseUrl/api/products/$productId');
    } catch (e) {
      throw ServerException('Failed to delete product: $e');
    }
  }
}
