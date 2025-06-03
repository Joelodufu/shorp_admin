import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/carousel.dart';
import '../providers/carousel_provider.dart';
import '../widgets/slidebar.dart';

class CarouselFormScreen extends StatefulWidget {
  final Carousel? carousel;

  const CarouselFormScreen({super.key, this.carousel});

  @override
  CarouselFormScreenState createState() => CarouselFormScreenState();
}

class CarouselFormScreenState extends State<CarouselFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.carousel != null) {
      _titleController.text = widget.carousel!.title;
      _imageUrlController.text = widget.carousel!.imageUrl;
      _linkController.text = widget.carousel!.link;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _linkController.dispose();
    super.dispose();
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
        title: Text(widget.carousel == null ? 'Add Carousel' : 'Edit Carousel'),
        leading:
            isMobile
                ? Builder(
                  builder:
                      (drawerContext) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          print('Hamburger menu tapped at ${DateTime.now()}');
                          Scaffold.of(drawerContext).openDrawer();
                        },
                      ),
                )
                : null,
      ),
      drawer:
          isMobile
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Title is required';
                            }
                            if (value.trim().length < 2) {
                              return 'Title must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Image URL is required';
                            }
                            if (!RegExp(
                              r'^https?:\/\/[^\s/$.?#].[^\s]*$',
                            ).hasMatch(value)) {
                              return 'Invalid URL format';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _linkController,
                          decoration: const InputDecoration(
                            labelText: 'Link (optional)',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            if (!RegExp(
                              r'^https?:\/\/[^\s/$.?#].[^\s]*$',
                            ).hasMatch(value)) {
                              return 'Invalid URL format';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final newCarousel = Carousel(
                                  id: widget.carousel?.id ?? '',
                                  carouselId: widget.carousel?.carouselId ?? 0,
                                  title: _titleController.text,
                                  imageUrl: _imageUrlController.text,
                                  link: _linkController.text,
                                  createdAt: widget.carousel?.createdAt ?? '',
                                  updatedAt: widget.carousel?.updatedAt ?? '',
                                );

                                if (widget.carousel == null) {
                                  provider.createCarousel(newCarousel);
                                } else {
                                  provider.updateCarousel(
                                    widget.carousel!.carouselId,
                                    newCarousel,
                                  );
                                }
                                Navigator.pop(context);
                              } catch (e) {
                                print('Error processing form: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            } else {
                              print('Form validation failed');
                            }
                          },
                          child: Text(
                            widget.carousel == null ? 'Create' : 'Update',
                          ),
                        ),
                      ],
                    ),
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
