import '../../../../core/error/result.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({String? category, String? search});
  Future<Result<List<String>>> getCategories();
  Future<Result<Product>> createProduct(Product product);
  Future<Result<Product>> updateProduct(int poductId, Product product);
  Future<Result<void>> deleteProduct(int productId);
}
