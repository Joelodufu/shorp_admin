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
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main carousel image (fit to card width)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: CachedNetworkImage(
                imageUrl: carousel.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
                errorWidget: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 60, color: theme.colorScheme.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.photo_library, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Product ID: ${carousel.productId}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: 'Edit Carousel',
                      child: IconButton(
                        icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                        onPressed: onEdit,
                      ),
                    ),
                    Tooltip(
                      message: 'Delete Carousel',
                      child: IconButton(
                        icon: Icon(Icons.delete, color: theme.colorScheme.error),
                        onPressed: onDelete,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 14, color: theme.hintColor),
                const SizedBox(width: 4),
                Text(
                  'Created: ${carousel.createdAt}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.update, size: 14, color: theme.hintColor),
                const SizedBox(width: 4),
                Text(
                  'Updated: ${carousel.updatedAt}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Product card below the main image
          if (product != null)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: theme.colorScheme.surface.withOpacity(0.95),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: product!.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: product!.images.first,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary)),
                          errorWidget: (context, error, stackTrace) =>
                              Icon(Icons.image, color: theme.hintColor),
                        ),
                      )
                    : Icon(Icons.image, color: theme.hintColor),
                title: Row(
                  children: [
                    Icon(Icons.shopping_bag, color: theme.colorScheme.primary, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        product!.name,
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.attach_money, size: 14, color: theme.colorScheme.primary),
                    const SizedBox(width: 2),
                    Text(
                      '₦${product!.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 13, color: theme.hintColor),
                    const SizedBox(height: 2),
                    Text(
                      product!.createdAt,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          // Micro element: subtle divider and shadow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(
              color: theme.dividerColor.withOpacity(0.15),
              thickness: 1,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
