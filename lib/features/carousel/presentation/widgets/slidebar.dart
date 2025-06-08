import 'package:flutter/material.dart';
import '../../../../core/utils/constants.dart';

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
        leading: Icon(icon),
        title: isCompact ? null : Text(title),
        selected: isSelected,
        onTap: () {
          print('Navigating to $route at ${DateTime.now()}');
          Navigator.pushReplacementNamed(context, route);
        },
      );
      return isCompact ? Tooltip(message: title, child: listTile) : listTile;
    }

    return ListView(
      children: [
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
      ],
    );
  }
}
