import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';
import 'package:neighbour_alert/features/visitors/widgets/visitor_pass_card.dart';
import 'package:neighbour_alert/features/visitors/widgets/visitor_at_gate_card.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class VisitorPassesTab extends StatelessWidget {
  const VisitorPassesTab({super.key, required this.passes});

  final List<VisitorPass> passes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (passes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.badge_outlined, size: 56, color: cs.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(l10n.noPasses, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                l10n.noPassesHint,
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

    final atGate = passes
        .where((p) => p.status == VisitorStatus.atGate)
        .toList();
    final others = passes
        .where((p) => p.status != VisitorStatus.atGate)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
      children: [
        for (final pass in atGate) ...[
          VisitorAtGateCard(pass: pass),
          const SizedBox(height: 12),
        ],
        if (others.isNotEmpty) ...[
          Text(l10n.activePasses, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
        ],
        for (final pass in others) ...[
          VisitorPassCard(pass: pass),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
