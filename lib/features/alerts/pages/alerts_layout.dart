import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/alerts/widgets/alert_card.dart';
import 'package:neighbour_alert/features/alerts/widgets/alerts_filter_tabs.dart';
import 'package:neighbour_alert/features/alerts/widgets/alerts_search_bar.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class AlertsLayout extends StatelessWidget {
  const AlertsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const AlertsSearchBar(),
        const SizedBox(height: 16),
        const AlertsFilterTabs(),
        const SizedBox(height: 16),

        AlertCard(
          type: AlertType.urgent,
          title: 'Severe Weather Warning: Flash Flood',
          timeAgo: '2 mins ago',
          description:
              'Immediate evacuation recommended for residents near the Creek Drive area. Heavy rainfall expected to continue for 4 hours.',
          primaryActionText: l10n.viewDetails,
          showShare: true,
        ),
        const SizedBox(height: 12),

        AlertCard(
          type: AlertType.update,
          title: 'Main St. Road Closure Resolved',
          timeAgo: '45 mins ago',
          description:
              'The maintenance work on Main St. and 5th Ave intersection is now complete. Traffic flow has returned to normal.',
          primaryActionText: l10n.viewDetails,
        ),
        const SizedBox(height: 12),

        AlertCard(
          type: AlertType.general,
          title: 'Community Town Hall Meeting',
          timeAgo: '3 hours ago',
          description:
              'Join us this Thursday at the Community Center to discuss the new park development project and safety initiatives.',
          primaryActionText: l10n.viewDetails,
        ),
        const SizedBox(height: 12),

        AlertCard(
          type: AlertType.resolved,
          title: 'Utility Restoration: Oak District',
          timeAgo: '5 hours ago',
          description:
              'Power has been successfully restored to all households in the Oak District following earlier transformer maintenance.',
          primaryActionText: l10n.viewDetails,
        ),
        const SizedBox(height: 12),

        AlertCard(
          type: AlertType.news,
          title: 'Neighborhood Watch Expansion',
          timeAgo: '1 day ago',
          description:
              'New security protocols and volunteer training sessions for the Hillside neighborhood start next week.',
          primaryActionText: l10n.readFullStory,
          hasImage: true,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
