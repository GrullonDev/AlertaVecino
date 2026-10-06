import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/profile/pages/profile_layout.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.yesExit, style: TextStyle(color: cs.error)),
          ),
        ],
      ),
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
          title: Text(l10n.profile),
        ),
        body: const ProfileLayout(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 3,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, RoutePath.home);
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, RoutePath.incidentMap);
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, RoutePath.notifications);
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
