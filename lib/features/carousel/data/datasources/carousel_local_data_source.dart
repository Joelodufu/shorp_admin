import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/carousel_model.dart';

abstract class CarouselLocalDataSource {
  Future<void> cacheCarousels(List<CarouselModel> carousels);
  Future<List<CarouselModel>> getCachedCarousels();
  Future<void> clearCachedCarousels();
}

class CarouselLocalDataSourceImpl implements CarouselLocalDataSource {
  static const String _cacheKey = 'CACHED_CAROUSELS';

  final SharedPreferences sharedPreferences;

  CarouselLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCarousels(List<CarouselModel> carousels) async {
    final jsonString = jsonEncode(carousels.map((c) => c.toJson()).toList());
    await sharedPreferences.setString(_cacheKey, jsonString);
  }

  @override
  Future<List<CarouselModel>> getCachedCarousels() async {
    final jsonString = sharedPreferences.getString(_cacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => CarouselModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> clearCachedCarousels() async {
    await sharedPreferences.remove(_cacheKey);
  }
}