import 'package:flutter/material.dart';

class ProfileSectionItem {
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final String? trailingText;
  final Color? trailingTextColor;
  final bool showChevron;
  final bool isSwitch;
  final bool switchValue;
  final Color? switchActiveColor;
  final Color? backgroundColor;

  ProfileSectionItem({
    this.icon,
    this.iconColor,
    required this.title,
    this.titleColor,
    this.subtitle,
    this.trailingText,
    this.trailingTextColor,
    this.showChevron = false,
    this.isSwitch = false,
    this.switchValue = false,
    this.switchActiveColor,
    this.backgroundColor,
  });
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<ProfileSectionItem> items;

  const ProfileSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final int index = entry.key;
                final ProfileSectionItem item = entry.value;
                final bool isLast = index == items.length - 1;

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: item.backgroundColor ?? Colors.transparent,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(index == 0 ? 12 : 0),
                          bottom: Radius.circular(isLast ? 12 : 0),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        leading: item.icon != null
                            ? Icon(item.icon, color: item.iconColor ?? Colors.grey.shade700, size: 22)
                            : null,
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: item.subtitle != null ? 12 : 14,
                            fontWeight: item.subtitle != null ? FontWeight.bold : FontWeight.w500,
                            color: item.titleColor ?? Colors.black87,
                          ),
                        ),
                        subtitle: item.subtitle != null
                            ? Text(
                                item.subtitle!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.trailingText != null)
                              Text(
                                item.trailingText!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: item.trailingTextColor ?? Colors.grey.shade700,
                                ),
                              ),
                            if (item.showChevron) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
                            ],
                            if (item.isSwitch)
                              Switch(
                                value: item.switchValue,
                                onChanged: (val) {},
                                activeColor: Colors.white,
                                activeTrackColor: item.switchActiveColor ?? Colors.blue.shade700,
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey.shade300,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(height: 1, thickness: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
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
