import '../../domain/entities/carousel.dart';

class CarouselModel extends Carousel {
  CarouselModel({
    required String id,
    required int carouselId,
    required String imageUrl,
    required String title,
    required String link,
    required String createdAt,
    required String updatedAt,
  }) : super(
         id: id,
         carouselId: carouselId,
         imageUrl: imageUrl,
         title: title,
         link: link,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      id: json['_id']?.toString() ?? '',
      carouselId:
          json['carouselId'] is int
              ? json['carouselId']
              : int.tryParse(json['carouselId']?.toString() ?? '0') ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'carouselId': carouselId,
      'imageUrl': imageUrl,
      'title': title,
      'link': link,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
