import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../carousel/presentation/providers/carousel_provider.dart';
import '../../../product/presentation/providers/product_provider.dart';
import '../../../carousel/presentation/widgets/slidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch carousels when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarouselProvider>(context, listen: false).fetchCarousels();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final carouselProvider = Provider.of<CarouselProvider>(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isTablet =
        MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading:
            isMobile
                ? Builder(
                  builder: (BuildContext scaffoldContext) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        print('Hamburger menu tapped at ${DateTime.now()}');
                        Scaffold.of(scaffoldContext).openDrawer();
                      },
                    );
                  },
                )
                : null,
      ),
      drawer:
          isMobile
              ? Drawer(
                child: SafeArea(
                  child: Container(color: Theme.of(context).colorScheme.primary, child: const Sidebar()),
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
                  color: Theme.of(context).colorScheme.primary,
                  child: const Sidebar(),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child:
                            carouselProvider.isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : carouselProvider.error != null
                                ? Center(
                                  child: Text(
                                    'Error: ${carouselProvider.error}',
                                  ),
                                )
                                : ListTile(
                                  title: const Text('Total Carousels'),
                                  subtitle: Text(
                                    '${carouselProvider.carousels.length}',
                                  ),
                                  leading: const Icon(Icons.inventory),
                                ),
                      ),
                      Card(
                        child:
                            productProvider.isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : productProvider.error != null
                                ? Center(
                                  child: Text(
                                    'Error: ${productProvider.error}',
                                  ),
                                )
                                : ListTile(
                                  title: const Text('Total Products'),
                                  subtitle: Text(
                                    '${productProvider.products.length}',
                                  ),
                                  leading: const Icon(Icons.image),
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
