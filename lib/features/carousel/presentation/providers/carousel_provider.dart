import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/carousel.dart';
import '../../domain/usecases/get_carousels.dart';
import '../../domain/usecases/create_carousel.dart';
import '../../domain/usecases/update_carousel.dart';
import '../../domain/usecases/delete_carousel.dart';
import '../../domain/usecases/upload_carousel_image.dart';
import '../../../../core/error/result.dart';

class CarouselProvider with ChangeNotifier {
  final GetCarousels _getCarouselsUseCase;
  final CreateCarousel _createCarouselUseCase;
  final UpdateCarousel _updateCarouselUseCase;
  final DeleteCarousel _deleteCarouselUseCase;
  final UploadCarouselImage _uploadCarouselImageUseCase;

  CarouselProvider({
    required GetCarousels getCarousels,
    required CreateCarousel createCarousel,
    required UpdateCarousel updateCarousel,
    required DeleteCarousel deleteCarousel,
    required UploadCarouselImage uploadCarouselImage,
  })  : _getCarouselsUseCase = getCarousels,
        _createCarouselUseCase = createCarousel,
        _updateCarouselUseCase = updateCarousel,
        _deleteCarouselUseCase = deleteCarousel,
        _uploadCarouselImageUseCase = uploadCarouselImage;

  List<Carousel> _carousels = [];
  bool _isLoading = false;
  String? _error;
  bool _isUploading = false;
  String? _uploadedImageUrl;
  String? _uploadError;

  List<Carousel> get carousels => _carousels;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isUploading => _isUploading;
  String? get uploadedImageUrl => _uploadedImageUrl;
  String? get uploadError => _uploadError;

  /// Fetch all carousels from backend (with optional caching fallback)
  Future<void> fetchCarousels({String? category, String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _getCarouselsUseCase(
        GetCarouselsParams(category: category, search: search),
      );
      if (result is Success<List<Carousel>>) {
        _carousels = result.value;
      } else if (result is Failure<List<Carousel>>) {
        _error = result.message;
        print('Error fetching carousels: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error fetching carousels: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new carousel item and add it to the list
  Future<void> createCarousel(Carousel carousel) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _createCarouselUseCase(carousel);
      if (result is Success<Carousel>) {
        _carousels.add(result.value);
      } else if (result is Failure<Carousel>) {
        _error = result.message;
        print('Error creating carousel: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error creating carousel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update an existing carousel item by productId
  Future<void> updateCarousel(int productId, Carousel carousel) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _updateCarouselUseCase(
        UpdateCarouselParams(productId: productId, carousel: carousel),
      );
      if (result is Success<Carousel>) {
        final index = _carousels.indexWhere((c) => c.productId == productId);
        if (index != -1) _carousels[index] = result.value;
      } else if (result is Failure<Carousel>) {
        _error = result.message;
        print('Error updating carousel: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error updating carousel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a carousel item by productId
  Future<void> deleteCarousel(int productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _deleteCarouselUseCase(productId);
      if (result is Success<void>) {
        _carousels.removeWhere((c) => c.productId == productId);
      } else if (result is Failure<void>) {
        _error = result.message;
        print('Error deleting carousel: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('Unexpected error deleting carousel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Uploads a carousel image and stores the URL or error
  Future<void> uploadCarouselImage(File image) async {
    _isUploading = true;
    _uploadedImageUrl = null;
    _uploadError = null;
    notifyListeners();
    try {
      final result = await _uploadCarouselImageUseCase(image);
      if (result is Success<String>) {
        _uploadedImageUrl = result.value;
      } else if (result is Failure<String>) {
        _uploadError = result.message;
        print('Error uploading carousel image: $_uploadError');
      }
    } catch (e) {
      _uploadError = e.toString();
      print('Unexpected error uploading carousel image: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}