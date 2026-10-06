import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class ResidencyItem {
  final String name;
  final String location;
  final int residentCount;
  final IconData icon;

  const ResidencyItem({
    required this.name,
    required this.location,
    required this.residentCount,
    required this.icon,
  });
}

class ResidencyList extends StatelessWidget {
  const ResidencyList({
    super.key,
    required this.residencies,
    required this.onTap,
  });

  final List<ResidencyItem> residencies;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (residencies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48, color: cs.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(l10n.noResidenciesFound, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                l10n.tryDifferentSearch,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: residencies.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final r = residencies[index];
        return Material(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onTap(index),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outline),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(r.icon, color: cs.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(r.location, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${r.residentCount}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: cs.primary,
                        ),
                      ),
                      Text(l10n.residents, style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
