import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../carousel/presentation/widgets/slidebar.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  ProductFormScreenState createState() => ProductFormScreenState();
}

class ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showCustomCategoryField = false;
  String? _selectedCategory;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _customCategoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _ratingController = TextEditingController();
  final _discountRateController = TextEditingController();
  final _imagesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _ratingController.text = widget.product!.rating.toString();
      _discountRateController.text = widget.product!.discountRate.toString();
      _imagesController.text = widget.product!.images.join(', ');
      if (provider.categories.contains(widget.product!.category)) {
        _selectedCategory = widget.product!.category;
      } else {
        _selectedCategory = 'Custom';
        _showCustomCategoryField = true;
        _customCategoryController.text = widget.product!.category;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _customCategoryController.dispose();
    _stockController.dispose();
    _ratingController.dispose();
    _discountRateController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isTablet = MediaQuery.of(context).size.width > 600 && MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        leading: isMobile
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  print('Hamburger menu tapped at ${DateTime.now()}');
                  Scaffold.of(context).openDrawer();
                },
              )
            : null,
      ),
      drawer: isMobile
          ? Drawer(
              child: SafeArea(
                child: Container(
                  color: Colors.blue,
                  child: const Sidebar(),
                ),
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = isMobile ? 16.0 : 24.0;
          return Row(
            children: [
              if (!isMobile)
                Container(
                  width: isTablet ? 80 : 200,
                  color: Colors.blue,
                  child: const Sidebar(),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Description is required';
                            }
                            if (value.trim().length < 10) {
                              return 'Description must be at least 10 characters';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Price is required';
                            }
                            final price = double.tryParse(value);
                            if (price == null || price < 0) {
                              return 'Enter a valid price';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            hintText: 'Select a category or choose Custom',
                          ),
                          items: [
                            ...provider.categories.map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            ),
                            const DropdownMenuItem(
                              value: 'Custom',
                              child: Text('Custom'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                              _showCustomCategoryField = value == 'Custom';
                              if (value != 'Custom') {
                                _customCategoryController.clear();
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Category is required';
                            }
                            return null;
                          },
                        ),
                        if (_showCustomCategoryField)
                          TextFormField(
                            controller: _customCategoryController,
                            decoration: const InputDecoration(
                              labelText: 'Custom Category',
                              hintText: 'Enter a new category',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Custom category is required';
                              }
                              if (value.trim().length < 2) {
                                return 'Category must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                        TextFormField(
                          controller: _stockController,
                          decoration: const InputDecoration(labelText: 'Stock'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Stock is required';
                            }
                            final stock = int.tryParse(value);
                            if (stock == null || stock < 0) {
                              return 'Enter a valid stock';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _ratingController,
                          decoration: const InputDecoration(labelText: 'Rating (0-5)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            final rating = double.tryParse(value);
                            if (rating == null || rating < 0 || rating > 5) {
                              return 'Rating must be between 0 and 5';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _discountRateController,
                          decoration: const InputDecoration(labelText: 'Discount Rate (0-100)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            final rate = double.tryParse(value);
                            if (rate == null || rate < 0 || rate > 100) {
                              return 'Discount rate must be between 0 and 100';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _imagesController,
                          decoration: const InputDecoration(
                            labelText: 'Image URLs (comma-separated, 1-5)',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'At least one image URL is required';
                            }
                            final urls = value.split(',').map((e) => e.trim()).toList();
                            if (urls.length < 1 || urls.length > 5) {
                              return 'Must provide 1-5 URLs';
                            }
                            for (var url in urls) {
                              if (url.isEmpty) {
                                return 'No empty URLs allowed';
                              }
                              if (!RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$').hasMatch(url)) {
                                return 'Invalid URL format: $url';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final imageUrls = _imagesController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList();
                                print('Processed image URLs: $imageUrls');

                                final category = _selectedCategory == 'Custom'
                                    ? _customCategoryController.text
                                    : _selectedCategory!;

                                final newProduct = Product(
                                  id: widget.product?.id ?? '',
                                  productId: widget.product?.productId ?? 0,
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  price: double.parse(_priceController.text),
                                  category: category,
                                  stock: int.parse(_stockController.text),
                                  rating: _ratingController.text.isNotEmpty
                                      ? double.parse(_ratingController.text)
                                      : 0,
                                  discountRate: _discountRateController.text.isNotEmpty
                                      ? double.parse(_discountRateController.text)
                                      : 0,
                                  images: imageUrls,
                                  createdAt: widget.product?.createdAt ?? '',
                                  updatedAt: widget.product?.updatedAt ?? '',
                                );

                                final provider = Provider.of<ProductProvider>(context, listen: false);
                                if (widget.product == null) {
                                  provider.addProduct(newProduct);
                                } 
                                Navigator.pop(context);
                              } catch (e) {
                                print('Error processing form: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            } else {
                              print('Form validation failed');
                            }
                          },
                          child: Text(widget.product == null ? 'Create' : 'Update'),
                        ),
                      ],
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