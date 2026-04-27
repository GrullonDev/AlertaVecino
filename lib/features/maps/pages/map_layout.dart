import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/maps/widgets/map_background.dart';
import 'package:neighbour_alert/features/maps/widgets/map_filter_tabs.dart';
import 'package:neighbour_alert/features/maps/widgets/map_markers.dart';
import 'package:neighbour_alert/features/maps/widgets/map_search_bar.dart';
import 'package:neighbour_alert/features/maps/widgets/map_sos_button.dart';

class MapLayout extends StatelessWidget {
  const MapLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        // 1. Fondo del Mapa
        MapBackground(),

        // 2. Marcadores del Mapa
        MapMarkers(),

        // 3. Elementos Superiores (Búsqueda, Filtros)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  MapSearchBar(),
                  SizedBox(height: 16),
                  MapFilterTabs(),
                ],
              ),
            ),
          ),
        ),

        // 4. Botón Flotante SOS
        Positioned(
          top: 0,
          right: 16,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 170.0),
              child: MapSosButton(),
            ),
          ),
        ),
      ],
    );
  }
}
