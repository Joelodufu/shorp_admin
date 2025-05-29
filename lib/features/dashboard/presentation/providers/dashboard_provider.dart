import 'package:flutter/foundation.dart';

class DashboardProvider with ChangeNotifier {
  int _productCount = 0;
  int _carouselCount = 0;
  bool _isLoading = false;
  String? _error;

  int get productCount => _productCount;
  int get carouselCount => _carouselCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Placeholder for fetching stats (e.g., via API)
      await Future.delayed(const Duration(seconds: 1));
      _productCount = 100; // Mock data
      _carouselCount = 5; // Mock data
    } catch (e) {
      _error = e.toString();
      print('Error fetching stats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
