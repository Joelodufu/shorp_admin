import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/carousel.dart';
import '../repositories/carousel_repository.dart';

class GetCarousels implements UseCase<List<Carousel>, NoParams> {
  final CarouselRepository repository;

  GetCarousels(this.repository);

  @override
  Future<Result<List<Carousel>>> call(NoParams params) async {
    return await repository.getCarousels();
  }
}
