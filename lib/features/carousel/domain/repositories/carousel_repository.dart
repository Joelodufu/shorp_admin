import '../../../../core/error/result.dart';
import '../entities/carousel.dart';

abstract class CarouselRepository {
  Future<Result<List<Carousel>>> getCarousels();
  Future<Result<Carousel>> createCarousel(Carousel carousel);
  Future<Result<Carousel>> updateCarousel(int carouselId, Carousel carousel);
  Future<Result<void>> deleteCarousel(int carouselId);
}
