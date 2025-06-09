import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/constants.dart';
import 'core/widgets/connection_status_banner.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/product/presentation/screens/product_list_screen.dart';
import 'features/carousel/presentation/screens/carousel_list_screen.dart';
import 'features/product/domain/entities/product.dart';
import 'features/carousel/domain/entities/carousel.dart';
import 'features/product/presentation/screens/product_form_screen.dart';
import 'features/carousel/presentation/screens/carousel_form_screen.dart';
import 'core/di/injection_container.dart';

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
        theme: ThemeData(useMaterial3: true),
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
            builder: (context) => DashboardScreen(),
          );
        },
        onUnknownRoute: (settings) {
          print('Unknown route: ${settings.name}');
           return MaterialPageRoute(
            builder: (context) => DashboardScreen(),
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
