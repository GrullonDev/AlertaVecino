import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/alerts/widgets/alert_card.dart';
import 'package:neighbour_alert/features/alerts/widgets/alerts_filter_tabs.dart';
import 'package:neighbour_alert/features/alerts/widgets/alerts_search_bar.dart';

class AlertsLayout extends StatelessWidget {
  const AlertsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        AlertsSearchBar(),
        SizedBox(height: 16),
        AlertsFilterTabs(),
        SizedBox(height: 16),
        
        AlertCard(
          type: AlertType.urgent,
          title: 'Severe Weather Warning: Flash Flood',
          timeAgo: '2 mins ago',
          description: 'Immediate evacuation recommended for residents near the Creek Drive area. Heavy rainfall expected to continue for 4 hours.',
          primaryActionText: 'VIEW DETAILS',
          showShare: true,
        ),
        SizedBox(height: 12),
        
        AlertCard(
          type: AlertType.update,
          title: 'Main St. Road Closure Resolved',
          timeAgo: '45 mins ago',
          description: 'The maintenance work on Main St. and 5th Ave intersection is now complete. Traffic flow has returned to normal.',
          primaryActionText: 'VIEW DETAILS',
        ),
        SizedBox(height: 12),
        
        AlertCard(
          type: AlertType.general,
          title: 'Community Town Hall Meeting',
          timeAgo: '3 hours ago',
          description: 'Join us this Thursday at the Community Center to discuss the new park development project and safety initiatives.',
          primaryActionText: 'VIEW DETAILS',
        ),
        SizedBox(height: 12),
        
        AlertCard(
          type: AlertType.resolved,
          title: 'Utility Restoration: Oak District',
          timeAgo: '5 hours ago',
          description: 'Power has been successfully restored to all households in the Oak District following earlier transformer maintenance.',
          primaryActionText: 'VIEW DETAILS',
        ),
        SizedBox(height: 12),
        
        AlertCard(
          type: AlertType.news,
          title: 'Neighborhood Watch Expansion',
          timeAgo: '1 day ago',
          description: 'New security protocols and volunteer training sessions for the Hillside neighborhood start next week.',
          primaryActionText: 'READ FULL STORY',
          hasImage: true,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
