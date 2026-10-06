import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 18) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.person, color: cs.primary, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting(l10n)}, Vecino',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(l10n.houseUnit('42'), style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        _ConnectionBadge(isConnected: true, l10n: l10n, cs: cs, theme: theme),
      ],
    );
  }
}

class _ConnectionBadge extends StatelessWidget {
  const _ConnectionBadge({
    required this.isConnected,
    required this.l10n,
    required this.cs,
    required this.theme,
  });

  final bool isConnected;
  final AppLocalizations l10n;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isConnected
            ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
            : cs.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected ? const Color(0xFF2E7D32) : cs.error,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isConnected ? l10n.connected : l10n.disconnected,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isConnected ? const Color(0xFF2E7D32) : cs.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
