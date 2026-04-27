import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/maps/pages/map_layout.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MapLayout(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade500,
        currentIndex: 1, // Mapa
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, RoutePath.home);
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, RoutePath.notifications);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, RoutePath.profile);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
