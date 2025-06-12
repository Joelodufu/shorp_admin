import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/provider/theme_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final isCompact =
        MediaQuery.of(context).size.width < 900 &&
        MediaQuery.of(context).size.width > 600;

    Widget buildListTile({
      required IconData icon,
      required String title,
      required String route,
      required bool isSelected,
    }) {
      final listTile = ListTile(
        selectedTileColor: Theme.of(context).colorScheme.primary,
        leading: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).iconTheme.color,
        ),
        title: isCompact
            ? null
            : Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
        selected: isSelected,
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      );
      return isCompact ? Tooltip(message: title, child: listTile) : listTile;
    }

    return ListView(
      children: [
        // Logo and App Name
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Replace with your logo asset if available
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(
                    'assets/images/logo.png', // <-- Place your logo in assets and update path
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'O L T R O N',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        buildListTile(
          icon: Icons.dashboard,
          title: 'Dashboard',
          route: AppRoutes.dashboard,
          isSelected:
              ModalRoute.of(context)?.settings.name == AppRoutes.dashboard,
        ),
        buildListTile(
          icon: Icons.inventory,
          title: 'Products',
          route: AppRoutes.products,
          isSelected:
              ModalRoute.of(context)?.settings.name == AppRoutes.products,
        ),
        buildListTile(
          icon: Icons.image,
          title: 'Carousels',
          route: AppRoutes.carousel,
          isSelected:
              ModalRoute.of(context)?.settings.name == AppRoutes.carousel,
        ),
        const Divider(),
        // Theme toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              final isDark = themeProvider.themeMode == ThemeMode.dark;
              return Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isDark ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  Switch(
                    value: isDark,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) {
                      themeProvider.setTheme(
                        val ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
