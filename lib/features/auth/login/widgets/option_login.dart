import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class OptionsLogin extends StatelessWidget {
  const OptionsLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.g_mobiledata, size: 32),
            label: Text(l10n.google),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.fingerprint, size: 24),
            label: Text(l10n.passkey),
          ),
        ),
      ],
    );
  }
}
