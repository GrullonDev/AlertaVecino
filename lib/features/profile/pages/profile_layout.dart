import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_header.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_info_card.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_section.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      children: [
        const ProfileHeader(),
        const SizedBox(height: 24),
        const ProfileInfoCard(),
        const SizedBox(height: 24),

        ProfileSection(
          title: l10n.personalInformation,
          items: [
            ProfileSectionItem(
              title: l10n.email,
              subtitle: 'j.doe@example.com',
              showChevron: true,
            ),
            ProfileSectionItem(
              title: l10n.phone,
              subtitle: '+1 (555) 012-3456',
              showChevron: true,
            ),
          ],
        ),

        ProfileSection(
          title: l10n.security,
          items: [
            ProfileSectionItem(
              icon: Icons.lock_outline,
              title: l10n.changePassword,
              showChevron: true,
            ),
            ProfileSectionItem(
              icon: Icons.security_outlined,
              title: l10n.twoFactorAuth,
              trailingText: l10n.off,
              trailingTextColor: Colors.red.shade700,
              showChevron: true,
            ),
          ],
        ),

        ProfileSection(
          title: l10n.notificationSettings,
          items: [
            ProfileSectionItem(
              icon: Icons.phone_iphone_outlined,
              title: l10n.pushNotifications,
              isSwitch: true,
              switchValue: true,
            ),
            ProfileSectionItem(
              icon: Icons.mail_outline,
              title: l10n.emailNotifications,
              isSwitch: true,
              switchValue: false,
            ),
            ProfileSectionItem(
              icon: Icons.campaign_outlined,
              iconColor: Colors.red.shade700,
              title: l10n.emergencyAlerts,
              titleColor: Colors.red.shade900,
              isSwitch: true,
              switchValue: true,
              switchActiveColor: Colors.red.shade700,
              backgroundColor: Colors.red.shade50,
            ),
          ],
        ),

        ProfileSection(
          title: l10n.privacy,
          items: [
            ProfileSectionItem(
              icon: Icons.visibility_outlined,
              title: l10n.profileVisibility,
              showChevron: true,
            ),
            ProfileSectionItem(
              icon: Icons.person_off_outlined,
              title: l10n.anonymousReporting,
              trailingText: l10n.enabled,
              trailingTextColor: Colors.blue.shade700,
              showChevron: true,
            ),
          ],
        ),

        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.logout, color: Colors.red.shade700),
          label: Text(
            l10n.logOut,
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.red.shade200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
