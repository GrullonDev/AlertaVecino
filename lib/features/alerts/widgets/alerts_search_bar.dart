import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class AlertsSearchBar extends StatelessWidget {
  const AlertsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: l10n.searchAlerts,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
          prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
