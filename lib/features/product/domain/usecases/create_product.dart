import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProduct implements UseCase<Product, Product> {
  final ProductRepository repository;

  CreateProduct(this.repository);

  @override
  Future<Result<Product>> call(Product product) async {
    return await repository.createProduct(product);
  }
}
