import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';
import 'package:neighbour_alert/features/visitors/widgets/qr_share_sheet.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class VisitorPassCard extends StatelessWidget {
  const VisitorPassCard({super.key, required this.pass});

  final VisitorPass pass;

  String _visitTypeLabel(AppLocalizations l10n, VisitType type) {
    return switch (type) {
      VisitType.family => l10n.visitTypeFamily,
      VisitType.delivery => l10n.visitTypeDelivery,
      VisitType.service => l10n.visitTypeService,
      VisitType.other => l10n.visitTypeOther,
    };
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final statusColor = switch (pass.status) {
      VisitorStatus.expected =>
        isDark ? AppColors.cautionDark : AppColors.caution,
      VisitorStatus.entered =>
        isDark ? AppColors.successDark : AppColors.success,
      VisitorStatus.atGate =>
        isDark ? AppColors.warningDark : AppColors.warning,
      VisitorStatus.expired => cs.onSurfaceVariant,
    };

    final statusLabel = switch (pass.status) {
      VisitorStatus.expected => l10n.visitorStatusExpected,
      VisitorStatus.entered => l10n.visitorStatusEntered,
      VisitorStatus.atGate => l10n.visitorStatusAtGate,
      VisitorStatus.expired => l10n.visitorStatusExpired,
    };

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => QrShareSheet(pass: pass),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person_outline, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pass.visitorName, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      '${_visitTypeLabel(l10n, pass.visitType)} · ${_formatTime(pass.validFrom)} - ${_formatTime(pass.validUntil)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }
}
