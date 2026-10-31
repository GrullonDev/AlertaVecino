import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neighbour_alert/features/alerts/data/alerts_datasource.dart';
import 'package:neighbour_alert/features/alerts/models/alert_history_item.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';

class AdminAlertsView extends StatefulWidget {
  const AdminAlertsView({super.key});

  @override
  State<AdminAlertsView> createState() => _AdminAlertsViewState();
}

class _AdminAlertsViewState extends State<AdminAlertsView> {
  bool _loading = true;
  List<AlertHistoryItem> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _loading = true);
    try {
      final ds = sl<AlertsDataSource>();
      final alerts = await ds.fetchActive();
      if (!mounted) return;
      setState(() {
        _alerts = alerts;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.adminActiveAlerts,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: _loadAlerts,
                icon: const Icon(Icons.refresh),
                tooltip: l10n.retry,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_alerts.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: cs.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.adminNoActiveAlerts,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadAlerts,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  return _AlertCard(alert: alert, l10n: l10n);
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.l10n});

  final AlertHistoryItem alert;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final categoryColor = switch (alert.category) {
      AlertCategory.medical => Colors.red,
      AlertCategory.security => Colors.orange,
      AlertCategory.fire => Colors.deepOrange,
      AlertCategory.general => cs.primary,
    };

    final statusLabel = switch (alert.status) {
      AlertStatus.active => l10n.alertStatusActive,
      AlertStatus.handled => l10n.alertStatusHandled,
      AlertStatus.resolved => l10n.alertStatusResolved,
      AlertStatus.falseAlarm => l10n.alertStatusFalseAlarm,
    };

    final timeStr = DateFormat.Hm().format(alert.reportedAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                switch (alert.category) {
                  AlertCategory.medical => Icons.local_hospital,
                  AlertCategory.security => Icons.shield,
                  AlertCategory.fire => Icons.local_fire_department,
                  AlertCategory.general => Icons.warning_amber,
                },
                color: categoryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusLabel,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (alert.location.isNotEmpty)
                    Text(
                      alert.location,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  if (alert.reportedBy != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${l10n.alertDetailReportedBy}: ${alert.reportedBy}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (timeStr.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      timeStr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
