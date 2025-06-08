import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/carousel.dart';
import '../providers/carousel_provider.dart';
import '../widgets/carousel_item.dart';
import '../widgets/slidebar.dart';

class CarouselListScreen extends StatefulWidget {
  const CarouselListScreen({super.key});

  @override
  State<CarouselListScreen> createState() => _CarouselListScreenState();
}

class _CarouselListScreenState extends State<CarouselListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch carousels when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarouselProvider>(context, listen: false).fetchCarousels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarouselProvider>(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isTablet =
        MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carousels'),
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
            onPressed: () {
              Navigator.pushNamed(context, '/carousel_form');
            },
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
                        : provider.carousels.isEmpty
                            ? const Center(child: Text('No carousels found'))
                            : ListView.builder(
                                padding: EdgeInsets.all(padding),
                                itemCount: provider.carousels.length,
                                itemBuilder: (context, index) {
                                  final carousel = provider.carousels[index];
                                  return CarouselItem(
                                    carousel: carousel,
                                    onEdit: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/carousel_form',
                                        arguments: carousel,
                                      );
                                    },
                                    onDelete: () {
                                      provider.deleteCarousel(carousel.productId);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Carousel deleted',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}
