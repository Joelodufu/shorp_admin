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
    // Fetch carousels and products when the screen is loaded
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

    final theme = Theme.of(context);

    Widget statCard({
      required IconData icon,
      required String label,
      required String value,
      Color? iconColor,
      Color? bgColor,
      bool loading = false,
      String? error,
    }) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: bgColor ?? theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: (iconColor ?? theme.colorScheme.primary).withOpacity(
                    0.12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  color: iconColor ?? theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child:
                    loading
                        ? const LinearProgressIndicator()
                        : error != null
                        ? Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: theme.colorScheme.error,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                error,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              value,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.dashboard, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text('Dashboard', style: theme.textTheme.titleLarge),
          ],
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0.5,
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
      ),
      drawer:
          isMobile
              ? Drawer(
                child: SafeArea(
                  child: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: const Sidebar(),
                  ),
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
                  color: theme.scaffoldBackgroundColor,
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
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Stats cards
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          SizedBox(
                            width:
                                isMobile
                                    ? double.infinity
                                    : (constraints.maxWidth -
                                            padding * 2 -
                                            20) /
                                        2,
                            child: statCard(
                              icon: Icons.image,
                              label: 'Total Carousels',
                              value: '${carouselProvider.carousels.length}',
                              loading: carouselProvider.isLoading,
                              error: carouselProvider.error,
                              iconColor: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(
                            width:
                                isMobile
                                    ? double.infinity
                                    : (constraints.maxWidth -
                                            padding * 2 -
                                            20) /
                                        2,
                            child: statCard(
                              icon: Icons.inventory_2,
                              label: 'Total Products',
                              value: '${productProvider.products.length}',
                              loading: productProvider.isLoading,
                              error: productProvider.error,
                              iconColor: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Welcome card
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 32,
                            horizontal: 24,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.emoji_objects,
                                color: theme.colorScheme.primary,
                                size: 48,
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome to Oltron Admin!',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Manage your products and carousels with ease. '
                                      'Use the sidebar to navigate, and enjoy the new modern look!',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Micro element: Quick Actions
                      Text(
                        'Quick Actions',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/product_form');
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_photo_alternate),
                            label: const Text('Add Carousel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              foregroundColor: theme.colorScheme.onSecondary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/carousel_form');
                            },
                          ),
                        ],
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
