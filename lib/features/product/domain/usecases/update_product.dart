import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProduct implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Result<Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.productId, params.product);
  }
}

class UpdateProductParams {
  final int productId;
  final Product product;

  UpdateProductParams({required this.productId, required this.product});
}

