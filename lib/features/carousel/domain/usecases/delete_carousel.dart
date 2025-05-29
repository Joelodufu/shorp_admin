import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/carousel_repository.dart';

class DeleteCarousel implements UseCase<void, int> {
  final CarouselRepository repository;

  DeleteCarousel(this.repository);

  @override
  Future<Result<void>> call(int carouselId) async {
    return await repository.deleteCarousel(carouselId);
  }
}
