import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.hourglass_top_rounded,
                      size: 40,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.pendingApprovalTitle,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.pendingApprovalSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.pendingApprovalMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildTimeline(context, l10n, cs, theme),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: cs.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.pendingApprovalHelp,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.support_agent),
                    label: Text(l10n.contactAdmin),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutePath.login,
                      (route) => false,
                    ),
                    child: Text(l10n.backToLogin),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme cs,
    ThemeData theme,
  ) {
    final steps = [
      _TimelineStep(
        title: l10n.pendingApprovalStep1,
        status: l10n.pendingApprovalCompleted,
        isCompleted: true,
        isActive: false,
      ),
      _TimelineStep(
        title: l10n.pendingApprovalStep2,
        status: l10n.pendingApprovalInProgress,
        isCompleted: false,
        isActive: true,
      ),
      _TimelineStep(
        title: l10n.pendingApprovalStep3,
        status: l10n.pendingApprovalPending,
        isCompleted: false,
        isActive: false,
      ),
      _TimelineStep(
        title: l10n.pendingApprovalStep4,
        status: l10n.pendingApprovalPending,
        isCompleted: false,
        isActive: false,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            _buildTimelineItem(
              steps[i],
              cs,
              theme,
              isLast: i == steps.length - 1,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    _TimelineStep step,
    ColorScheme cs,
    ThemeData theme, {
    required bool isLast,
  }) {
    final Color dotColor;
    final IconData dotIcon;

    if (step.isCompleted) {
      dotColor = const Color(0xFF2E7D32);
      dotIcon = Icons.check_circle;
    } else if (step.isActive) {
      dotColor = cs.primary;
      dotIcon = Icons.radio_button_checked;
    } else {
      dotColor = cs.onSurfaceVariant;
      dotIcon = Icons.radio_button_unchecked;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(dotIcon, color: dotColor, size: 24),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: step.isCompleted
                        ? const Color(0xFF2E7D32)
                        : cs.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: step.isActive || step.isCompleted
                          ? cs.onSurface
                          : cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: step.isCompleted
                          ? const Color(0xFF2E7D32)
                          : step.isActive
                          ? cs.primary
                          : cs.onSurfaceVariant,
                      fontWeight: step.isActive
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep {
  final String title;
  final String status;
  final bool isCompleted;
  final bool isActive;

  const _TimelineStep({
    required this.title,
    required this.status,
    required this.isCompleted,
    required this.isActive,
  });
}
