import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class UnitSelectionSheet extends StatefulWidget {
  const UnitSelectionSheet({
    super.key,
    required this.residencyName,
    required this.onConfirm,
  });

  final String residencyName;
  final VoidCallback onConfirm;

  @override
  State<UnitSelectionSheet> createState() => _UnitSelectionSheetState();
}

class _UnitSelectionSheetState extends State<UnitSelectionSheet> {
  final _formKey = GlobalKey<FormState>();

  void _handleConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.selectUnit, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '${l10n.selectUnitSubtitle} — ${widget.residencyName}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: InputDecoration(
                labelText: l10n.section,
                prefixIcon: Icon(Icons.signpost_outlined, color: cs.primary),
              ),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: l10n.unitNumber,
                prefixIcon: Icon(Icons.home_outlined, color: cs.primary),
              ),
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleConfirm,
              child: Text(l10n.confirmResidency),
            ),
          ],
        ),
      ),
    );
  }
}
