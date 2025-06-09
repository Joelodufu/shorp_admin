import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../../features/product/presentation/providers/product_provider.dart';
import '../../../../features/carousel/presentation/providers/carousel_provider.dart';
import '../../../../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/product/data/datasources/product_local_data_source.dart'; // <-- Add this import
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_products.dart';
import '../../features/product/domain/usecases/create_product.dart';
import '../../features/product/domain/usecases/delete_product.dart';
import '../../features/product/domain/usecases/get_categories.dart';
import '../../features/product/domain/usecases/update_product.dart';
import '../../features/product/domain/usecases/upload_product_image.dart';
import '../../features/carousel/data/datasources/carousel_remote_data_source.dart';
import '../../features/carousel/data/datasources/carousel_local_data_source.dart'; // <-- Add this import
import '../../features/carousel/data/repositories/carousel_repository_impl.dart';
import '../../features/carousel/domain/repositories/carousel_repository.dart';
import '../../features/carousel/domain/usecases/get_carousels.dart';
import '../../features/carousel/domain/usecases/create_carousel.dart';
import '../../features/carousel/domain/usecases/update_carousel.dart';
import '../../features/carousel/domain/usecases/delete_carousel.dart';
import '../../features/carousel/domain/usecases/upload_carousel_image.dart';
import '../provider/theme_provider.dart'; // <-- Add this import

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

  static Future<void> init() async {
    final dio = Dio();
    final sharedPreferences = await SharedPreferences.getInstance();

    // Product Feature
    final productRemoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
    register<ProductRemoteDataSource>(productRemoteDataSource);

    final productLocalDataSource = ProductLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    ); // <-- Add this
    register<ProductLocalDataSource>(productLocalDataSource);

    final productRepository = ProductRepositoryImpl(
      remoteDataSource: productRemoteDataSource,
      localDataSource: productLocalDataSource, // <-- Add this
    );
    register<ProductRepository>(productRepository);

    register<GetProducts>(GetProducts(productRepository));
    register<GetCategories>(GetCategories(productRepository));
    register<CreateProduct>(CreateProduct(productRepository));
    register<DeleteProduct>(DeleteProduct(productRepository));
    register<UpdateProduct>(UpdateProduct(productRepository));
    register<UploadProductImage>(UploadProductImage(productRepository));

    register<ProductProvider>(
      ProductProvider(
        getProducts: get<GetProducts>(),
        getCategories: get<GetCategories>(),
        createProduct: get<CreateProduct>(),
        deleteProduct: get<DeleteProduct>(),
        updateProduct: get<UpdateProduct>(),
        uploadProductImage: get<UploadProductImage>(),
      ),
    );

    // Carousel Feature
    final carouselRemoteDataSource = CarouselRemoteDataSourceImpl(dio: dio);
    register<CarouselRemoteDataSource>(carouselRemoteDataSource);

    final carouselLocalDataSource = CarouselLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    ); // <-- Add this
    register<CarouselLocalDataSource>(carouselLocalDataSource);

    final carouselRepository = CarouselRepositoryImpl(
      remoteDataSource: carouselRemoteDataSource,
      localDataSource: carouselLocalDataSource, // <-- Add this
    );
    register<CarouselRepository>(carouselRepository);

    register<GetCarousels>(GetCarousels(carouselRepository));
    register<CreateCarousel>(CreateCarousel(carouselRepository));
    register<UpdateCarousel>(UpdateCarousel(carouselRepository));
    register<DeleteCarousel>(DeleteCarousel(carouselRepository));
    register<UploadCarouselImage>(
      UploadCarouselImage(carouselRepository),
    ); // <-- Add this

    register<CarouselProvider>(
      CarouselProvider(
        getCarousels: get<GetCarousels>(),
        createCarousel: get<CreateCarousel>(),
        updateCarousel: get<UpdateCarousel>(),
        deleteCarousel: get<DeleteCarousel>(),
        uploadCarouselImage: get<UploadCarouselImage>(), // <-- Add this
      ),
    );

    // Dashboard Feature
    register<DashboardProvider>(DashboardProvider());
  }

  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
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
