import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/alerts/models/alert_history_item.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.item, required this.onTap});

  final AlertHistoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final (catColor, catIcon) = _categoryStyle(item.category, isDark);
    final (statusColor, statusLabel) = _statusStyle(item.status, isDark, l10n);

    final timeStr =
        '${item.reportedAt.day.toString().padLeft(2, '0')}/${item.reportedAt.month.toString().padLeft(2, '0')} ${item.reportedAt.hour.toString().padLeft(2, '0')}:${item.reportedAt.minute.toString().padLeft(2, '0')}';

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(catIcon, color: catColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            item.location,
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 13,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(timeStr, style: theme.textTheme.bodySmall),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '· ${item.duration}',
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  (Color, IconData) _categoryStyle(AlertCategory cat, bool isDark) {
    return switch (cat) {
      AlertCategory.medical => (
        isDark ? AppColors.panicDark : AppColors.panic,
        Icons.medical_services_outlined,
      ),
      AlertCategory.security => (
        isDark ? AppColors.warningDark : AppColors.warning,
        Icons.shield_outlined,
      ),
      AlertCategory.fire => (
        isDark ? AppColors.cautionDark : AppColors.caution,
        Icons.local_fire_department_outlined,
      ),
      AlertCategory.general => (
        isDark ? AppColors.infoDark : AppColors.info,
        Icons.info_outline,
      ),
    };
  }

  (Color, String) _statusStyle(
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
