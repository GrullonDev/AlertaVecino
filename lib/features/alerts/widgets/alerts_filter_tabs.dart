import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

enum AlertFilter { all, active, resolved, medical, security }

class AlertsFilterTabs extends StatelessWidget {
  const AlertsFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AlertFilter selected;
  final ValueChanged<AlertFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final filters = [
      (AlertFilter.all, l10n.alertFilterAll),
      (AlertFilter.active, l10n.alertFilterActive),
      (AlertFilter.resolved, l10n.alertFilterResolved),
      (AlertFilter.medical, l10n.alertFilterMedical),
      (AlertFilter.security, l10n.alertFilterSecurity),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (filter, label) in filters) ...[
            GestureDetector(
              onTap: () => onChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected == filter ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected == filter ? cs.primary : cs.outline,
                  ),
                ),
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: selected == filter
                        ? cs.onPrimary
                        : cs.onSurfaceVariant,
                    fontWeight: selected == filter
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
