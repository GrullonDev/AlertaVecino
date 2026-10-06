import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/alerts/models/alert_history_item.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class AlertDetailSheet extends StatelessWidget {
  const AlertDetailSheet({super.key, required this.item});

  final AlertHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final (catColor, catIcon, catLabel) = _categoryInfo(
      item.category,
      isDark,
      l10n,
    );
    final (statusColor, statusLabel) = _statusInfo(item.status, isDark, l10n);

    final timeStr =
        '${item.reportedAt.day.toString().padLeft(2, '0')}/${item.reportedAt.month.toString().padLeft(2, '0')}/${item.reportedAt.year} ${item.reportedAt.hour.toString().padLeft(2, '0')}:${item.reportedAt.minute.toString().padLeft(2, '0')}';

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(catIcon, color: catColor, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                catLabel,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: catColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                statusLabel,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _DetailRow(
                icon: Icons.location_on_outlined,
                label: l10n.alertDetailLocation,
                value: item.location,
                cs: cs,
                theme: theme,
              ),
              _DetailRow(
                icon: Icons.access_time,
                label: l10n.alertDetailReportedAt,
                value: timeStr,
                cs: cs,
                theme: theme,
              ),
              _DetailRow(
                icon: Icons.timer_outlined,
                label: l10n.alertDetailDuration,
                value: item.duration,
                cs: cs,
                theme: theme,
              ),
              if (item.reportedBy != null)
                _DetailRow(
                  icon: Icons.person_outline,
                  label: l10n.alertDetailReportedBy,
                  value: item.reportedBy!,
                  cs: cs,
                  theme: theme,
                ),
              if (item.responseTime != null)
                _DetailRow(
                  icon: Icons.speed,
                  label: l10n.alertDetailResponseTime,
                  value: item.responseTime!,
                  cs: cs,
                  theme: theme,
                ),
              const SizedBox(height: 16),
              Text(
                l10n.alertDetailDescription,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              if (item.guardNotes != null) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.alertDetailGuardNotes,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outline),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 18,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.guardNotes!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  (Color, IconData, String) _categoryInfo(
    AlertCategory cat,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return switch (cat) {
      AlertCategory.medical => (
        isDark ? AppColors.panicDark : AppColors.panic,
        Icons.medical_services_outlined,
        l10n.alertFilterMedical,
      ),
      AlertCategory.security => (
        isDark ? AppColors.warningDark : AppColors.warning,
        Icons.shield_outlined,
        l10n.alertFilterSecurity,
      ),
      AlertCategory.fire => (
        isDark ? AppColors.cautionDark : AppColors.caution,
        Icons.local_fire_department_outlined,
        l10n.alertCategoryFire,
      ),
      AlertCategory.general => (
        isDark ? AppColors.infoDark : AppColors.info,
        Icons.info_outline,
        l10n.alertCategoryGeneral,
      ),
    };
  }

  (Color, String) _statusInfo(
    AlertStatus status,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return switch (status) {
      AlertStatus.active => (
        isDark ? AppColors.panicDark : AppColors.panic,
        l10n.alertStatusActive,
      ),
      AlertStatus.handled => (
        isDark ? AppColors.cautionDark : AppColors.caution,
        l10n.alertStatusHandled,
      ),
      AlertStatus.resolved => (
        isDark ? AppColors.successDark : AppColors.success,
        l10n.alertStatusResolved,
      ),
      AlertStatus.falseAlarm => (
        isDark ? const Color(0xFF8B90A0) : const Color(0xFF6B7080),
        l10n.alertStatusFalseAlarm,
      ),
    };
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
