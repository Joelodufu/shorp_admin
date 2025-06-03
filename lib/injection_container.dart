import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/domain/usecases/get_categories.dart';
import 'features/product/domain/usecases/update_product.dart'; // <-- Add this import
import 'features/product/domain/usecases/upload_product_image.dart'; // <-- Add this import
import 'features/product/presentation/providers/product_provider.dart';
import 'features/carousel/data/datasources/carousel_remote_data_source.dart';
import 'features/carousel/data/repositories/carousel_repository_impl.dart';
import 'features/carousel/domain/repositories/carousel_repository.dart';
import 'features/carousel/domain/usecases/get_carousels.dart';
import 'features/carousel/domain/usecases/create_carousel.dart';
import 'features/carousel/domain/usecases/update_carousel.dart';
import 'features/carousel/domain/usecases/delete_carousel.dart';
import 'features/carousel/presentation/providers/carousel_provider.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';

class InjectionContainer {
  static final Map<Type, dynamic> _instances = {};

  static T get<T>() {
    final instance = _instances[T];
    if (instance == null) {
      throw Exception('Instance of $T not found');
    }
    return instance as T;
  }

  static void register<T>(T instance) {
    _instances[T] = instance;
  }

  static void init() {
    // Core
    final dio = Dio();
    register<Dio>(dio);

    // Product Feature
    final productRemoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
    register<ProductRemoteDataSource>(productRemoteDataSource);

    final productRepository = ProductRepositoryImpl(
      remoteDataSource: productRemoteDataSource,
    );
    register<ProductRepository>(productRepository);

    register<GetProducts>(GetProducts(productRepository));
    register<GetCategories>(GetCategories(productRepository));
    register<CreateProduct>(CreateProduct(productRepository));
    register<DeleteProduct>(DeleteProduct(productRepository));
    register<UpdateProduct>(UpdateProduct(productRepository));
    register<UploadProductImage>(UploadProductImage(productRepository)); // <-- Register UploadProductImage

    register<ProductProvider>(
      ProductProvider(
        getProducts: get<GetProducts>(),
        getCategories: get<GetCategories>(),
        createProduct: get<CreateProduct>(),
        deleteProduct: get<DeleteProduct>(),
        updateProduct: get<UpdateProduct>(),
        uploadProductImage: get<UploadProductImage>(), // <-- Inject here
      ),
    );

    // Carousel Feature
    final carouselRemoteDataSource = CarouselRemoteDataSourceImpl(dio: dio);
    register<CarouselRemoteDataSource>(carouselRemoteDataSource);

    final carouselRepository = CarouselRepositoryImpl(
      remoteDataSource: carouselRemoteDataSource,
    );
    register<CarouselRepository>(carouselRepository);

    register<GetCarousels>(GetCarousels(carouselRepository));
    register<CreateCarousel>(CreateCarousel(carouselRepository));
    register<UpdateCarousel>(UpdateCarousel(carouselRepository));
    register<DeleteCarousel>(DeleteCarousel(carouselRepository));

    register<CarouselProvider>(
      CarouselProvider(
        getCarousels: get<GetCarousels>(),
        createCarousel: get<CreateCarousel>(),
        updateCarousel: get<UpdateCarousel>(),
        deleteCarousel: get<DeleteCarousel>(),
      ),
    );

    // Dashboard Feature
    register<DashboardProvider>(DashboardProvider());
  }

  static List<Widget> getProviders() {
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
