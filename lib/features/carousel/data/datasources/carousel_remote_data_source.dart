import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/utils/constants.dart';
import '../models/carousel_model.dart';

abstract class CarouselRemoteDataSource {
  Future<List<CarouselModel>> getCarousels({String? category, String? search});
  Future<CarouselModel> getCarouselByProductId(int productId);
  Future<CarouselModel> createCarousel(CarouselModel carousel);
  Future<CarouselModel> updateCarousel(int productId, CarouselModel carousel);
  Future<void> deleteCarousel(int productId);
  Future<String> uploadCarouselImage(File image);
}

class CarouselRemoteDataSourceImpl implements CarouselRemoteDataSource {
  final Dio dio;

  CarouselRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CarouselModel>> getCarousels({
    String? category,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty)
        queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await dio.get(
        '$baseUrl/api/carousel',
        queryParameters: queryParams,
      );
      print('Carousel API response: ${response.data}'); // Debug print

      // Use the correct key: "data"
      final data = response.data;
      final list = data['data'] as List<dynamic>? ?? [];
      return list.map((json) => CarouselModel.fromJson(json)).toList();
      
    } catch (e) {
      throw Exception('Failed to fetch carousels: $e');
    }
  }

  @override
  Future<CarouselModel> getCarouselByProductId(int productId) async {
    try {
      final response = await dio.get('$baseUrl/api/carousel/$productId');
      return CarouselModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch carousel: $e');
    }
  }

  @override
  Future<CarouselModel> createCarousel(CarouselModel carousel) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/carousel',
        data: carousel.toJson(),
      );
      return CarouselModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create carousel: $e');
    }
  }

  @override
  Future<CarouselModel> updateCarousel(
    int productId,
    CarouselModel carousel,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/carousel/$productId',
        data: carousel.toJson(),
      );
      return CarouselModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update carousel: $e');
    }
  }

  @override
  Future<void> deleteCarousel(int productId) async {
    try {
      await dio.delete('$baseUrl/api/carousel/$productId');
    } catch (e) {
      throw Exception('Failed to delete carousel: $e');
    }
  }

  @override
  Future<String> uploadCarouselImage(File image) async {
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
}
