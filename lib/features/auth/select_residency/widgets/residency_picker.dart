import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/residency_list.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/unit_selection_sheet.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

/// Selector reutilizable de residencial + unidad.
///
/// Muestra el buscador y la lista de residenciales; al elegir una abre el
/// [UnitSelectionSheet] para indicar sección y unidad, y devuelve los tres
/// valores por [onConfirm]. Se usa tanto en el registro como al completar un
/// perfil existente.
class ResidencyPicker extends StatefulWidget {
  const ResidencyPicker({
    super.key,
    required this.residencies,
    required this.onConfirm,
    this.enabled = true,
  });

  final List<ResidencyItem> residencies;
  final void Function(String residency, String section, String unit) onConfirm;
  final bool enabled;

  @override
  State<ResidencyPicker> createState() => _ResidencyPickerState();
}

class _ResidencyPickerState extends State<ResidencyPicker> {
  String _searchQuery = '';

  List<ResidencyItem> get _filtered {
    if (_searchQuery.isEmpty) return widget.residencies;
    final q = _searchQuery.toLowerCase();
    return widget.residencies
        .where(
          (r) =>
              r.name.toLowerCase().contains(q) ||
              r.location.toLowerCase().contains(q),
        )
        .toList();
  }

  void _onSelected(ResidencyItem residency) {
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
          widget.onConfirm(residency.name, section, unit);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            enabled: widget.enabled,
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: l10n.searchResidency,
              prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ResidencyList(
            residencies: _filtered,
            onTap: (index) => _onSelected(_filtered[index]),
          ),
        ),
      ],
    );
  }
}
