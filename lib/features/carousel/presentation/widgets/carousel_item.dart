import 'package:flutter/material.dart';
import '../../domain/entities/carousel.dart';

class CarouselItem extends StatelessWidget {
  final Carousel carousel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CarouselItem({
    super.key,
    required this.carousel,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          carousel.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
        ),
        title: Text(carousel.title),
        subtitle: Text(carousel.link.isEmpty ? 'No link' : carousel.link),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
