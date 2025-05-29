import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/constants.dart';
import 'features/carousel/data/datasources/carousel_remote_data_source.dart';
import 'features/carousel/data/repositories/carousel_repository_impl.dart';
import 'features/carousel/domain/entities/carousel.dart';
import 'features/carousel/domain/usecases/create_carousel.dart';
import 'features/carousel/domain/usecases/delete_carousel.dart';
import 'features/carousel/domain/usecases/get_carousels.dart';
import 'features/carousel/domain/usecases/update_carousel.dart';
import 'features/carousel/presentation/providers/carousel_provider.dart';
import 'features/carousel/presentation/screens/carousel_form_screen.dart';
import 'features/carousel/presentation/screens/carousel_list_screen.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/entities/product.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/domain/usecases/get_categories.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/product/presentation/screens/product_form_screen.dart';
import 'features/product/presentation/screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Core
    final dio = Dio();
  
    // Product Feature
    final productRemoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
    final productRepository = ProductRepositoryImpl(
      remoteDataSource: productRemoteDataSource,
    );
    final getProducts = GetProducts(productRepository);
    final getCategories = GetCategories(productRepository);
    final createProduct = CreateProduct(productRepository);
    final deleteProduct = DeleteProduct(productRepository);
    final productProvider = ProductProvider(
      getProducts: getProducts,
      getCategories: getCategories,
      createProduct: createProduct,
      deleteProduct: deleteProduct,
    );

    // Carousel Feature
    final carouselRemoteDataSource = CarouselRemoteDataSourceImpl(dio: dio);
    final carouselRepository = CarouselRepositoryImpl(
      remoteDataSource: carouselRemoteDataSource,
    );
    final getCarousels = GetCarousels(carouselRepository);
    final createCarousel = CreateCarousel(carouselRepository);
    final updateCarousel = UpdateCarousel(carouselRepository);
    final deleteCarousel = DeleteCarousel(carouselRepository);
    final carouselProvider = CarouselProvider(
      getCarousels: getCarousels,
      createCarousel: createCarousel,
      updateCarousel: updateCarousel,
      deleteCarousel: deleteCarousel,
    );

    // Dashboard Feature
    final dashboardProvider = DashboardProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
        ChangeNotifierProvider<CarouselProvider>.value(value: carouselProvider),
        ChangeNotifierProvider<DashboardProvider>.value(
          value: dashboardProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Admin Panel',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: AppRoutes.dashboard,
        routes: {
          AppRoutes.dashboard: (context) => const DashboardScreen(),
          AppRoutes.products: (context) => const ProductListScreen(),
          AppRoutes.carousels: (context) => const CarouselListScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/product_form') {
            final product = settings.arguments as Product?;
            return MaterialPageRoute(
              builder: (context) => ProductFormScreen(product: product),
            );
          }
          if (settings.name == '/carousel_form') {
            final carousel = settings.arguments as Carousel?;
            return MaterialPageRoute(
              builder: (context) => CarouselFormScreen(carousel: carousel),
            );
          }
          return MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  body: Center(child: Text('Route ${settings.name} not found')),
                ),
          );
        },
        onUnknownRoute: (settings) {
          print('Unknown route: ${settings.name}');
          return MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  body: Center(child: Text('Route ${settings.name} not found')),
                ),
          );
        },
        navigatorObservers: [MyNavigatorObserver()],
      ),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('Pushed: ${route.settings.name} at ${DateTime.now()}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('Popped: ${route.settings.name} at ${DateTime.now()}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print(
      'Replaced: ${oldRoute?.settings.name} with ${newRoute?.settings.name} at ${DateTime.now()}',
    );
  }
}
