import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class GetCategories implements UseCase<List<String>, NoParams> {
  final ProductRepository repository;

  GetCategories(this.repository);

  @override
  Future<Result<List<String>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
