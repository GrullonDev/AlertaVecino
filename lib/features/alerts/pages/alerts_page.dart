import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/alerts/pages/alerts_layout.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.logoutTitle),
          content: Text(l10n.logoutMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                l10n.yesExit,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePath.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _showLogoutDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_outlined, color: cs.primary),
              const SizedBox(width: 8),
              Text(l10n.alertsHistoryTitle),
            ],
          ),
        ),
        body: const AlertsLayout(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, RoutePath.home);
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, RoutePath.incidentMap);
            } else if (index == 3) {
              Navigator.pushReplacementNamed(context, RoutePath.profile);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: l10n.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              activeIcon: const Icon(Icons.map),
              label: l10n.map,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_outlined),
              activeIcon: const Icon(Icons.notifications),
              label: l10n.alerts,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: l10n.profile,
            ),
          ],
        ),
      ),
    );
  }
}
