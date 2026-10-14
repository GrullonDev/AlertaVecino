import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final user = context.watch<SessionService>().user;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(l10n.neighborhoodInfo, style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            user?.residency ?? l10n.sampleNeighborhood,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.houseUnit(user?.house ?? '—'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(l10n.activeMemberSince, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
