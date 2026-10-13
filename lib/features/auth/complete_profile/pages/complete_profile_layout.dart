import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/complete_profile/logic/complete_profile_logic.dart';
import 'package:neighbour_alert/features/auth/complete_profile/model/complete_profile_args.dart';
import 'package:neighbour_alert/features/auth/select_residency/data/residency_options.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/residency_picker.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';
import 'package:neighbour_alert/utils/widgets/error_banner.dart';
import 'package:provider/provider.dart';

class CompleteProfileLayout extends StatelessWidget {
  const CompleteProfileLayout({super.key, required this.args});

  final ProfileCompletionArgs args;

  Future<void> _submit(
    BuildContext context,
    String residency,
    String section,
    String unit,
  ) async {
    final logic = context.read<CompleteProfileLogic>();
    final l10n = AppLocalizations.of(context)!;
    final house = [section, unit].where((s) => s.isNotEmpty).join(' ');

    final ok = await logic.submit(
      token: args.token,
      userId: args.userId,
      residency: residency,
      house: house,
      l10n: l10n,
    );

    if (ok && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePath.home,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Consumer<CompleteProfileLogic>(
      builder: (context, logic, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.assignment_ind_outlined, size: 40, color: cs.primary),
                const SizedBox(height: 12),
                Text(
                  l10n.completeProfileTitle,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.completeProfileSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                if (logic.hasError) ...[
                  const SizedBox(height: 16),
                  ErrorBanner(message: logic.errorMessage!),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: logic.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ResidencyPicker(
                    residencies: mockResidencies,
                    onConfirm: (residency, section, unit) =>
                        _submit(context, residency, section, unit),
                  ),
          ),
        ],
      ),
    );
  }
}
