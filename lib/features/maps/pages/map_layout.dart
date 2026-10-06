import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:neighbour_alert/features/maps/models/map_marker_item.dart';
import 'package:neighbour_alert/features/maps/widgets/map_background.dart';
import 'package:neighbour_alert/features/maps/widgets/map_detail_card.dart';
import 'package:neighbour_alert/features/maps/widgets/map_filter_tabs.dart';
import 'package:neighbour_alert/features/maps/widgets/map_markers.dart';
import 'package:neighbour_alert/features/maps/widgets/map_search_bar.dart';
import 'package:neighbour_alert/features/maps/widgets/map_sos_button.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class MapLayout extends StatefulWidget {
  const MapLayout({super.key});

  @override
  State<MapLayout> createState() => _MapLayoutState();
}

class _MapLayoutState extends State<MapLayout> {
  final _mapController = MapController();
  late List<MapMarkerItem> _allMarkers;
  final Set<MarkerCategory> _activeFilters = {
    MarkerCategory.panic,
    MarkerCategory.gate,
    MarkerCategory.incident,
  };
  MapMarkerItem? _selectedMarker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allMarkers = buildMockMarkers(AppLocalizations.of(context)!);
  }

  List<MapMarkerItem> get _filteredMarkers =>
      _allMarkers.where((m) => _activeFilters.contains(m.category)).toList();

  void _toggleFilter(MarkerCategory cat) {
    setState(() {
      if (_activeFilters.contains(cat)) {
        if (_activeFilters.length > 1) _activeFilters.remove(cat);
      } else {
        _activeFilters.add(cat);
      }
      if (_selectedMarker != null &&
          !_activeFilters.contains(_selectedMarker!.category)) {
        _selectedMarker = null;
      }
    });
  }

  void _selectMarker(MapMarkerItem marker) {
    setState(() => _selectedMarker = marker);
    _mapController.move(marker.position, _mapController.camera.zoom);
  }

  void _clearSelection() {
    setState(() => _selectedMarker = null);
  }

  void _goToMyLocation() {
    _mapController.move(MapBackground.sanMiguelPetapa, 16.0);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        MapBackground(
          controller: _mapController,
          markers: _filteredMarkers,
          onMarkerTap: _selectMarker,
          onTap: _clearSelection,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: MapSearchBar(),
                ),
                const SizedBox(height: 12),
                MapFilterTabs(active: _activeFilters, onChanged: _toggleFilter),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 16,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 140),
              child: Column(
                children: [
                  const MapSosButton(),
                  const SizedBox(height: 12),
                  _MapFab(
                    icon: Icons.my_location,
                    surface: cs.surface,
                    onSurface: cs.primary,
                    outline: cs.outline,
                    onTap: _goToMyLocation,
                  ),
                  const SizedBox(height: 8),
                  _MapFab(
                    icon: Icons.add,
                    surface: cs.surface,
                    onSurface: cs.onSurface,
                    outline: cs.outline,
                    onTap: () => _mapController.move(
                      _mapController.camera.center,
                      (_mapController.camera.zoom + 1).clamp(10, 18),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _MapFab(
                    icon: Icons.remove,
                    surface: cs.surface,
                    onSurface: cs.onSurface,
                    outline: cs.outline,
                    onTap: () => _mapController.move(
                      _mapController.camera.center,
                      (_mapController.camera.zoom - 1).clamp(10, 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_selectedMarker != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: MapDetailCard(
                marker: _selectedMarker!,
                onClose: _clearSelection,
              ),
            ),
          ),
      ],
    );
  }
}

class _MapFab extends StatelessWidget {
  const _MapFab({
    required this.icon,
    required this.surface,
    required this.onSurface,
    required this.outline,
    required this.onTap,
  });

  final IconData icon;
  final Color surface;
  final Color onSurface;
  final Color outline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: outline),
          ),
          child: Icon(icon, color: onSurface, size: 22),
        ),
      ),
    );
  }
}
