import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/constants.dart';
import 'core/widgets/connection_status_banner.dart';
import 'features/carousel/data/datasources/carousel_remote_data_source.dart';
import 'features/carousel/data/datasources/carousel_local_data_source.dart';
import 'features/carousel/data/repositories/carousel_repository_impl.dart';
import 'features/carousel/domain/entities/carousel.dart';
import 'features/carousel/domain/usecases/create_carousel.dart';
import 'features/carousel/domain/usecases/delete_carousel.dart';
import 'features/carousel/domain/usecases/get_carousels.dart';
import 'features/carousel/domain/usecases/update_carousel.dart';
import 'features/carousel/domain/usecases/upload_carousel_image.dart';
import 'features/carousel/presentation/providers/carousel_provider.dart';
import 'features/carousel/presentation/screens/carousel_form_screen.dart';
import 'features/carousel/presentation/screens/carousel_list_screen.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/datasources/product_local_data_source.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();
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
    return MultiProvider(
      providers: InjectionContainer.getProviders(),
      child: MaterialApp(
        title: 'Admin Panel',
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ConnectionStatusBanner(),
              ),
            ],
          );
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: AppRoutes.dashboard,
        routes: {
          AppRoutes.dashboard: (context) => const DashboardScreen(),
          AppRoutes.products: (context) => const ProductListScreen(),
          AppRoutes.carousel: (context) => const CarouselListScreen(),
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

// Updated dependency injection container
class InjectionContainer {
  static final Map<Type, dynamic> _instances = {};

  static T get<T>() {
    final instance = _instances[T];
    if (instance == null) {
      throw Exception('No instance registered for type $T');
    }
    return instance as T;
  }

  static void register<T>(T instance) {
    _instances[T] = instance;
  }

  // Now async to allow for SharedPreferences
  static Future<void> init() async {
    final dio = Dio();
    final sharedPreferences = await SharedPreferences.getInstance();

    // Product Feature
    final productRemoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
    final productLocalDataSource = ProductLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    final productRepository = ProductRepositoryImpl(
      remoteDataSource: productRemoteDataSource,
      localDataSource: productLocalDataSource,
    );
    register<ProductProvider>(
      ProductProvider(
        getProducts: GetProducts(productRepository),
        getCategories: GetCategories(productRepository),
        createProduct: CreateProduct(productRepository),
        deleteProduct: DeleteProduct(productRepository),
        updateProduct: UpdateProduct(productRepository),
        uploadProductImage: UploadProductImage(productRepository),
      ),
    );

    // Carousel Feature
    final carouselRemoteDataSource = CarouselRemoteDataSourceImpl(dio: dio);
    final carouselLocalDataSource = CarouselLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    final carouselRepository = CarouselRepositoryImpl(
      remoteDataSource: carouselRemoteDataSource,
      localDataSource: carouselLocalDataSource,
    );
    register<CarouselProvider>(
      CarouselProvider(
        getCarousels: GetCarousels(carouselRepository),
        createCarousel: CreateCarousel(carouselRepository),
        updateCarousel: UpdateCarousel(carouselRepository),
        deleteCarousel: DeleteCarousel(carouselRepository),
        uploadCarouselImage: UploadCarouselImage(carouselRepository),
      ),
    );

    // Dashboard Feature
    register<DashboardProvider>(DashboardProvider());
  }

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
