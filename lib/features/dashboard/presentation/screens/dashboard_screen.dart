import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../../../carousel/presentation/widgets/slidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
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
                child:
                    provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : provider.error != null
                        ? Center(child: Text('Error: ${provider.error}'))
                        : SingleChildScrollView(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overview',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 20),
                              Card(
                                child: ListTile(
                                  title: const Text('Total Products'),
                                  subtitle: Text('${provider.productCount}'),
                                  leading: const Icon(Icons.inventory),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: const Text('Total Carousels'),
                                  subtitle: Text('${provider.carouselCount}'),
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
