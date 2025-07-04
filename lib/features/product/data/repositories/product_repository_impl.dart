import 'dart:io';

import '../../../../core/error/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource; // Add this line

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource, // Add this line
  });

  @override
  Future<Result<List<Product>>> getProducts({
    String? category,
    String? search,
  }) async {
    try {
      final products = await remoteDataSource.getProducts(
        category: category,
        search: search,
      );
      // Cache products after successful fetch
      await localDataSource.cacheProducts(
        products.map((e) => ProductModel.fromEntity(e)).toList(),
      );
      return Success(products);
    } catch (e) {
      // On error, try to get from cache
      final cached = await localDataSource.getCachedProducts();
      if (cached.isNotEmpty) {
        return Success(cached);
      }
      return Failure('Failed to fetch products');
    }
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Success(categories);
    } catch (e) {
      return const Failure('Failed to fetch categories ');
    }
  }

  @override
  Future<Result<Product>> createProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        productId: product.productId,
        name: product.name,
        description: product.description,
        price: product.price,
        category: product.category,
        stock: product.stock,
        rating: product.rating,
        discountRate: product.discountRate,
        images: product.images,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
      );
      final result = await remoteDataSource.createProduct(productModel);
      return Success(result);
    } catch (e) {
      return const Failure('Failed to create product');
    }
  }

  @override
  Future<Result<Product>> updateProduct(int productId, Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        productId: product.productId,
        name: product.name,
        description: product.description,
        price: product.price,
        category: product.category,
        stock: product.stock,
        rating: product.rating,
        discountRate: product.discountRate,
        images: product.images,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
      );
      // Pass both productId and productModel to the remote data source
      final result = await remoteDataSource.updateProduct(
        productId,
        productModel,
      );
      return Success(result);
    } catch (e) {
      return const Failure('Failed to update product');
    }
  }

  @override
  Future<Result<void>> deleteProduct(int productId) async {
    try {
      await remoteDataSource.deleteProduct(productId);
      await localDataSource.clearCachedProducts(); // Clear cache after delete
      return const Success(null);
    } catch (e) {
      return const Failure('Failed to delete product');
    }
  }

  @override
  Future<Result<String>> uploadProductImage(File image) async {
    try {
      final url = await remoteDataSource.uploadProductImage(image);
      return Success(url); // Wrap in Success
    } catch (e) {
      return Failure(e.toString()); // Wrap in Failure
    }
  }
}
