import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/admin/alerts/admin_alerts_view.dart';
import 'package:neighbour_alert/features/admin/announcements/admin_create_announcement_view.dart';
import 'package:neighbour_alert/features/admin/dashboard/admin_dashboard_view.dart';
import 'package:neighbour_alert/features/admin/users/admin_users_view.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  static const _views = <Widget>[
    AdminDashboardView(),
    AdminUsersView(),
    AdminCreateAnnouncementView(),
    AdminAlertsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final user = context.watch<SessionService>().user;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            extended: MediaQuery.sizeOf(context).width > 900,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Icon(Icons.shield_outlined, size: 32, color: cs.primary),
                  const SizedBox(height: 4),
                  Text(
                    'AlertaVecino',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (user != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: cs.primaryContainer,
                            child: Text(
                              user.displayName[0].toUpperCase(),
                              style: TextStyle(
                                color: cs.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        tooltip: l10n.logOut,
                        onPressed: () => _logout(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: Text(l10n.adminDashboard),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.people_outlined),
                selectedIcon: const Icon(Icons.people),
                label: Text(l10n.adminUsers),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.campaign_outlined),
                selectedIcon: const Icon(Icons.campaign),
                label: Text(l10n.announcements),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.warning_amber_outlined),
                selectedIcon: const Icon(Icons.warning_amber),
                label: Text(l10n.alerts),
              ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: _views[_selectedIndex]),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.yesExit),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await sl<SessionService>().clearSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RoutePath.adminLogin);
  }
}
