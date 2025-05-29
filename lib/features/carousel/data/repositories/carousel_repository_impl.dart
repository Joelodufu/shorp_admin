import '../../../../core/error/result.dart';
import '../../domain/entities/carousel.dart';
import '../../domain/repositories/carousel_repository.dart';
import '../datasources/carousel_remote_data_source.dart';
import '../models/carousel_model.dart';

class CarouselRepositoryImpl implements CarouselRepository {
  final CarouselRemoteDataSource remoteDataSource;

  CarouselRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Carousel>>> getCarousels() async {
    try {
      final carousels = await remoteDataSource.getCarousels();
      return Success(carousels);
    } catch (e) {
      return const Failure('Failed to fetch carousels');
    }
  }

  @override
  Future<Result<Carousel>> createCarousel(Carousel carousel) async {
    try {
      final carouselModel = CarouselModel(
        id: carousel.id,
        carouselId: carousel.carouselId,
        imageUrl: carousel.imageUrl,
        title: carousel.title,
        link: carousel.link,
        createdAt: carousel.createdAt,
        updatedAt: carousel.updatedAt,
      );
      final result = await remoteDataSource.createCarousel(carouselModel);
      return Success(result);
    } catch (e) {
      return const Failure('Failed to create carousel');
    }
  }

  @override
  Future<Result<Carousel>> updateCarousel(
    int carouselId,
    Carousel carousel,
  ) async {
    try {
      final carouselModel = CarouselModel(
        id: carousel.id,
        carouselId: carousel.carouselId,
        imageUrl: carousel.imageUrl,
        title: carousel.title,
        link: carousel.link,
        createdAt: carousel.createdAt,
        updatedAt: carousel.updatedAt,
      );
      final result = await remoteDataSource.updateCarousel(
        carouselId,
        carouselModel,
      );
      return Success(result);
    } catch (e) {
      return const Failure('Failed to update carousel');
    }
  }

  @override
  Future<Result<void>> deleteCarousel(int carouselId) async {
    try {
      await remoteDataSource.deleteCarousel(carouselId);
      return const Success(null);
    } catch (e) {
      return const Failure('Failed to delete carousel');
    }
  }
}
