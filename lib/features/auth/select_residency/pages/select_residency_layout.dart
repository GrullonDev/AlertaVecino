import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/register/logic/register_logic.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/residency_list.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/unit_selection_sheet.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';
import 'package:neighbour_alert/utils/widgets/error_banner.dart';
import 'package:provider/provider.dart';

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
  const SelectResidencyLayout({super.key, required this.draft});

  final RegistrationDraft draft;

  @override
  State<SelectResidencyLayout> createState() => _SelectResidencyLayoutState();
}

class _SelectResidencyLayoutState extends State<SelectResidencyLayout> {
  String _searchQuery = '';

  List<_Residency> get _filtered {
    if (_searchQuery.isEmpty) return _mockResidencies;
    final q = _searchQuery.toLowerCase();
    return _mockResidencies
        .where(
          (r) =>
              r.name.toLowerCase().contains(q) ||
              r.location.toLowerCase().contains(q),
        )
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
        onConfirm: (section, unit) {
          Navigator.pop(ctx);
          _submit(residency.name, section, unit);
        },
      ),
    );
  }

  Future<void> _submit(String residency, String section, String unit) async {
    final logic = context.read<RegisterLogic>();
    final l10n = AppLocalizations.of(context)!;
    final house = [section, unit].where((s) => s.isNotEmpty).join(' ');

    final ok = await logic.register(
      draft: widget.draft,
      l10n: l10n,
      residency: residency,
      house: house,
    );

    if (ok && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePath.pendingApproval,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Consumer<RegisterLogic>(
      builder: (context, logic, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.apartment, size: 40, color: cs.primary),
                const SizedBox(height: 12),
                Text(
                  l10n.selectResidency,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.selectResidencySubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  enabled: !logic.isLoading,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: l10n.searchResidency,
                    prefixIcon: Icon(
                      Icons.search,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                if (logic.hasError) ...[
                  const SizedBox(height: 16),
                  ErrorBanner(message: logic.errorMessage!),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: logic.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ResidencyList(
                    residencies: _filtered
                        .map(
                          (r) => ResidencyItem(
                            name: r.name,
                            location: r.location,
                            residentCount: r.residentCount,
                            icon: r.icon,
                          ),
                        )
                        .toList(),
                    onTap: (index) => _onResidencySelected(_filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
