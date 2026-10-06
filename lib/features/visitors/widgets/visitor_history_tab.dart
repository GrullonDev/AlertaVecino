import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class VisitorHistoryTab extends StatelessWidget {
  const VisitorHistoryTab({super.key, required this.history});

  final List<VisitorPass> history;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 56, color: cs.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(l10n.noHistory, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                l10n.noHistoryHint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _HistoryCard(entry: entry, cs: cs, theme: theme, l10n: l10n),
        );
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.entry,
    required this.cs,
    required this.theme,
    required this.l10n,
  });

  final VisitorPass entry;
  final ColorScheme cs;
  final ThemeData theme;
  final AppLocalizations l10n;

  String _formatDateTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = entry.status == VisitorStatus.entered
        ? (isDark ? AppColors.successDark : AppColors.success)
        : cs.onSurfaceVariant;
    final statusLabel = entry.status == VisitorStatus.entered
        ? l10n.visitorStatusEntered
        : l10n.visitorStatusExpired;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              entry.status == VisitorStatus.entered
                  ? Icons.login_rounded
                  : Icons.block,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.visitorName, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (entry.entryTime != null) ...[
                      Icon(
                        Icons.access_time,
                        size: 13,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTime(entry.entryTime!),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 10),
                    ],
                    if (entry.plate != null) ...[
                      Icon(
                        Icons.directions_car,
                        size: 13,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(entry.plate!, style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
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
    );
  }
}
