import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Result<List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      category: params.category,
      search: params.search,
    );
  }
}

class GetProductsParams {
  final String? category;
  final String? search;

  GetProductsParams({this.category, this.search});
}
