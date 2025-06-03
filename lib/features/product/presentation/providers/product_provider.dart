import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/update_product.dart'; // <-- Add this import
import '../../domain/usecases/upload_product_image.dart';

class ProductProvider extends ChangeNotifier {
  final GetProducts getProducts;
  final GetCategories getCategories;
  final CreateProduct createProduct;
  final DeleteProduct deleteProduct;
  final UpdateProduct updateProduct;
  final UploadProductImage uploadProductImage; // <-- Add this

  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;

  bool isUploading = false;
  String? uploadError;
  String? uploadedImageUrl;

  ProductProvider({
    required this.getProducts,
    required this.getCategories,
    required this.createProduct,
    required this.deleteProduct,
    required this.updateProduct,
    required this.uploadProductImage, // <-- Add this
  });

  List<Product> get products => _products;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts({String? category, String? search}) async {
    _isLoading = true;
    _error = null;
    // notifyListeners();
    try {
      final result = await getProducts(
        GetProductsParams(category: category, search: search),
      );
      if (result is Success<List<Product>>) {
        _products = result.value;
      } else if (result is Failure<List<Product>>) {
        _error = result.message;
        print('Error fetching products: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    // notifyListeners();
    try {
      final result = await getCategories(NoParams());
      if (result is Success<List<String>>) {
        _categories = result.value;
      } else if (result is Failure<List<String>>) {
        _error = result.message;
        print('Error fetching categories: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await createProduct(product);
      if (result is Success<Product>) {
        _products.add(result.value);
        await fetchCategories();
      } else if (result is Failure<Product>) {
        _error = result.message;
        print('Error creating product: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error creating product: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProductItem(int productId, Product product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await updateProduct(
        UpdateProductParams(productId: productId, product: product),
      );
      if (result is Success<Product>) {
        final index = _products.indexWhere((p) => p.productId == productId);
        if (index != -1) _products[index] = result.value;
        await fetchCategories();
      } else if (result is Failure<Product>) {
        _error = result.message;
        print('Error updating product: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error updating product: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProductItem(int productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await deleteProduct(productId);
      if (result is Success<void>) {
        _products.removeWhere((p) => p.productId == productId);
        await fetchCategories();
      } else if (result is Failure<void>) {
        _error = result.message;
        print('Error deleting product: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error deleting product: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadImage(File image) async {
    isUploading = true;
    uploadError = null;
    uploadedImageUrl = null;
    notifyListeners();

    final result = await uploadProductImage(image);

    isUploading = false;
    if (result is Success<String>) {
      uploadedImageUrl = result.value;
    } else if (result is Failure<String>) {
      uploadError = result.message;
    }
    notifyListeners();
  }
}
