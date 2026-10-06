import 'package:flutter/material.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

enum AlertType { urgent, update, general, resolved, news }

class AlertCard extends StatelessWidget {
  final AlertType type;
  final String title;
  final String timeAgo;
  final String description;
  final String primaryActionText;
  final bool showShare;
  final bool hasImage;

  const AlertCard({
    super.key,
    required this.type,
    required this.title,
    required this.timeAgo,
    required this.description,
    required this.primaryActionText,
    this.showShare = false,
    this.hasImage = false,
  });

  Color _getPrimaryColor() {
    switch (type) {
      case AlertType.urgent:
        return Colors.red.shade700;
      case AlertType.update:
      case AlertType.resolved:
        return Colors.blue.shade700;
      case AlertType.general:
      case AlertType.news:
        return Colors.grey.shade800;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case AlertType.urgent:
        return Icons.warning_amber_rounded;
      case AlertType.update:
        return Icons.info_outline;
      case AlertType.general:
        return Icons.campaign_outlined;
      case AlertType.resolved:
        return Icons.check_circle_outline;
      case AlertType.news:
        return Icons.article_outlined;
    }
  }

  String _getLabel(AppLocalizations l10n) {
    switch (type) {
      case AlertType.urgent:
        return l10n.urgent;
      case AlertType.update:
        return l10n.update;
      case AlertType.general:
        return l10n.general;
      case AlertType.resolved:
        return l10n.resolved;
      case AlertType.news:
        return l10n.communityNews;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _getPrimaryColor();
    final bool isUrgent = type == AlertType.urgent;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: color, width: 4),
          top: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasImage)
            Container(
              height: 140,
              width: double.infinity,
              color: Colors.red.shade800,
              child: const Icon(
                Icons.image_outlined,
                color: Colors.white54,
                size: 64,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(_getIcon(), color: color, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _getLabel(l10n),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: isUrgent
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                primaryActionText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: color,
                                side: BorderSide(
                                  color: color.withValues(alpha: 0.5),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                primaryActionText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                    ),
                    if (showShare) ...[
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          l10n.share,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
