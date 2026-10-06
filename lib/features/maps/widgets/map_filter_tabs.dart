import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/maps/models/map_marker_item.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class MapFilterTabs extends StatelessWidget {
  const MapFilterTabs({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final Set<MarkerCategory> active;
  final ValueChanged<MarkerCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filters = [
      (
        MarkerCategory.panic,
        l10n.mapCategoryPanic,
        isDark ? AppColors.panicDark : AppColors.panic,
        Icons.warning_amber_rounded,
      ),
      (
        MarkerCategory.gate,
        l10n.mapCategoryGates,
        isDark ? AppColors.infoDark : AppColors.info,
        Icons.door_sliding_outlined,
      ),
      (
        MarkerCategory.incident,
        l10n.mapCategoryIncidents,
        isDark ? AppColors.successDark : AppColors.success,
        Icons.report_outlined,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final (cat, label, color, icon) in filters) ...[
            _FilterChip(
              label: label,
              icon: icon,
              color: color,
              isActive: active.contains(cat),
              surface: cs.surface,
              outline: cs.outline,
              onSurfaceVariant: cs.onSurfaceVariant,
              theme: theme,
              onTap: () => onChanged(cat),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.surface,
    required this.outline,
    required this.onSurfaceVariant,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isActive;
  final Color surface;
  final Color outline;
  final Color onSurfaceVariant;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? color.withValues(alpha: 0.15) : surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? color : outline,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isActive ? color : onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isActive ? color : onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
