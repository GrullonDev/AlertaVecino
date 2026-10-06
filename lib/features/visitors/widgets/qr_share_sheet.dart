import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class QrShareSheet extends StatelessWidget {
  const QrShareSheet({super.key, required this.pass});

  final VisitorPass pass;

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final qrData = 'alertavecino://pass/${pass.id}';
    final shareText = l10n.qrShareMessage(
      'Residencial La Esperanza',
      l10n.houseUnit('42'),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Text(l10n.qrPassTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            pass.visitorName,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
                maxHeight: MediaQuery.of(context).size.width * 0.5,
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Color(0xFF1B3A5C),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color(0xFF1B3A5C),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.validFrom, style: theme.textTheme.labelMedium),
                      Text(
                        _formatTime(pass.validFrom),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: cs.outline),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.validUntil,
                          style: theme.textTheme.labelMedium,
                        ),
                        Text(
                          _formatTime(pass.validUntil),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Share.share(shareText);
              },
              icon: const Icon(Icons.share, size: 20),
              label: Text(l10n.sharePass),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                Share.share(shareText);
              },
              icon: const Icon(Icons.chat, size: 20),
              label: Text(l10n.shareViaWhatsapp),
            ),
          ),
        ],
      ),
    );
  }
}
