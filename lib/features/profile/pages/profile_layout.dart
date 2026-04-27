import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_header.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_info_card.dart';
import 'package:neighbour_alert/features/profile/widgets/profile_section.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      children: [
        const ProfileHeader(),
        const SizedBox(height: 24),
        const ProfileInfoCard(),
        const SizedBox(height: 24),
        
        ProfileSection(
          title: 'PERSONAL INFORMATION',
          items: [
            ProfileSectionItem(
              title: 'Email',
              subtitle: 'j.doe@example.com',
              showChevron: true,
            ),
            ProfileSectionItem(
              title: 'Phone',
              subtitle: '+1 (555) 012-3456',
              showChevron: true,
            ),
          ],
        ),
        
        ProfileSection(
          title: 'SECURITY',
          items: [
            ProfileSectionItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              showChevron: true,
            ),
            ProfileSectionItem(
              icon: Icons.security_outlined,
              title: 'Two-Factor Authentication',
              trailingText: 'Off',
              trailingTextColor: Colors.red.shade700,
              showChevron: true,
            ),
          ],
        ),
        
        ProfileSection(
          title: 'NOTIFICATION SETTINGS',
          items: [
            ProfileSectionItem(
              icon: Icons.phone_iphone_outlined,
              title: 'Push Notifications',
              isSwitch: true,
              switchValue: true,
            ),
            ProfileSectionItem(
              icon: Icons.mail_outline,
              title: 'Email Notifications',
              isSwitch: true,
              switchValue: false,
            ),
            ProfileSectionItem(
              icon: Icons.campaign_outlined,
              iconColor: Colors.red.shade700,
              title: 'Emergency Alerts',
              titleColor: Colors.red.shade900,
              isSwitch: true,
              switchValue: true,
              switchActiveColor: Colors.red.shade700,
              backgroundColor: Colors.red.shade50,
            ),
          ],
        ),
        
        ProfileSection(
          title: 'PRIVACY',
          items: [
            ProfileSectionItem(
              icon: Icons.visibility_outlined,
              title: 'Profile Visibility',
              showChevron: true,
            ),
            ProfileSectionItem(
              icon: Icons.person_off_outlined,
              title: 'Anonymous Reporting',
              trailingText: 'Enabled',
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
            'Log Out',
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
