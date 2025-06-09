import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

// Image preview widget
class ProductImagePreview extends StatelessWidget {
  final List<String> images;
  const ProductImagePreview({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child:
          images.isNotEmpty
              ? CachedNetworkImage(
                imageUrl: images[0],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 40),
              )
              : const Icon(Icons.image, size: 40),
    );
  }
}

// Info section widget
class ProductInfo extends StatelessWidget {
  final String name;
  final String category;
  final double price;
  const ProductInfo({
    super.key,
    required this.name,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          category,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
         SizedBox(height: 4),
        Text(
          '\₦${price.toStringAsFixed(2)}',
          style:  TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

// Actions widget
class ProductActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const ProductActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon:  Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.primary,
          ),
          tooltip: 'Edit',
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Delete',
          onPressed: onDelete,
        ),
      ],
    );
  }
}

// Main product card
class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductItem({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ProductImagePreview(images: product.images),
              const SizedBox(width: 16),
              Expanded(
                child: ProductInfo(
                  name: product.name,
                  category: product.category,
                  price: product.price,
                ),
              ),
              ProductActions(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}
