import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:neighbour_alert/features/announcements/data/announcements_error.dart';
import 'package:neighbour_alert/features/announcements/logic/announcements_logic.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';
import 'package:neighbour_alert/features/announcements/widgets/announcement_card.dart';
import 'package:neighbour_alert/features/announcements/widgets/announcement_detail_sheet.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class AnnouncementsLayout extends StatelessWidget {
  const AnnouncementsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Consumer<AnnouncementsLogic>(
      builder: (context, logic, _) {
        final categories = <(AnnouncementCategory?, String)>[
          (null, l10n.announcementsAll),
          (AnnouncementCategory.urgent, l10n.announcementsCategoryUrgent),
          (
            AnnouncementCategory.maintenance,
            l10n.announcementsCategoryMaintenance,
          ),
          (AnnouncementCategory.info, l10n.announcementsCategoryInfo),
        ];

        return Scaffold(
          appBar: AppBar(title: Text(l10n.announcementsTitle)),
          body: Column(
            children: [
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final (cat, label) in categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(label),
                          selected: logic.selectedCategory == cat,
                          onSelected: (_) => logic.selectCategory(cat),
                          selectedColor: cs.primaryContainer,
                          showCheckmark: false,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(child: _buildBody(context, logic, l10n, cs, theme)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AnnouncementsLogic logic,
    AppLocalizations l10n,
    ColorScheme cs,
    ThemeData theme,
  ) {
    if (logic.loading && logic.announcements.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (logic.error != null && logic.announcements.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _errorIcon(logic.error!),
                size: 56,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage(l10n, logic.error!),
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: logic.load,
                child: Text(l10n.announcementsRetry),
              ),
            ],
          ),
        ),
      );
    }

    final items = logic.announcements;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.campaign_outlined,
                size: 56,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(l10n.announcementsEmpty, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                l10n.announcementsEmptyHint,
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

    return RefreshIndicator(
      onRefresh: logic.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final a = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: AnnouncementCard(
                  announcement: a,
                  onTap: () {
                    logic.markRead(a.id);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) =>
                          AnnouncementDetailSheet(announcement: a),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _errorIcon(AnnouncementsErrorType error) {
    return switch (error) {
      AnnouncementsErrorType.connection ||
      AnnouncementsErrorType.timeout => Icons.wifi_off_outlined,
      AnnouncementsErrorType.unauthorized => Icons.lock_outline,
      _ => Icons.error_outline,
    };
  }

  String _errorMessage(AppLocalizations l10n, AnnouncementsErrorType error) {
    return switch (error) {
      AnnouncementsErrorType.connection ||
      AnnouncementsErrorType.timeout => l10n.announcementsErrorConnection,
      AnnouncementsErrorType.unauthorized => l10n.announcementsErrorAuth,
      _ => l10n.announcementsErrorGeneric,
    };
  }
}
