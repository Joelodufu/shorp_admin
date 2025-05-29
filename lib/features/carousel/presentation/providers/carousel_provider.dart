import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/carousel.dart';
import '../../domain/usecases/get_carousels.dart';
import '../../domain/usecases/create_carousel.dart';
import '../../domain/usecases/update_carousel.dart';
import '../../domain/usecases/delete_carousel.dart';
import '../../../../core/error/result.dart';

class CarouselProvider with ChangeNotifier {
  final GetCarousels _getCarouselsUseCase;
  final CreateCarousel _createCarouselUseCase;
  final UpdateCarousel _updateCarouselUseCase;
  final DeleteCarousel _deleteCarouselUseCase;

  CarouselProvider({
    required GetCarousels getCarousels,
    required CreateCarousel createCarousel,
    required UpdateCarousel updateCarousel,
    required DeleteCarousel deleteCarousel,
  })  : _getCarouselsUseCase = getCarousels,
        _createCarouselUseCase = createCarousel,
        _updateCarouselUseCase = updateCarousel,
        _deleteCarouselUseCase = deleteCarousel;

  List<Carousel> _carousels = [];
  bool _isLoading = false;
  String? _error;

  List<Carousel> get carousels => _carousels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCarousels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _getCarouselsUseCase(NoParams());
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

  Future<void> updateCarousel(int carouselId, Carousel carousel) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _updateCarouselUseCase(UpdateCarouselParams(carouselId: carouselId, carousel: carousel));
      if (result is Success<Carousel>) {
        final index = _carousels.indexWhere((c) => c.carouselId == carouselId);
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

  Future<void> deleteCarousel(int carouselId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _deleteCarouselUseCase(carouselId);
      if (result is Success<void>) {
        _carousels.removeWhere((c) => c.carouselId == carouselId);
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
}