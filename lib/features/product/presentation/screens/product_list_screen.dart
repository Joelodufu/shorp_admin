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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<ProductProvider>(context, listen: false).fetchCategories();
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
    // If a product was created or edited, refresh products
    if (result == true) {
      provider.fetchProducts();
      provider.fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isTablet = MediaQuery.of(context).size.width > 600 && MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        leading: isMobile
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
      drawer: isMobile
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
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.error != null
                        ? Center(child: Text('Error: ${provider.error}'))
                        : provider.products.isEmpty
                            ? const Center(child: Text('No products found'))
                            : SingleChildScrollView(
                                padding: EdgeInsets.all(padding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: ElevatedButton.icon(
                                        onPressed: () => _openProductForm(),
                                        icon: const Icon(Icons.add),
                                        label: const Text('Create Product'),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columns: const [
                                          DataColumn(label: Text('Name')),
                                          DataColumn(label: Text('Price')),
                                          DataColumn(label: Text('Category')),
                                          DataColumn(label: Text('Actions')),
                                        ],
                                        rows: provider.products.map((product) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(product.name)),
                                              DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
                                              DataCell(Text(product.category)),
                                              DataCell(
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.edit),
                                                      onPressed: () => _openProductForm(product: product),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.delete),
                                                      onPressed: () async {
                                                        await provider.deleteProductItem(product.productId);
                                                        if (provider.error == null) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text('Product ${product.name} deleted')),
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text('Error: ${provider.error}')),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
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