import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';
import 'package:neighbour_alert/features/visitors/widgets/qr_share_sheet.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class CreatePassPage extends StatefulWidget {
  const CreatePassPage({super.key});

  @override
  State<CreatePassPage> createState() => _CreatePassPageState();
}

class _CreatePassPageState extends State<CreatePassPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dpiController = TextEditingController();
  final _plateController = TextEditingController();
  VisitType _visitType = VisitType.family;
  DateTime _validFrom = DateTime.now();
  DateTime _validUntil = DateTime.now().add(const Duration(hours: 8));

  @override
  void dispose() {
    _nameController.dispose();
    _dpiController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _validFrom : _validUntil,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isFrom ? _validFrom : _validUntil),
    );
    if (time == null || !mounted) return;

    final dt = DateTime(
      picked.year,
      picked.month,
      picked.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isFrom) {
        _validFrom = dt;
      } else {
        _validUntil = dt;
      }
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final pass = VisitorPass(
      id: 'pass-${DateTime.now().millisecondsSinceEpoch}',
      visitorName: _nameController.text.trim(),
      dpi: _dpiController.text.trim().isEmpty
          ? null
          : _dpiController.text.trim(),
      plate: _plateController.text.trim().isEmpty
          ? null
          : _plateController.text.trim(),
      visitType: _visitType,
      validFrom: _validFrom,
      validUntil: _validUntil,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => QrShareSheet(pass: pass),
    ).then((_) {
      if (mounted) Navigator.pop(context, pass);
    });
  }

  String _formatDateTime(DateTime dt) {
    final d =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
    final t =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d  $t';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final visitTypes = [
      (VisitType.family, l10n.visitTypeFamily, Icons.family_restroom),
      (VisitType.delivery, l10n.visitTypeDelivery, Icons.local_shipping),
      (VisitType.service, l10n.visitTypeService, Icons.build_outlined),
      (VisitType.other, l10n.visitTypeOther, Icons.more_horiz),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createPass)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.visitorName,
                    prefixIcon: Icon(Icons.person_outline, color: cs.primary),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.fieldRequired
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dpiController,
                  decoration: InputDecoration(
                    labelText: l10n.visitorDpi,
                    prefixIcon: Icon(Icons.badge_outlined, color: cs.primary),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _plateController,
                  decoration: InputDecoration(
                    labelText: l10n.visitorPlate,
                    prefixIcon: Icon(
                      Icons.directions_car_outlined,
                      color: cs.primary,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 24),
                Text(l10n.visitType, style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (type, label, icon) in visitTypes)
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 16),
                            const SizedBox(width: 6),
                            Text(label),
                          ],
                        ),
                        selected: _visitType == type,
                        onSelected: (_) => setState(() => _visitType = type),
                        selectedColor: cs.primaryContainer,
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _DateTimeTile(
                        label: l10n.validFrom,
                        value: _formatDateTime(_validFrom),
                        icon: Icons.calendar_today,
                        cs: cs,
                        theme: theme,
                        onTap: () => _pickDate(isFrom: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateTimeTile(
                        label: l10n.validUntil,
                        value: _formatDateTime(_validUntil),
                        icon: Icons.event,
                        cs: cs,
                        theme: theme,
                        onTap: () => _pickDate(isFrom: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.qr_code, size: 22),
                    label: Text(l10n.savePass),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.cs,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final ColorScheme cs;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: cs.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(label, style: theme.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
