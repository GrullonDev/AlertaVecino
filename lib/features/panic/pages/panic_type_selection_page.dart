import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/features/panic/pages/panic_countdown_page.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

enum PanicType { medical, intruder, fire, other }

class PanicTypeSelectionPage extends StatelessWidget {
  const PanicTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final types = [
      _PanicOption(
        type: PanicType.medical,
        title: l10n.panicMedical,
        subtitle: l10n.panicMedicalDesc,
        icon: Icons.local_hospital_rounded,
        color: AppColors.panic,
        darkColor: AppColors.panicDark,
      ),
      _PanicOption(
        type: PanicType.intruder,
        title: l10n.panicIntruder,
        subtitle: l10n.panicIntruderDesc,
        icon: Icons.shield_outlined,
        color: AppColors.warning,
        darkColor: AppColors.warningDark,
      ),
      _PanicOption(
        type: PanicType.fire,
        title: l10n.panicFire,
        subtitle: l10n.panicFireDesc,
        icon: Icons.local_fire_department_rounded,
        color: AppColors.caution,
        darkColor: AppColors.cautionDark,
      ),
      _PanicOption(
        type: PanicType.other,
        title: l10n.panicOther,
        subtitle: l10n.panicOtherDesc,
        icon: Icons.help_outline_rounded,
        color: AppColors.info,
        darkColor: AppColors.infoDark,
      ),
    ];

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(l10n.panicSelectType, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                l10n.panicSelectTypeSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDark = theme.brightness == Brightness.dark;
                    return ListView.separated(
                      itemCount: types.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final opt = types[index];
                        final color = isDark ? opt.darkColor : opt.color;
                        return _EmergencyCard(
                          option: opt,
                          activeColor: color,
                          cs: cs,
                          theme: theme,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PanicCountdownPage(
                                  panicType: opt.type,
                                  typeName: opt.title,
                                  typeColor: color,
                                  typeIcon: opt.icon,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanicOption {
  final PanicType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color darkColor;
  const _PanicOption({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.darkColor,
  });
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard({
    required this.option,
    required this.activeColor,
    required this.cs,
    required this.theme,
    required this.onTap,
  });

  final _PanicOption option;
  final Color activeColor;
  final ColorScheme cs;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: activeColor.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(option.icon, color: activeColor, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: activeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: activeColor),
            ],
          ),
        ),
      ),
    );
  }
}
