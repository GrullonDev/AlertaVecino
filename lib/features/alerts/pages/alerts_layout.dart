import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/alerts/models/alert_history_item.dart';
import 'package:neighbour_alert/features/alerts/widgets/alert_card.dart';
import 'package:neighbour_alert/features/alerts/widgets/alert_detail_sheet.dart';
import 'package:neighbour_alert/features/alerts/widgets/alerts_filter_tabs.dart';
import 'package:neighbour_alert/features/alerts/widgets/alerts_search_bar.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class AlertsLayout extends StatefulWidget {
  const AlertsLayout({super.key});

  @override
  State<AlertsLayout> createState() => _AlertsLayoutState();
}

class _AlertsLayoutState extends State<AlertsLayout> {
  AlertFilter _filter = AlertFilter.all;
  late List<AlertHistoryItem> _allItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allItems = _buildMockData(AppLocalizations.of(context)!);
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
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _allItems = _buildMockData(AppLocalizations.of(context)!);
      });
    }
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
              if (items.isEmpty)
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

  List<AlertHistoryItem> _buildMockData(AppLocalizations l10n) {
    final now = DateTime.now();
    return [
      AlertHistoryItem(
        id: '1',
        category: AlertCategory.medical,
        status: AlertStatus.active,
        title: l10n.alertMock1Title,
        location: l10n.alertMock1Location,
        reportedAt: now.subtract(const Duration(minutes: 8)),
        duration: l10n.alertMock1Duration,
        description: l10n.alertMock1Desc,
        reportedBy: l10n.alertMock1ReportedBy,
        responseTime: l10n.alertMock1ResponseTime,
      ),
      AlertHistoryItem(
        id: '2',
        category: AlertCategory.security,
        status: AlertStatus.handled,
        title: l10n.alertMock2Title,
        location: l10n.alertMock2Location,
        reportedAt: now.subtract(const Duration(minutes: 45)),
        duration: l10n.alertMock2Duration,
        description: l10n.alertMock2Desc,
        guardNotes: l10n.alertMock2GuardNotes,
        reportedBy: l10n.alertMock2ReportedBy,
        responseTime: l10n.alertMock2ResponseTime,
      ),
      AlertHistoryItem(
        id: '3',
        category: AlertCategory.fire,
        status: AlertStatus.resolved,
        title: l10n.alertMock3Title,
        location: l10n.alertMock3Location,
        reportedAt: now.subtract(const Duration(hours: 3)),
        duration: l10n.alertMock3Duration,
        description: l10n.alertMock3Desc,
        guardNotes: l10n.alertMock3GuardNotes,
        reportedBy: l10n.alertMock3ReportedBy,
        responseTime: l10n.alertMock3ResponseTime,
      ),
      AlertHistoryItem(
        id: '4',
        category: AlertCategory.security,
        status: AlertStatus.falseAlarm,
        title: l10n.alertMock4Title,
        location: l10n.alertMock4Location,
        reportedAt: now.subtract(const Duration(hours: 6)),
        duration: l10n.alertMock4Duration,
        description: l10n.alertMock4Desc,
        guardNotes: l10n.alertMock4GuardNotes,
      ),
      AlertHistoryItem(
        id: '5',
        category: AlertCategory.medical,
        status: AlertStatus.resolved,
        title: l10n.alertMock5Title,
        location: l10n.alertMock5Location,
        reportedAt: now.subtract(const Duration(days: 1, hours: 2)),
        duration: l10n.alertMock5Duration,
        description: l10n.alertMock5Desc,
        reportedBy: l10n.alertMock5ReportedBy,
        responseTime: l10n.alertMock5ResponseTime,
      ),
      AlertHistoryItem(
        id: '6',
        category: AlertCategory.general,
        status: AlertStatus.resolved,
        title: l10n.alertMock6Title,
        location: l10n.alertMock6Location,
        reportedAt: now.subtract(const Duration(days: 2)),
        duration: l10n.alertMock6Duration,
        description: l10n.alertMock6Desc,
      ),
    ];
  }
}
