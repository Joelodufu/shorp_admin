import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> clearCachedProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String _cacheKey = 'CACHED_PRODUCTS';

  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
    await sharedPreferences.setString(_cacheKey, jsonString);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString(_cacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> clearCachedProducts() async {
    await sharedPreferences.remove(_cacheKey);
  }
}