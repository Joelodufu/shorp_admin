import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
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
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/domain/usecases/upload_product_image.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/product/presentation/screens/product_form_screen.dart';
import 'features/product/presentation/screens/product_list_screen.dart';
import 'injection_container.dart';

void main() {
  // Initialize all dependencies before running the app
  InjectionContainer.init();
  runApp(
    DevicePreview(
      enabled: true, // Set to false in production
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide all registered providers to the widget tree
    return MultiProvider(
      providers: InjectionContainer.getProviders(),
      child: MaterialApp(
        title: 'Admin Panel',
        
        useInheritedMediaQuery: true,
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false, // Remove the debug banner
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: AppRoutes.dashboard,
        routes: {
          // Define named routes for navigation
          AppRoutes.dashboard: (context) => const DashboardScreen(),
          AppRoutes.products: (context) => const ProductListScreen(),
          AppRoutes.carousels: (context) => const CarouselListScreen(),
        },
        // Handle dynamic route generation for forms
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
          // Fallback for unknown routes
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text('Route ${settings.name} not found')),
            ),
          );
        },
        // Handle completely unknown routes
        onUnknownRoute: (settings) {
          print('Unknown route: ${settings.name}');
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text('Route ${settings.name} not found')),
            ),
          );
        },
        // Custom navigator observer for logging navigation events
        navigatorObservers: [MyNavigatorObserver()],
      ),
    );
  }
}

// Logs navigation events for debugging purposes
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

// Simple dependency injection container for registering and retrieving singletons
class InjectionContainer {
  static final Map<Type, dynamic> _instances = {};

  // Initializes and registers all dependencies for the app
  static void init() {
    // Create Dio HTTP client
    final dio = Dio();

    // Create the data source and repository once
    final productRemoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
    final productRepository = ProductRepositoryImpl(remoteDataSource: productRemoteDataSource);

    // Register ProductProvider and its dependencies
    _instances[ProductProvider] = ProductProvider(
      getProducts: GetProducts(productRepository),
      getCategories: GetCategories(productRepository),
      createProduct: CreateProduct(productRepository),
      deleteProduct: DeleteProduct(productRepository),
      updateProduct: UpdateProduct(productRepository),
      uploadProductImage: UploadProductImage(productRepository), // <-- Add this line
    );
 
    // Register CarouselProvider and its dependencies
    final carouselRepository = CarouselRepositoryImpl(
      remoteDataSource: CarouselRemoteDataSourceImpl(dio: dio),
    );
    _instances[CarouselProvider] = CarouselProvider(
      getCarousels: GetCarousels(carouselRepository),
      createCarousel: CreateCarousel(carouselRepository),
      updateCarousel: UpdateCarousel(carouselRepository),
      deleteCarousel: DeleteCarousel(carouselRepository),
    );

    // Register DashboardProvider
    _instances[DashboardProvider] = DashboardProvider();
  }

  // Retrieve a registered instance by type
  static T get<T>() {
    final instance = _instances[T];
    if (instance == null) {
      throw Exception('No instance registered for type $T');
    }
    return instance as T;
  }

  // Returns a list of providers for MultiProvider
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider<ProductProvider>.value(
        value: get<ProductProvider>(),
      ),
      ChangeNotifierProvider<CarouselProvider>.value(
        value: get<CarouselProvider>(),
      ),
      ChangeNotifierProvider<DashboardProvider>.value(
        value: get<DashboardProvider>(),
      ),
    ];
  }
}
