import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/carousel.dart';
import '../repositories/carousel_repository.dart';

class UpdateCarousel implements UseCase<Carousel, UpdateCarouselParams> {
  final CarouselRepository repository;

  UpdateCarousel(this.repository);

  @override
  Future<Result<Carousel>> call(UpdateCarouselParams params) async {
    return await repository.updateCarousel(params.productId, params.carousel);
  }
}

class UpdateCarouselParams {
  final int productId;
  final Carousel carousel;

  UpdateCarouselParams({required this.productId, required this.carousel});
}
