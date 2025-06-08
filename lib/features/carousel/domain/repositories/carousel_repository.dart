import 'dart:io';
import '../../../../core/error/result.dart';
import '../entities/carousel.dart';

abstract class CarouselRepository {
  Future<Result<List<Carousel>>> getCarousels({String? category, String? search});
  Future<Result<Carousel>> getCarouselByProductId(int productId);
  Future<Result<Carousel>> createCarousel(Carousel carousel);
  Future<Result<Carousel>> updateCarousel(int productId, Carousel carousel);
  Future<Result<void>> deleteCarousel(int productId);

  /// Uploads an image file and returns the image URL
  Future<Result<String>> uploadCarouselImage(File image);
}
