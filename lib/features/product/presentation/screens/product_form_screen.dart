import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../carousel/presentation/widgets/slidebar.dart';
import '../../data/models/product_model.dart';
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
    // Pre-fill form fields if editing an existing product
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _ratingController.text = widget.product!.rating.toString();
      _discountRateController.text = widget.product!.discountRate.toString();
      _imagesController.text = widget.product!.images.join(', ');
      // Handle category selection and custom category
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
    // Dispose controllers to free resources
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

  // Modular: Product Name Field
  Widget _buildNameField() => TextFormField(
    controller: _nameController,
    decoration: const InputDecoration(
      labelText: 'Name',
      prefixIcon: Icon(Icons.label),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Name is required';
      }
      if (value.trim().length < 2) {
        return 'Name must be at least 2 characters';
      }
      return null;
    },
  );

  // Modular: Description Field
  Widget _buildDescriptionField() => TextFormField(
    controller: _descriptionController,
    maxLines: 3,
    decoration: const InputDecoration(
      labelText: 'Description',
      prefixIcon: Icon(Icons.description),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Description is required';
      }
      if (value.trim().length < 10) {
        return 'Description must be at least 10 characters';
      }
      return null;
    },
  );

  // Modular: Price and Stock Row
  Widget _buildPriceStockRow() => Row(
    children: [
      Expanded(
        child: TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Price',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(),
          ),
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
      ),
      const SizedBox(width: 16),
      Expanded(
        child: TextFormField(
          controller: _stockController,
          decoration: const InputDecoration(
            labelText: 'Stock',
            prefixIcon: Icon(Icons.inventory),
            border: OutlineInputBorder(),
          ),
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
      ),
    ],
  );

  // Modular: Rating and Discount Row
  Widget _buildRatingDiscountRow() => Row(
    children: [
      Expanded(
        child: TextFormField(
          controller: _ratingController,
          decoration: const InputDecoration(
            labelText: 'Rating (0-5)',
            prefixIcon: Icon(Icons.star),
            border: OutlineInputBorder(),
          ),
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
      ),
      const SizedBox(width: 16),
      Expanded(
        child: TextFormField(
          controller: _discountRateController,
          decoration: const InputDecoration(
            labelText: 'Discount Rate (%)',
            prefixIcon: Icon(Icons.percent),
            border: OutlineInputBorder(),
          ),
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
      ),
    ],
  );

  // Modular: Category Dropdown
  Widget _buildCategoryDropdown(ProductProvider provider) =>
      DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: const InputDecoration(
          labelText: 'Category',
          prefixIcon: Icon(Icons.category),
          border: OutlineInputBorder(),
        ),
        items: [
          ...provider.categories.map(
            (category) =>
                DropdownMenuItem(value: category, child: Text(category)),
          ),
          const DropdownMenuItem(value: 'Custom', child: Text('Custom')),
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
      );

  // Modular: Custom Category Field
  Widget _buildCustomCategoryField() => TextFormField(
    controller: _customCategoryController,
    decoration: const InputDecoration(
      labelText: 'Custom Category',
      prefixIcon: Icon(Icons.edit),
      border: OutlineInputBorder(),
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
  );

  // Modular: Images Field
  Widget _buildImagesField() => TextFormField(
    controller: _imagesController,
    decoration: const InputDecoration(
      labelText: 'Image URLs (comma-separated, 1-5)',
      prefixIcon: Icon(Icons.image),
      border: OutlineInputBorder(),
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
  );

  // Modular: Submit Button
  Widget _buildSubmitButton(ProductProvider provider) =>
      provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(widget.product == null ? Icons.add : Icons.save),
            label: Text(
              widget.product == null ? 'Create Product' : 'Update Product',
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final imageUrls =
                      _imagesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                  final category =
                      _selectedCategory == 'Custom'
                          ? _customCategoryController.text
                          : _selectedCategory!;

                  // Always use the original productId if editing
                  final int updatingProductId = widget.product?.productId ?? 0;

                  final newProduct = Product(
                    id: widget.product?.id ?? '',
                    productId: updatingProductId,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    price: double.parse(_priceController.text),
                    category: category,
                    stock: int.parse(_stockController.text),
                    rating:
                        _ratingController.text.isNotEmpty
                            ? double.parse(_ratingController.text)
                            : 0,
                    discountRate:
                        _discountRateController.text.isNotEmpty
                            ? double.parse(_discountRateController.text)
                            : 0,
                    images: imageUrls,
                    createdAt: widget.product?.createdAt ?? '',
                    updatedAt: widget.product?.updatedAt ?? '',
                  );

                  final debugModel = ProductModel(
                    id: newProduct.id,
                    productId: newProduct.productId,
                    name: newProduct.name,
                    description: newProduct.description,
                    price: newProduct.price,
                    category: newProduct.category,
                    stock: newProduct.stock,
                    rating: newProduct.rating,
                    discountRate: newProduct.discountRate,
                    images: newProduct.images,
                    createdAt: newProduct.createdAt,
                    updatedAt: newProduct.updatedAt,
                  );

                  // LOGGING: Print product details before update
                  print('--- Product Update Debug ---');
                  print('productId: $updatingProductId');
                  print('Product JSON: ${debugModel.toJson()}');
                  print('----------------------------');

                  final provider = Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  );
                  if (widget.product == null) {
                    await provider.addProduct(newProduct);
                  } else {
                    await provider.updateProductItem(
                      updatingProductId,
                      newProduct,
                    );
                  }

                  if (provider.error == null) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${provider.error}')),
                    );
                  }
                } catch (e) {
                  print('Error processing form: $e');
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              } else {
                print('Form validation failed');
              }
            },
          );

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isTablet =
        MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 900;

    // Main scaffold for the form screen
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        leading:
            isMobile
                ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
                : null,
      ),
      drawer:
          isMobile
              ? Drawer(
                child: SafeArea(
                  child: Container(color: Colors.blue, child: const Sidebar()),
                ),
              )
              : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = isMobile ? 16.0 : 32.0;
          return Row(
            children: [
              if (!isMobile)
                Container(
                  width: isTablet ? 80 : 200,
                  color: Colors.blue,
                  child: const Sidebar(),
                ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Form Title
                              Text(
                                widget.product == null
                                    ? 'Create New Product'
                                    : 'Update Product',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              // Modularized form fields
                              _buildNameField(),
                              const SizedBox(height: 16),
                              _buildDescriptionField(),
                              const SizedBox(height: 16),
                              _buildPriceStockRow(),
                              const SizedBox(height: 16),
                              _buildRatingDiscountRow(),
                              const SizedBox(height: 16),
                              _buildCategoryDropdown(provider),
                              if (_showCustomCategoryField) ...[
                                const SizedBox(height: 16),
                                _buildCustomCategoryField(),
                              ],
                              const SizedBox(height: 16),
                              _buildImagesField(),
                              const SizedBox(height: 32),
                              // Submit button
                              _buildSubmitButton(provider),
                            ],
                          ),
                        ),
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
