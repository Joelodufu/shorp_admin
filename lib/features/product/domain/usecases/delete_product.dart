import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProduct implements UseCase<void, int> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Result<void>> call(int productId) async {
    return await repository.deleteProduct(productId);
  }
}
