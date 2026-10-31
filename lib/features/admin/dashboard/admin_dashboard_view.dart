import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/admin/data/admin_repository.dart';
import 'package:neighbour_alert/features/admin/data/admin_user.dart';
import 'package:neighbour_alert/features/alerts/data/alerts_datasource.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  bool _loading = true;
  int _totalUsers = 0;
  int _pendingCount = 0;
  int _activeAlerts = 0;
  List<AdminUser> _recentPending = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    try {
      final repo = sl<AdminRepository>();
      final alertsDs = sl<AlertsDataSource>();

      final results = await Future.wait([
        repo.listUsers(),
        repo.listUsers(status: 'pending'),
        alertsDs.fetchActive(),
      ]);

      final allUsers = results[0] as List<AdminUser>;
      final pending = results[1] as List<AdminUser>;
      final alerts = results[2] as List<dynamic>;

      if (!mounted) return;
      setState(() {
        _totalUsers = allUsers.length;
        _pendingCount = pending.length;
        _activeAlerts = alerts.length;
        _recentPending = pending.take(5).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadStats,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.adminDashboard,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                icon: Icons.people,
                label: l10n.adminTotalUsers,
                value: '$_totalUsers',
                color: cs.primary,
              ),
              _StatCard(
                icon: Icons.pending_actions,
                label: l10n.adminPendingApprovals,
                value: '$_pendingCount',
                color: Colors.orange,
              ),
              _StatCard(
                icon: Icons.warning_amber,
                label: l10n.adminActiveAlerts,
                value: '$_activeAlerts',
                color: Colors.red,
              ),
            ],
          ),
          if (_recentPending.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(
              l10n.adminRecentPending,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  for (final user in _recentPending)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: cs.primaryContainer,
                        child: Text(
                          user.displayName[0].toUpperCase(),
                          style: TextStyle(color: cs.onPrimaryContainer),
                        ),
                      ),
                      title: Text(user.displayName),
                      subtitle: Text(user.email),
                      trailing: Chip(
                        label: Text(l10n.adminStatusPending),
                        backgroundColor: Colors.orange.shade50,
                        labelStyle: const TextStyle(color: Colors.orange),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
