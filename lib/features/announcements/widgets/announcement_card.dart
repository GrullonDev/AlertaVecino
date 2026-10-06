import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onTap,
  });

  final Announcement announcement;
  final VoidCallback onTap;

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

  String _timeAgo(AppLocalizations l10n, DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return l10n.announcementsTimeAgo(
        l10n.announcementsMinutes(diff.inMinutes),
      );
    }
    if (diff.inHours < 24) {
      return l10n.announcementsTimeAgo(l10n.announcementsHours(diff.inHours));
    }
    return l10n.announcementsTimeAgo(l10n.announcementsDays(diff.inDays));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final (color, bgColor, label, icon) = _categoryMeta(l10n, isDark);

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: announcement.isRead
                  ? cs.outline
                  : color.withValues(alpha: 0.4),
              width: announcement.isRead ? 1 : 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 14, color: color),
                        const SizedBox(width: 4),
                        Text(
                          label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!announcement.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary,
                      ),
                    ),
                  Text(
                    _timeAgo(l10n, announcement.publishedAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                announcement.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: announcement.isRead
                      ? FontWeight.w600
                      : FontWeight.w800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                announcement.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      l10n.announcementsPostedBy(announcement.author),
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (announcement.pdfUrl != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.attach_file,
                      size: 14,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
