import 'package:flutter/material.dart';
import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/features/alerts/data/alerts_repository.dart';
import 'package:neighbour_alert/features/alerts/models/alert_history_item.dart';
import 'package:neighbour_alert/features/alerts/widgets/alert_card.dart';
import 'package:neighbour_alert/features/alerts/widgets/alert_detail_sheet.dart';
import 'package:neighbour_alert/features/alerts/widgets/alerts_filter_tabs.dart';
import 'package:neighbour_alert/features/alerts/widgets/alerts_search_bar.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';

class AlertsLayout extends StatefulWidget {
  const AlertsLayout({super.key});

  @override
  State<AlertsLayout> createState() => _AlertsLayoutState();
}

class _AlertsLayoutState extends State<AlertsLayout> {
  AlertFilter _filter = AlertFilter.all;
  List<AlertHistoryItem> _allItems = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = sl<AlertsRepository>();
      final items = await repo.fetchHistory();
      if (!mounted) return;
      setState(() {
        _allItems = items;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.serverMessage ?? 'Error al cargar alertas';
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Error de conexión';
        _loading = false;
      });
    }
  }

  List<AlertHistoryItem> get _filtered {
    return switch (_filter) {
      AlertFilter.all => _allItems,
      AlertFilter.active =>
        _allItems.where((i) => i.status == AlertStatus.active).toList(),
      AlertFilter.resolved =>
        _allItems.where((i) => i.status == AlertStatus.resolved).toList(),
      AlertFilter.medical =>
        _allItems.where((i) => i.category == AlertCategory.medical).toList(),
      AlertFilter.security =>
        _allItems.where((i) => i.category == AlertCategory.security).toList(),
    };
  }

  void _openDetail(AlertHistoryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AlertDetailSheet(item: item),
    );
  }

  Future<void> _onRefresh() async {
    await _loadAlerts();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final items = _filtered;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: cs.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      const AlertsSearchBar(),
                      const SizedBox(height: 14),
                      AlertsFilterTabs(
                        selected: _filter,
                        onChanged: (f) => setState(() => _filter = f),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
              if (_loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_off, size: 56, color: cs.error),
                          const SizedBox(height: 16),
                          Text(_error!, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _loadAlerts,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            size: 56,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.alertsEmpty,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.alertsEmptyHint,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AlertCard(
                          item: items[index],
                          onTap: () => _openDetail(items[index]),
                        ),
                      );
                    }, childCount: items.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
