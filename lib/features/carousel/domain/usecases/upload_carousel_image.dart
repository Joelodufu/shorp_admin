import 'dart:io';
import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/carousel_repository.dart';

class UploadCarouselImage implements UseCase<String, File> {
  final CarouselRepository repository;

  UploadCarouselImage(this.repository);

  @override
  Future<Result<String>> call(File image) async {
    return await repository.uploadCarouselImage(image);
  }
}