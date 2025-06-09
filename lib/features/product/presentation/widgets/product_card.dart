import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/discount_badge.dart';
import '../../../../core/widgets/rating_widget.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onUpdate; // Called when card is tapped (edit)
  final VoidCallback onDelete; // Called when delete button is pressed

  const ProductCard({
    Key? key,
    required this.product,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final discount = product.discountRate;
    final discountedPrice = product.price - (product.price * discount / 100);

    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onUpdate, // Tap card to update/edit
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: product.images.isNotEmpty
                          ? product.images[0]
                          : 'https://placehold.co/150',
                      width: double.infinity,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image, color: theme.colorScheme.error),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shopping_bag,
                              color: theme.colorScheme.primary, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              product.name,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: isMobile ? 14 : 16,
                                color: theme.textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (discount > 0)
                                Text(
                                  '₦${product.price.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: theme.disabledColor,
                                    fontSize: isMobile ? 12 : 14,
                                  ),
                                ),
                              if (discount > 0) const SizedBox(width: 8),
                              Text(
                                '₦${discountedPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 14 : 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          RatingWidget(
                            rating: product.rating.toInt(),
                            isMobile: isMobile,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: onDelete, // Delete action
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: const Icon(Icons.delete, size: 16),
                        label: Text(
                          'Delete',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: isMobile ? 12 : 14,
                            color: theme.colorScheme.onError,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (discount > 0)
              Positioned(
                top: 8,
                left: 8,
                child: DiscountBadge(percentage: discount),
              ),
          ],
        ),
      ),
    );
  }
}
