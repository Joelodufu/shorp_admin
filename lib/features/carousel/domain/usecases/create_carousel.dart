import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/carousel.dart';
import '../repositories/carousel_repository.dart';

class CreateCarousel implements UseCase<Carousel, Carousel> {
  final CarouselRepository repository;

  CreateCarousel(this.repository);

  @override
  Future<Result<Carousel>> call(Carousel carousel) async {
    return await repository.createCarousel(carousel);
  }
}
