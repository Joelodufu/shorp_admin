import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/carousel.dart';
import '../repositories/carousel_repository.dart';

class GetCarousels implements UseCase<List<Carousel>, GetCarouselsParams> {
  final CarouselRepository repository;

  GetCarousels(this.repository);

  @override
  Future<Result<List<Carousel>>> call(GetCarouselsParams params) async {
    return await repository.getCarousels(
      category: params.category,
      search: params.search,
    );
  }
}

class GetCarouselsParams {
  final String? category;
  final String? search;

  GetCarouselsParams({this.category, this.search});
}
