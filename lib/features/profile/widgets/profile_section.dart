import 'package:flutter/material.dart';

class ProfileSectionItem {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final bool showChevron;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;
  final Color? accentColor;

  ProfileSectionItem({
    this.icon,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.showChevron = false,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
    this.accentColor,
  });
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.title, required this.items});

  final String title;
  final List<ProfileSectionItem> items;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 0.8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outline),
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;
                final accent = item.accentColor;

                return Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: item.onTap,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(index == 0 ? 12 : 0),
                          bottom: Radius.circular(isLast ? 12 : 0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              if (item.icon != null) ...[
                                Icon(
                                  item.icon,
                                  color: accent ?? cs.onSurfaceVariant,
                                  size: 22,
                                ),
                                const SizedBox(width: 14),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontSize: item.subtitle != null
                                                ? 13
                                                : 15,
                                            fontWeight: item.subtitle != null
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                    ),
                                    if (item.subtitle != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle!,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (item.trailingText != null)
                                Text(
                                  item.trailingText!,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: accent ?? cs.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              if (item.isSwitch)
                                Switch(
                                  value: item.switchValue,
                                  onChanged: item.onSwitchChanged,
                                  activeTrackColor: accent ?? cs.primary,
                                ),
                              if (item.showChevron)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: cs.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: cs.outline,
                        indent: item.icon != null ? 52 : 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
