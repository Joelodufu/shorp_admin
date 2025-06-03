import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../carousel/presentation/widgets/slidebar.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';
import '../widgets/product_item.dart'; // <-- Import your modular widgets

enum ProductViewType { table, card }

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _initialized = false;
  String? _selectedCategory;
  String _search = '';
  ProductViewType _viewType = ProductViewType.table;

  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.fetchProducts();
      provider.fetchCategories();
      _initialized = true;
    }
  }

  void _openProductForm({product}) async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );
    if (result == true) {
      provider.fetchProducts(category: _selectedCategory, search: _search);
      provider.fetchCategories();
    }
  }

  void _onSearchChanged(String value) {
    setState(() => _search = value);
    Provider.of<ProductProvider>(
      context,
      listen: false,
    ).fetchProducts(category: _selectedCategory, search: value);
  }

  void _onCategoryChanged(String? value) {
    setState(() => _selectedCategory = value);
    Provider.of<ProductProvider>(
      context,
      listen: false,
    ).fetchProducts(category: value, search: _search);
  }

  Future<void> _confirmDelete(
    BuildContext parentContext, // <-- Use parent context
    int productId,
    String name,
  ) async {
    final provider = Provider.of<ProductProvider>(parentContext, listen: false);
    final confirmed = await showDialog<bool>(
      context: parentContext,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text('Are you sure you want to delete "$name"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await provider.deleteProductItem(productId);
      if (provider.error == null) {
        key.currentState?.showSnackBar(
          SnackBar(content: Text('Product "$name" deleted')),
        );
      } else {
        key.currentState?.showSnackBar(
          SnackBar(content: Text('Error: ${provider.error}')),
        );
      }
    }
  }

  // Use modular widgets in table view
  Widget _buildTableView(ProductProvider provider, bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: isMobile ? 12 : 24,
        headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
        columns: const [
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Actions')),
        ],
        rows:
            provider.products.map((product) {
              return DataRow(
                cells: [
                  DataCell(ProductImagePreview(images: product.images)),
                  DataCell(
                    Text(
                      product.name.length > 15 && isMobile
                          ? '${product.name.substring(0, 15)}...'
                          : product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      '₦${product.price.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      product.category.length > 15
                          ? '${product.category.substring(0, 15)}...'
                          : product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    ProductActions(
                      onEdit: () => _openProductForm(product: product),
                      onDelete:
                          () => _confirmDelete(
                            context,
                            product.productId,
                            product.name,
                          ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  // Use modular widgets in card view
  Widget _buildCardView(ProductProvider provider, bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        return ProductCard(
          product: product,
          onUpdate:
              () => _openProductForm(product: product), // Tap card to edit
          onDelete:
              () => _confirmDelete(
                context,
                product.productId,
                product.name,
              ), // Delete button
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = context; // Save the parent context
    final provider = Provider.of<ProductProvider>(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isTablet =
        MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Products'),
        leading:
            isMobile
                ? Builder(
                  builder: (BuildContext scaffoldContext) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(scaffoldContext).openDrawer();
                      },
                    );
                  },
                )
                : null,
        actions: [
          IconButton(
            icon: Icon(
              _viewType == ProductViewType.table
                  ? Icons.view_module
                  : Icons.table_chart,
            ),
            tooltip:
                _viewType == ProductViewType.table
                    ? 'Switch to Card View'
                    : 'Switch to Table View',
            onPressed: () {
              setState(() {
                _viewType =
                    _viewType == ProductViewType.table
                        ? ProductViewType.card
                        : ProductViewType.table;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openProductForm(),
          ),
        ],
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
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search and Filter Row
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Search products...',
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged: _onSearchChanged,
                            ),
                          ),
                          const SizedBox(width: 16),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            hint: const Text('All Categories'),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All'),
                              ),
                              ...provider.categories.map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              ),
                            ],
                            onChanged: _onCategoryChanged,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : provider.error != null
                          ? Center(child: Text('Error: ${provider.error}'))
                          : provider.products.isEmpty
                          ? const Center(child: Text('No products found'))
                          : Expanded(
                            child:
                                _viewType == ProductViewType.table
                                    ? _buildTableView(provider, isMobile)
                                    : _buildCardView(provider, isMobile),
                          ),
                    ],
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
