import '../../domain/entities/carousel.dart';

class CarouselModel extends Carousel {
  CarouselModel({
    required String id,
    required int productId,
    required String imageUrl,
    required String createdAt,
    required String updatedAt,
  }) : super(
          id: id,
          productId: productId,
          imageUrl: imageUrl,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      id: json['_id']?.toString() ?? '',
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId']?.toString() ?? '0') ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
