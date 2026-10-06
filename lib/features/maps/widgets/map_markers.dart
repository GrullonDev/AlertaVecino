import 'package:latlong2/latlong.dart';
import 'package:neighbour_alert/features/maps/models/map_marker_item.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

List<MapMarkerItem> buildMockMarkers(AppLocalizations l10n) {
  return [
    MapMarkerItem(
      id: 'p1',
      title: l10n.mapMockPanic1Title,
      description: l10n.mapMockPanic1Desc,
      category: MarkerCategory.panic,
      position: const LatLng(14.5275, -90.5545),
      timeAgo: l10n.announcementsTimeAgo(l10n.announcementsMinutes(5)),
    ),
    MapMarkerItem(
      id: 'p2',
      title: l10n.mapMockPanic2Title,
      description: l10n.mapMockPanic2Desc,
      category: MarkerCategory.panic,
      position: const LatLng(14.5240, -90.5580),
      timeAgo: l10n.announcementsTimeAgo(l10n.announcementsMinutes(12)),
    ),
    MapMarkerItem(
      id: 'g1',
      title: l10n.mapMockGate1Title,
      description: l10n.mapMockGate1Desc,
      category: MarkerCategory.gate,
      position: const LatLng(14.5265, -90.5555),
      timeAgo: '',
    ),
    MapMarkerItem(
      id: 'g2',
      title: l10n.mapMockGate2Title,
      description: l10n.mapMockGate2Desc,
      category: MarkerCategory.gate,
      position: const LatLng(14.5250, -90.5530),
      timeAgo: '',
    ),
    MapMarkerItem(
      id: 'i1',
      title: l10n.mapMockIncident1Title,
      description: l10n.mapMockIncident1Desc,
      category: MarkerCategory.incident,
      position: const LatLng(14.5255, -90.5570),
      timeAgo: l10n.announcementsTimeAgo(l10n.announcementsHours(1)),
    ),
    MapMarkerItem(
      id: 'i2',
      title: l10n.mapMockIncident2Title,
      description: l10n.mapMockIncident2Desc,
      category: MarkerCategory.incident,
      position: const LatLng(14.5280, -90.5520),
      timeAgo: l10n.announcementsTimeAgo(l10n.announcementsHours(3)),
    ),
  ];
}
