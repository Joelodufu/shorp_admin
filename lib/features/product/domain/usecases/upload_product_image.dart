import 'dart:io';
import '../../../../core/error/result.dart';
import '../repositories/product_repository.dart';

class UploadProductImage {
  final ProductRepository repository;
  UploadProductImage(this.repository);

  Future<Result<String>> call(File image) {
    return repository.uploadProductImage(image);
  }
}
