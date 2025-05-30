import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../carousel/presentation/widgets/slidebar.dart';
import '../providers/product_provider.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _initialized = false;
  String? _selectedCategory;
  String _search = '';

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
    print(product.productId);
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
    BuildContext context,
    int productId,
    String name,
  ) async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Product "$name" deleted')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${provider.error}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isTablet =
        MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 900;

    return Scaffold(
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
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Price')),
                                  DataColumn(label: Text('Category')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows:
                                    provider.products.map((product) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(product.name)),
                                          DataCell(
                                            Text(
                                              '\$${product.price.toStringAsFixed(2)}',
                                            ),
                                          ),
                                          DataCell(Text(product.category)),
                                          DataCell(
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed:
                                                      () => _openProductForm(
                                                        product: product,
                                                      ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                  ),
                                                  onPressed:
                                                      () => _confirmDelete(
                                                        context,
                                                        product.productId,
                                                        product.name,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                              ),
                            ),
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
