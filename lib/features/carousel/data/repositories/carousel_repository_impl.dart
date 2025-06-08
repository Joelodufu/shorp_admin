import 'dart:io';
import '../../../../core/error/result.dart';
import '../../domain/entities/carousel.dart';
import '../../domain/repositories/carousel_repository.dart';
import '../datasources/carousel_remote_data_source.dart';
import '../datasources/carousel_local_data_source.dart';
import '../models/carousel_model.dart';

class CarouselRepositoryImpl implements CarouselRepository {
  final CarouselRemoteDataSource remoteDataSource;
  final CarouselLocalDataSource localDataSource;

  CarouselRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<Carousel>>> getCarousels({String? category, String? search}) async {
    try {
      final carousels = await remoteDataSource.getCarousels(category: category, search: search);
      await localDataSource.cacheCarousels(carousels);
      return Success(carousels);
    } catch (e) {
      // On error, try to get from cache
      final cached = await localDataSource.getCachedCarousels();
      if (cached.isNotEmpty) {
        return Success(cached);
      }
      return const Failure('Failed to fetch carousels');
    }
  }

  @override
  Future<Result<Carousel>> getCarouselByProductId(int productId) async {
    try {
      final carousel = await remoteDataSource.getCarouselByProductId(productId);
      return Success(carousel);
    } catch (e) {
      return const Failure('Failed to fetch carousel');
    }
  }

  @override
  Future<Result<Carousel>> createCarousel(Carousel carousel) async {
    try {
      final carouselModel = CarouselModel(
        id: carousel.id,
        productId: carousel.productId,
        imageUrl: carousel.imageUrl,
        createdAt: carousel.createdAt,
        updatedAt: carousel.updatedAt,
      );
      final result = await remoteDataSource.createCarousel(carouselModel);
      // Optionally update cache here if needed
      return Success(result);
    } catch (e) {
      return const Failure('Failed to create carousel');
    }
  }

  @override
  Future<Result<Carousel>> updateCarousel(
    int productId,
    Carousel carousel,
  ) async {
    try {
      final carouselModel = CarouselModel(
        id: carousel.id,
        productId: carousel.productId,
        imageUrl: carousel.imageUrl,
        createdAt: carousel.createdAt,
        updatedAt: carousel.updatedAt,
      );
      final result = await remoteDataSource.updateCarousel(
        productId,
        carouselModel,
      );
      // Optionally update cache here if needed
      return Success(result);
    } catch (e) {
      return const Failure('Failed to update carousel');
    }
  }

  @override
  Future<Result<void>> deleteCarousel(int productId) async {
    try {
      await remoteDataSource.deleteCarousel(productId);
      // Optionally update cache here if needed
      return const Success(null);
    } catch (e) {
      return const Failure('Failed to delete carousel');
    }
  }

  @override
  Future<Result<String>> uploadCarouselImage(File image) async {
    try {
      final url = await remoteDataSource.uploadCarouselImage(image);
      return Success(url);
    } catch (e) {
      return const Failure('Failed to upload carousel image');
    }
  }
}
