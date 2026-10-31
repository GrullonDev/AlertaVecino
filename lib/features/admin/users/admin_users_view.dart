import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/admin/data/admin_repository.dart';
import 'package:neighbour_alert/features/admin/data/admin_user.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  bool _loading = true;
  String? _error;
  List<AdminUser> _users = [];
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = sl<AdminRepository>();
      final status = _filter == 'all' ? null : _filter;
      final users = await repo.listUsers(status: status);
      if (!mounted) return;
      setState(() {
        _users = users;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _approveUser(AdminUser user) async {
    try {
      await sl<AdminRepository>().approveUser(user.id);
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _rejectUser(AdminUser user) async {
    final l10n = AppLocalizations.of(context)!;
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _RejectDialog(l10n: l10n),
    );
    if (reason == null) return;

    try {
      await sl<AdminRepository>().rejectUser(
        user.id,
        reason: reason.isEmpty ? null : reason,
      );
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _deleteUser(AdminUser user) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.adminConfirmDelete),
        content: Text('${user.displayName} (${user.email})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.adminDelete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await sl<AdminRepository>().deleteUser(user.id);
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.adminUsers,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'all', label: Text(l10n.all)),
                  ButtonSegment(
                    value: 'pending',
                    label: Text(l10n.adminStatusPending),
                  ),
                  ButtonSegment(
                    value: 'approved',
                    label: Text(l10n.adminStatusApproved),
                  ),
                  ButtonSegment(
                    value: 'rejected',
                    label: Text(l10n.adminStatusRejected),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (v) {
                  setState(() => _filter = v.first);
                  _loadUsers();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_error != null)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _loadUsers,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          )
        else if (_users.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                l10n.adminNoUsers,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: _users.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return _UserTile(
                    user: user,
                    onApprove:
                        user.isPending ? () => _approveUser(user) : null,
                    onReject: user.isPending ? () => _rejectUser(user) : null,
                    onDelete: () => _deleteUser(user),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.user,
    this.onApprove,
    this.onReject,
    required this.onDelete,
  });

  final AdminUser user;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: cs.primaryContainer,
        child: Text(
          user.displayName[0].toUpperCase(),
          style: TextStyle(color: cs.onPrimaryContainer),
        ),
      ),
      title: Text(user.displayName),
      subtitle: Text(
        [
          user.email,
          if (user.residency != null) user.residency,
          if (user.house != null) 'Casa ${user.house}',
        ].join(' · '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusChip(status: user.status, l10n: l10n),
          const SizedBox(width: 8),
          if (onApprove != null)
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              color: Colors.green,
              tooltip: l10n.adminApprove,
              onPressed: onApprove,
            ),
          if (onReject != null)
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              color: Colors.orange,
              tooltip: l10n.adminReject,
              onPressed: onReject,
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
            tooltip: l10n.adminDelete,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.l10n});

  final String status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'pending' => (l10n.adminStatusPending, Colors.orange),
      'approved' => (l10n.adminStatusApproved, Colors.green),
      'rejected' => (l10n.adminStatusRejected, Colors.red),
      _ => (status, Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RejectDialog extends StatefulWidget {
  const _RejectDialog({required this.l10n});
  final AppLocalizations l10n;

  @override
  State<_RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<_RejectDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.adminReject),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.l10n.adminRejectReason,
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(widget.l10n.adminReject),
        ),
      ],
    );
  }
}
