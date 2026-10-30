import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/visitors/data/visitors_repository.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart'
    show VisitorStatus;
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class VisitorCard extends StatefulWidget {
  const VisitorCard({super.key});

  @override
  State<VisitorCard> createState() => _VisitorCardState();
}

class _VisitorCardState extends State<VisitorCard> {
  int _expectedCount = 0;
  bool _hasAtGate = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = sl<VisitorsRepository>();
      final passes = await repo.listPasses();
      if (!mounted) return;
      final active = passes.where(
        (p) =>
            p.status == VisitorStatus.expected ||
            p.status == VisitorStatus.atGate,
      );
      setState(() {
        _expectedCount = active.length;
        _hasAtGate = active.any((p) => p.status == VisitorStatus.atGate);
      });
    } catch (_) {
      // Silently fail — dashboard widget should not block
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

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
              Icon(Icons.people_outline, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  l10n.visitors,
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.expectedToday(_expectedCount),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _hasAtGate
                  ? cs.tertiaryContainer
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _hasAtGate
                      ? Icons.doorbell_outlined
                      : Icons.check_circle_outline,
                  size: 20,
                  color: _hasAtGate
                      ? cs.onTertiaryContainer
                      : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _hasAtGate
                        ? l10n.visitorAtGate
                        : l10n.noVisitorsAtGate,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _hasAtGate
                          ? cs.onTertiaryContainer
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, RoutePath.visitors),
                  icon: const Icon(Icons.qr_code, size: 18),
                  label: Text(
                    l10n.generateQrPass,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, RoutePath.visitors),
                  icon: const Icon(Icons.history, size: 18),
                  label: Text(
                    l10n.visitorHistory,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
