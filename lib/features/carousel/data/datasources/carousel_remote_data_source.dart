import 'package:dio/dio.dart';
import '../../../../core/utils/constants.dart';
import '../models/carousel_model.dart';

abstract class CarouselRemoteDataSource {
  Future<List<CarouselModel>> getCarousels();
  Future<CarouselModel> createCarousel(CarouselModel carousel);
  Future<CarouselModel> updateCarousel(int carouselId, CarouselModel carousel);
  Future<void> deleteCarousel(int carouselId);
}

class CarouselRemoteDataSourceImpl implements CarouselRemoteDataSource {
  final Dio dio;

  CarouselRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CarouselModel>> getCarousels() async {
    try {
      final response = await dio.get('$baseUrl/api/carousels');
      return (response.data as List<dynamic>)
          .map((json) => CarouselModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch carousels: $e');
    }
  }

  @override
  Future<CarouselModel> createCarousel(CarouselModel carousel) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/carousels',
        data: carousel.toJson(),
      );
      return CarouselModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create carousel: $e');
    }
  }

  @override
  Future<CarouselModel> updateCarousel(
    int carouselId,
    CarouselModel carousel,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/carousels/$carouselId',
        data: carousel.toJson(),
      );
      return CarouselModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update carousel: $e');
    }
  }

  @override
  Future<void> deleteCarousel(int carouselId) async {
    try {
      await dio.delete('$baseUrl/api/carousels/$carouselId');
    } catch (e) {
      throw Exception('Failed to delete carousel: $e');
    }
  }
}
