import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/register/logic/register_logic.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';
import 'package:neighbour_alert/features/auth/select_residency/data/residency_options.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/residency_picker.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';
import 'package:neighbour_alert/utils/widgets/error_banner.dart';
import 'package:provider/provider.dart';

class SelectResidencyLayout extends StatefulWidget {
  const SelectResidencyLayout({super.key, required this.draft});

  final RegistrationDraft draft;

  @override
  State<SelectResidencyLayout> createState() => _SelectResidencyLayoutState();
}

class _SelectResidencyLayoutState extends State<SelectResidencyLayout> {
  Future<void> _submit(String residency, String section, String unit) async {
    final logic = context.read<RegisterLogic>();
    final l10n = AppLocalizations.of(context)!;
    final house = [section, unit].where((s) => s.isNotEmpty).join(' ');

    final ok = await logic.register(
      draft: widget.draft,
      l10n: l10n,
      residency: residency,
      house: house,
    );

    if (ok && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePath.pendingApproval,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Consumer<RegisterLogic>(
      builder: (context, logic, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.apartment, size: 40, color: cs.primary),
                const SizedBox(height: 12),
                Text(
                  l10n.selectResidency,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.selectResidencySubtitle,
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
                    onConfirm: _submit,
                  ),
          ),
        ],
      ),
    );
  }
}
