import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class LoginRememberRow extends StatefulWidget {
  const LoginRememberRow({super.key});

  @override
  State<LoginRememberRow> createState() => _LoginRememberRowState();
}

class _LoginRememberRowState extends State<LoginRememberRow> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
              activeColor: cs.primary,
            ),
            Text(
              l10n.keepSessionActive,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(l10n.forgotPassword),
        ),
      ],
    );
  }
}
