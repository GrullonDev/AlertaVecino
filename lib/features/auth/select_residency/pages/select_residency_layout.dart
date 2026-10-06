import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/residency_list.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/unit_selection_sheet.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class _Residency {
  final String name;
  final String location;
  final int residentCount;
  final IconData icon;

  const _Residency({
    required this.name,
    required this.location,
    required this.residentCount,
    required this.icon,
  });
}

const _mockResidencies = [
  _Residency(
    name: 'Colonia La Esperanza',
    location: 'Zona 10, Guatemala',
    residentCount: 234,
    icon: Icons.location_city,
  ),
  _Residency(
    name: 'Residencial Los Álamos',
    location: 'Zona 16, Guatemala',
    residentCount: 180,
    icon: Icons.apartment,
  ),
  _Residency(
    name: 'Condominio Vista Hermosa',
    location: 'Zona 15, Guatemala',
    residentCount: 312,
    icon: Icons.home_work,
  ),
  _Residency(
    name: 'Residencial El Encinal',
    location: 'Carretera a El Salvador',
    residentCount: 156,
    icon: Icons.villa,
  ),
  _Residency(
    name: 'Torres del Campo',
    location: 'Zona 14, Guatemala',
    residentCount: 420,
    icon: Icons.domain,
  ),
  _Residency(
    name: 'Colonia San Cristóbal',
    location: 'Mixco, Guatemala',
    residentCount: 98,
    icon: Icons.holiday_village,
  ),
];

class SelectResidencyLayout extends StatefulWidget {
  const SelectResidencyLayout({super.key});

  @override
  State<SelectResidencyLayout> createState() => _SelectResidencyLayoutState();
}

class _SelectResidencyLayoutState extends State<SelectResidencyLayout> {
  String _searchQuery = '';

  List<_Residency> get _filtered {
    if (_searchQuery.isEmpty) return _mockResidencies;
    final q = _searchQuery.toLowerCase();
    return _mockResidencies
        .where((r) =>
            r.name.toLowerCase().contains(q) ||
            r.location.toLowerCase().contains(q))
        .toList();
  }

  void _onResidencySelected(_Residency residency) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => UnitSelectionSheet(
        residencyName: residency.name,
        onConfirm: () {
          Navigator.pop(ctx);
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutePath.pendingApproval,
            (route) => false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.apartment, size: 40, color: cs.primary),
              const SizedBox(height: 12),
              Text(l10n.selectResidency, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                l10n.selectResidencySubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: l10n.searchResidency,
                  prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ResidencyList(
            residencies: _filtered
                .map((r) => ResidencyItem(
                      name: r.name,
                      location: r.location,
                      residentCount: r.residentCount,
                      icon: r.icon,
                    ))
                .toList(),
            onTap: (index) => _onResidencySelected(_filtered[index]),
          ),
        ),
      ],
    );
  }
}
