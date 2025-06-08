import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/carousel.dart';
import '../../../product/domain/entities/product.dart';

class CarouselItem extends StatelessWidget {
  final Carousel carousel;
  final Product? product; // Pass the product associated with this carousel
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CarouselItem({
    super.key,
    required this.carousel,
    required this.onEdit,
    required this.onDelete,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main carousel image (fit to card width)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: CachedNetworkImage(
                imageUrl: carousel.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 60),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Carousel for Product ID: ${carousel.productId}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
                    IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Created: ${carousel.createdAt}\nUpdated: ${carousel.updatedAt}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          // Product card below the main image
          if (product != null)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.grey[100],
              child: ListTile(
                leading: product!.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product!.images.first,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, error, stackTrace) =>
                            const Icon(Icons.image),
                      )
                    : const Icon(Icons.image),
                title: Text(product!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('₦${product!.price.toStringAsFixed(2)}'),
                trailing: Text(
                  'Created\n${product!.createdAt}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
