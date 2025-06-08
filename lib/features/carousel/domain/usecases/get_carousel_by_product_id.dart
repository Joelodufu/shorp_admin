import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/carousel.dart';
import '../repositories/carousel_repository.dart';

class GetCarouselByProductId implements UseCase<Carousel, int> {
  final CarouselRepository repository;

  GetCarouselByProductId(this.repository);

  @override
  Future<Result<Carousel>> call(int productId) async {
    return await repository.getCarouselByProductId(productId);
  }
}