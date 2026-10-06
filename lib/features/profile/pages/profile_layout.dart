import 'package:flutter/material.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_header.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_info_card.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_section.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class ProfileLayout extends StatefulWidget {
  const ProfileLayout({super.key});

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  bool _visitorAlerts = true;
  bool _panicAlerts = true;
  bool _adminNotices = true;
  bool _darkMode = false;

  void _showLogoutConfirm() async {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    final confirmed = await showDialog<bool>(
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

    if (confirmed == true && mounted) {
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
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final panicColor = isDark ? AppColors.panicDark : AppColors.panic;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          child: Column(
            children: [
              const ProfileHeader(),
              const SizedBox(height: 24),
              const ProfileInfoCard(),
              const SizedBox(height: 24),

              ProfileSection(
                title: l10n.profileAccountSection,
                items: [
                  ProfileSectionItem(
                    icon: Icons.home_outlined,
                    title: l10n.profileResidenceDetails,
                    showChevron: true,
                    onTap: () {},
                  ),
                  ProfileSectionItem(
                    icon: Icons.swap_horiz,
                    title: l10n.profileRequestAddressChange,
                    showChevron: true,
                    onTap: () {},
                  ),
                  ProfileSectionItem(
                    icon: Icons.group_outlined,
                    title: l10n.profileHouseholdMembers,
                    trailingText: '3',
                    showChevron: true,
                    onTap: () {},
                  ),
                ],
              ),

              ProfileSection(
                title: l10n.profilePersonalInfo,
                items: [
                  ProfileSectionItem(
                    icon: Icons.email_outlined,
                    title: l10n.email,
                    subtitle: 'jorge.martinez@email.com',
                    showChevron: true,
                    onTap: () {},
                  ),
                  ProfileSectionItem(
                    icon: Icons.phone_outlined,
                    title: l10n.phone,
                    subtitle: '+502 5555 1234',
                    showChevron: true,
                    onTap: () {},
                  ),
                ],
              ),

              ProfileSection(
                title: l10n.profileNotificationsSection,
                items: [
                  ProfileSectionItem(
                    icon: Icons.door_front_door_outlined,
                    title: l10n.profileNotifVisitors,
                    isSwitch: true,
                    switchValue: _visitorAlerts,
                    onSwitchChanged: (v) => setState(() => _visitorAlerts = v),
                  ),
                  ProfileSectionItem(
                    icon: Icons.campaign_outlined,
                    title: l10n.profileNotifPanic,
                    isSwitch: true,
                    switchValue: _panicAlerts,
                    accentColor: panicColor,
                    onSwitchChanged: (v) => setState(() => _panicAlerts = v),
                  ),
                  ProfileSectionItem(
                    icon: Icons.notifications_outlined,
                    title: l10n.profileNotifAdmin,
                    isSwitch: true,
                    switchValue: _adminNotices,
                    onSwitchChanged: (v) => setState(() => _adminNotices = v),
                  ),
                  ProfileSectionItem(
                    icon: Icons.dark_mode_outlined,
                    title: l10n.profileDarkMode,
                    trailingText: _darkMode
                        ? l10n.profileDarkModeOn
                        : l10n.profileDarkModeAuto,
                    isSwitch: true,
                    switchValue: _darkMode,
                    onSwitchChanged: (v) => setState(() => _darkMode = v),
                  ),
                ],
              ),

              ProfileSection(
                title: l10n.profileSecuritySection,
                items: [
                  ProfileSectionItem(
                    icon: Icons.lock_outline,
                    title: l10n.changePassword,
                    showChevron: true,
                    onTap: () {},
                  ),
                  ProfileSectionItem(
                    icon: Icons.security_outlined,
                    title: l10n.twoFactorAuth,
                    trailingText: l10n.off,
                    showChevron: true,
                    onTap: () {},
                  ),
                  ProfileSectionItem(
                    icon: Icons.devices_outlined,
                    title: l10n.profileTrustedDevices,
                    trailingText: '2',
                    showChevron: true,
                    onTap: () {},
                  ),
                ],
              ),

              ProfileSection(
                title: l10n.profileLegalSection,
                items: [
                  ProfileSectionItem(
                    icon: Icons.description_outlined,
                    title: l10n.profileTerms,
                    showChevron: true,
                    onTap: () {},
                  ),
                  ProfileSectionItem(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.profilePrivacyPolicy,
                    showChevron: true,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _showLogoutConfirm,
                  icon: Icon(Icons.logout, color: cs.error),
                  label: Text(
                    l10n.logOut,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.error.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.profileVersion, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
