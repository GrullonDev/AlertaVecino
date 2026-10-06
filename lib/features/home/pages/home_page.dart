import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/home/pages/home_layout.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                l10n.yesExit,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
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
          title: Text(l10n.appTitle),
          actions: [
            IconButton(
              icon: Badge(
                smallSize: 8,
                backgroundColor: cs.error,
                child: Icon(Icons.notifications_outlined, color: cs.onSurface),
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, RoutePath.notifications),
            ),
            IconButton(
              icon: Icon(Icons.account_circle_outlined, color: cs.onSurface),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, RoutePath.profile),
            ),
          ],
        ),
        body: const HomeLayout(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushReplacementNamed(context, RoutePath.incidentMap);
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, RoutePath.notifications);
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
