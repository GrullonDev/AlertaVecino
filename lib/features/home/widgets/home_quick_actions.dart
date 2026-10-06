import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/home/widgets/home_action_card.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickActions,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            HomeActionCard(
              title: l10n.reportIncident,
              icon: Icons.report_problem_outlined,
              color: Colors.orange,
            ),
            HomeActionCard(
              title: l10n.incidentMap,
              icon: Icons.map_outlined,
              color: Colors.blue,
            ),
            HomeActionCard(
              title: l10n.localDirectory,
              icon: Icons.contact_phone_outlined,
              color: Colors.teal,
            ),
            HomeActionCard(
              title: l10n.myReports,
              icon: Icons.history_outlined,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}
