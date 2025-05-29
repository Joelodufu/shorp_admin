class Product {
  final String id;
  final int productId;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final double rating;
  final double discountRate;
  final List<String> images;
  final String createdAt;
  final String updatedAt;

  const Product({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    required this.rating,
    required this.discountRate,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });
}
