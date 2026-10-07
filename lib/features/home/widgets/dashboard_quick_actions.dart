import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final actions = <_QuickAction>[
      _QuickAction(
        l10n.reportIncident,
        Icons.report_problem_outlined,
        AppColors.warning,
      ),
      _QuickAction(
        l10n.accessHistory,
        Icons.door_front_door_outlined,
        AppColors.info,
      ),
      _QuickAction(
        l10n.neighborhoodDirectory,
        Icons.contacts_outlined,
        AppColors.secondary,
      ),
      _QuickAction(
        l10n.reportsToAdmin,
        Icons.assignment_outlined,
        AppColors.primary,
      ),
      _QuickAction(
        l10n.packageDeliveries,
        Icons.inventory_2_outlined,
        AppColors.caution,
      ),
      _QuickAction(
        l10n.communityEvents,
        Icons.event_outlined,
        AppColors.success,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.quickActions, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 500 ? 3 : 2;
            final itemWidth =
                (constraints.maxWidth - 12 * (crossAxisCount - 1)) /
                crossAxisCount;
            final aspectRatio = itemWidth < 140 ? 1.1 : 1.3;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: aspectRatio,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final a = actions[index];
                return _ActionTile(action: a, cs: cs, theme: theme);
              },
            );
          },
        ),
      ],
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  const _QuickAction(this.label, this.icon, this.color);
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.action,
    required this.cs,
    required this.theme,
  });

  final _QuickAction action;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: action.color, size: 24),
              ),
              Text(
                action.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 13,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
