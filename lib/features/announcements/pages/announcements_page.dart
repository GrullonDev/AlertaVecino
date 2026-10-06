import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';
import 'package:neighbour_alert/features/announcements/widgets/announcement_card.dart';
import 'package:neighbour_alert/features/announcements/widgets/announcement_detail_sheet.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  AnnouncementCategory? _selectedCategory;
  late List<Announcement> _announcements;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _announcements = _buildMockData(AppLocalizations.of(context)!);
  }

  List<Announcement> _buildMockData(AppLocalizations l10n) {
    return [
      Announcement(
        id: 'a1',
        title: l10n.announcementsMock1Title,
        body: l10n.announcementsMock1Body,
        category: AnnouncementCategory.urgent,
        author: 'Administración',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 35)),
      ),
      Announcement(
        id: 'a2',
        title: l10n.announcementsMock2Title,
        body: l10n.announcementsMock2Body,
        category: AnnouncementCategory.maintenance,
        author: 'Junta Directiva',
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: true,
      ),
      Announcement(
        id: 'a3',
        title: l10n.announcementsMock3Title,
        body: l10n.announcementsMock3Body,
        category: AnnouncementCategory.info,
        author: 'Junta Directiva',
        publishedAt: DateTime.now().subtract(const Duration(hours: 18)),
      ),
      Announcement(
        id: 'a4',
        title: l10n.announcementsMock4Title,
        body: l10n.announcementsMock4Body,
        category: AnnouncementCategory.maintenance,
        author: 'Administración',
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        isRead: true,
        pdfUrl: 'https://example.com/fumigacion-info.pdf',
      ),
      Announcement(
        id: 'a5',
        title: l10n.announcementsMock5Title,
        body: l10n.announcementsMock5Body,
        category: AnnouncementCategory.info,
        author: 'Administración',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }

  List<Announcement> get _filtered {
    if (_selectedCategory == null) return _announcements;
    return _announcements
        .where((a) => a.category == _selectedCategory)
        .toList();
  }

  void _markRead(String id) {
    setState(() {
      final idx = _announcements.indexWhere((a) => a.id == id);
      if (idx >= 0) {
        _announcements[idx] = _announcements[idx].copyWith(isRead: true);
      }
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _announcements = _buildMockData(AppLocalizations.of(context)!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final filtered = _filtered;

    final categories = <(AnnouncementCategory?, String)>[
      (null, l10n.announcementsAll),
      (AnnouncementCategory.urgent, l10n.announcementsCategoryUrgent),
      (AnnouncementCategory.maintenance, l10n.announcementsCategoryMaintenance),
      (AnnouncementCategory.info, l10n.announcementsCategoryInfo),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.announcementsTitle)),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final (cat, label) in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(label),
                      selected: _selectedCategory == cat,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                      selectedColor: cs.primaryContainer,
                      showCheckmark: false,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            size: 56,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.announcementsEmpty,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.announcementsEmptyHint,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final a = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 640),
                              child: AnnouncementCard(
                                announcement: a,
                                onTap: () {
                                  _markRead(a.id);
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (_) => AnnouncementDetailSheet(
                                      announcement: a,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
