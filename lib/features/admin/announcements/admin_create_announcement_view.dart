import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/admin/data/admin_repository.dart';
import 'package:neighbour_alert/features/announcements/data/repository.dart'
    as announcements;
import 'package:neighbour_alert/features/announcements/models/announcement.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';

class AdminCreateAnnouncementView extends StatefulWidget {
  const AdminCreateAnnouncementView({super.key});

  @override
  State<AdminCreateAnnouncementView> createState() =>
      _AdminCreateAnnouncementViewState();
}

class _AdminCreateAnnouncementViewState
    extends State<AdminCreateAnnouncementView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _category = 'info';
  bool _sending = false;

  bool _loadingList = true;
  List<Announcement> _announcements = [];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() => _loadingList = true);
    try {
      final repo = sl<announcements.AnnouncementsRepository>();
      final items = await repo.list();
      if (!mounted) return;
      setState(() {
        _announcements = items;
        _loadingList = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingList = false);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = context.read<SessionService>().user;
    if (user == null) return;

    setState(() => _sending = true);

    try {
      await sl<AdminRepository>().createAnnouncement(
        authorId: user.id,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        category: _category,
      );

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adminAnnouncementCreated)),
      );

      _titleController.clear();
      _bodyController.clear();
      setState(() {
        _category = 'info';
        _sending = false;
      });
      _loadAnnouncements();
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.adminCreateAnnouncement,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.adminAnnouncementTitle,
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bodyController,
                    decoration: InputDecoration(
                      labelText: l10n.adminAnnouncementBody,
                      prefixIcon: const Icon(Icons.article_outlined),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: InputDecoration(
                      labelText: l10n.adminAnnouncementCategory,
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'info',
                        child: Text(l10n.announcementsCategoryInfo),
                      ),
                      DropdownMenuItem(
                        value: 'maintenance',
                        child: Text(l10n.announcementsCategoryMaintenance),
                      ),
                      DropdownMenuItem(
                        value: 'urgent',
                        child: Text(l10n.announcementsCategoryUrgent),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _category = v);
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _sending ? null : _submit,
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    label: Text(l10n.adminPublish),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          l10n.adminRecentAnnouncements,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (_loadingList)
          const Center(child: CircularProgressIndicator())
        else if (_announcements.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                l10n.announcementsEmpty,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...List.generate(_announcements.length, (i) {
            final item = _announcements[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  switch (item.category) {
                    AnnouncementCategory.urgent => Icons.priority_high,
                    AnnouncementCategory.maintenance => Icons.build,
                    AnnouncementCategory.info => Icons.info_outline,
                  },
                  color: switch (item.category) {
                    AnnouncementCategory.urgent => Colors.red,
                    AnnouncementCategory.maintenance => Colors.orange,
                    AnnouncementCategory.info => cs.primary,
                  },
                ),
                title: Text(item.title),
                subtitle: Text(
                  item.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
      ],
    );
  }
}
