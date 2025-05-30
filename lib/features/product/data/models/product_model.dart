import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required int productId,
    required String name,
    required String description,
    required double price,
    required String category,
    required int stock,
    required double rating,
    required double discountRate,
    required List<String> images,
    required String createdAt,
    required String updatedAt,
  }) : super(
         id: id,
         productId: productId,
         name: name,
         description: description,
         price: price,
         category: category,
         stock: stock,
         rating: rating,
         discountRate: discountRate,
         images: images,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? '',
      productId: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price:
          (json['price'] is num
              ? json['price'].toDouble()
              : double.tryParse(json['price']?.toString() ?? '0')) ??
          0.0,
      category: json['category']?.toString() ?? '',
      stock:
          json['stock'] is int
              ? json['stock']
              : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      rating:
          (json['rating'] is num
              ? json['rating'].toDouble()
              : double.tryParse(json['rating']?.toString() ?? '0')) ??
          0.0,
      discountRate:
          (json['discountRate'] is num
              ? json['discountRate'].toDouble()
              : double.tryParse(json['discountRate']?.toString() ?? '0')) ??
          0.0,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stock': stock,
      'rating': rating,
      'discountRate': discountRate,
      'images': images,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
