import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 48, color: cs.primary),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: cs.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text('Jorge Martínez', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          'jorge.martinez@email.com',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            l10n.profileResidenceLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: cs.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            l10n.verifiedResident,
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
