import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/providers/product_provider.dart';
import '../../domain/entities/carousel.dart';
import '../providers/carousel_provider.dart';
import '../widgets/slidebar.dart';
import 'package:file_picker/file_picker.dart';

class CarouselFormScreen extends StatefulWidget {
  final Carousel? carousel;

  const CarouselFormScreen({super.key, this.carousel});

  @override
  CarouselFormScreenState createState() => CarouselFormScreenState();
}

class CarouselFormScreenState extends State<CarouselFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _searchController = TextEditingController();
  int? _selectedProductId;
  String? _selectedCategory;
  File? _pickedImage;

  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    if (widget.carousel != null) {
      _imageUrlController.text = widget.carousel!.imageUrl;
      _selectedProductId = widget.carousel!.productId;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(ProductProvider productProvider) {
    final search = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredProducts =
          productProvider.products.where((product) {
            final matchesCategory =
                _selectedCategory == null || _selectedCategory!.isEmpty
                    ? true
                    : product.category == _selectedCategory;
            final matchesName = product.name.toLowerCase().contains(search);
            final matchesId = product.productId.toString().contains(search);
            return matchesCategory && (matchesName || matchesId);
          }).toList();
    });
  }

  Future<void> _pickAndUploadImage(CarouselProvider provider) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedImage = File(result.files.single.path!);
      });
      await provider.uploadCarouselImage(_pickedImage!);
      if (provider.uploadedImageUrl != null) {
        setState(() {
          _imageUrlController.text = provider.uploadedImageUrl!;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image uploaded!')));
      } else if (provider.uploadError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${provider.uploadError}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carouselProvider = Provider.of<CarouselProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isTablet =
        MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 900;

    final categories =
        productProvider.products.map((p) => p.category).toSet().toList();

    if (_filteredProducts.isEmpty && productProvider.products.isNotEmpty) {
      _filteredProducts = productProvider.products;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              widget.carousel == null ? Icons.add_photo_alternate : Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(widget.carousel == null ? 'Add Carousel' : 'Edit Carousel'),
          ],
        ),
        leading:
            isMobile
                ? Builder(
                  builder:
                      (drawerContext) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(drawerContext).openDrawer();
                        },
                      ),
                )
                : null,
        elevation: 1,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      drawer:
          isMobile
              ? Drawer(
                child: SafeArea(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: const Sidebar(),
                  ),
                ),
              )
              : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = isMobile ? 12.0 : 32.0;
          return Row(
            children: [
              if (!isMobile)
                Container(
                  width: isTablet ? 80 : 200,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Sidebar(),
                ),
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // --- Category selection dropdown ---
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Filter by Category',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<String>(
                                value: '',
                                child: Text('All Categories'),
                              ),
                              ...categories.map(
                                (cat) => DropdownMenuItem<String>(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value == '' ? null : value;
                              });
                              _filterProducts(productProvider);
                            },
                          ),
                          const SizedBox(height: 16),
                          // --- Search by name or ID ---
                          TextFormField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              labelText: 'Search Product by Name or ID',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged:
                                (value) => _filterProducts(productProvider),
                          ),
                          // --- Show search results as a list ---
                          if (_searchController.text.isNotEmpty &&
                              _filteredProducts.isNotEmpty)
                            Container(
                              constraints: const BoxConstraints(maxHeight: 200),
                              margin: const EdgeInsets.only(top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product = _filteredProducts[index];
                                  return ListTile(
                                    leading:
                                        product.images.isNotEmpty
                                            ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                product.images.first,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) =>
                                                        const Icon(Icons.image),
                                              ),
                                            )
                                            : const Icon(Icons.image),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      'ID: ${product.productId} | ₦${product.price.toStringAsFixed(2)}',
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedProductId = product.productId;
                                        _searchController.text = product.name;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 20),
                          // --- Product selection dropdown ---
                          Builder(
                            builder: (context) {
                              // Ensure unique products for dropdown
                              final uniqueProducts =
                                  {
                                    for (var p in _filteredProducts)
                                      p.productId: p,
                                  }.values.toList();

                              if (_selectedProductId != null &&
                                  !uniqueProducts.any(
                                    (p) => p.productId == _selectedProductId,
                                  )) {
                                _selectedProductId = null;
                              }

                              return DropdownButtonFormField<int>(
                                value: _selectedProductId,
                                decoration: const InputDecoration(
                                  labelText: 'Select Product',
                                  prefixIcon: Icon(Icons.shopping_bag),
                                  border: OutlineInputBorder(),
                                ),
                                items:
                                    uniqueProducts
                                        .map(
                                          (product) => DropdownMenuItem<int>(
                                            value: product.productId,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.shopping_cart,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${product.name} (ID: ${product.productId})',
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedProductId = value;
                                  });
                                },
                                validator:
                                    (value) =>
                                        value == null
                                            ? 'Please select a product'
                                            : null,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          // --- Image upload button and preview ---
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _imageUrlController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Image URL',
                                    prefixIcon: Icon(Icons.link),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Image URL is required';
                                    }
                                    if (!RegExp(
                                      r'^https?:\/\/[^\s/$.?#].[^\s]*$',
                                    ).hasMatch(value)) {
                                      return 'Invalid URL format';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Consumer<CarouselProvider>(
                                builder:
                                    (context, provider, _) =>
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.cloud_upload),
                                          label: Text(
                                            provider.isUploading
                                                ? 'Uploading...'
                                                : 'Upload Image',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                provider.isUploading
                                                    ? Colors.grey
                                                    : Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed:
                                              provider.isUploading
                                                  ? null
                                                  : () => _pickAndUploadImage(
                                                    provider,
                                                  ),
                                        ),
                              ),
                            ],
                          ),
                          if (_imageUrlController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _imageUrlController.text,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 60,
                                          ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: Icon(
                              widget.carousel == null ? Icons.add : Icons.save,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final newCarousel = Carousel(
                                    id: widget.carousel?.id ?? '',
                                    productId: _selectedProductId!,
                                    imageUrl: _imageUrlController.text,
                                    createdAt: widget.carousel?.createdAt ?? '',
                                    updatedAt: widget.carousel?.updatedAt ?? '',
                                  );

                                  if (widget.carousel == null) {
                                    carouselProvider.createCarousel(
                                      newCarousel,
                                    );
                                  } else {
                                    carouselProvider.updateCarousel(
                                      widget.carousel!.productId,
                                      newCarousel,
                                    );
                                  }
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            },
                            label: Text(
                              widget.carousel == null
                                  ? 'Create Carousel'
                                  : 'Update Carousel',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
