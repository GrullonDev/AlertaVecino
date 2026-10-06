import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class AnnouncementDetailSheet extends StatelessWidget {
  const AnnouncementDetailSheet({super.key, required this.announcement});

  final Announcement announcement;

  (Color, Color, String, IconData) _categoryMeta(
    AppLocalizations l10n,
    bool isDark,
  ) {
    return switch (announcement.category) {
      AnnouncementCategory.urgent => (
        isDark ? AppColors.panicDark : AppColors.panic,
        isDark ? AppColors.panicBgDark : AppColors.panicBg,
        l10n.announcementsCategoryUrgent,
        Icons.warning_amber_rounded,
      ),
      AnnouncementCategory.maintenance => (
        isDark ? AppColors.warningDark : AppColors.warning,
        isDark ? AppColors.warningBgDark : AppColors.warningBg,
        l10n.announcementsCategoryMaintenance,
        Icons.build_outlined,
      ),
      AnnouncementCategory.info => (
        isDark ? AppColors.infoDark : AppColors.info,
        isDark ? AppColors.infoBgDark : AppColors.infoBg,
        l10n.announcementsCategoryInfo,
        Icons.info_outline,
      ),
    };
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final (color, bgColor, label, icon) = _categoryMeta(l10n, isDark);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 12, 0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Share.share(
                        l10n.announcementsShareText(
                          'Residencial La Esperanza',
                          announcement.title,
                          announcement.body,
                        ),
                      );
                    },
                    icon: Icon(Icons.share, color: cs.onSurfaceVariant),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon, size: 16, color: color),
                              const SizedBox(width: 6),
                              Text(
                                label,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          announcement.title,
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 16,
                              color: cs.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              announcement.author,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: cs.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(announcement.publishedAt),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1),
                        const SizedBox(height: 24),
                        Text(
                          announcement.body,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),
                        if (announcement.pdfUrl != null) ...[
                          const SizedBox(height: 24),
                          Text(
                            l10n.announcementsAttachments,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Material(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: cs.error.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.picture_as_pdf,
                                        color: cs.error,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.announcementsViewPdf,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(fontSize: 14),
                                          ),
                                          Text(
                                            'PDF',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.open_in_new,
                                      size: 18,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
