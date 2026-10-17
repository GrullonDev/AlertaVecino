import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/panic/data/panic_service.dart';
import 'package:neighbour_alert/features/panic/pages/panic_type_selection_page.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class PanicActivePage extends StatefulWidget {
  const PanicActivePage({
    super.key,
    required this.panicType,
    required this.typeName,
    required this.typeColor,
    required this.typeIcon,
    required this.alertId,
    required this.initialStatus,
  });

  final PanicType panicType;
  final String typeName;
  final Color typeColor;
  final IconData typeIcon;
  final String alertId;
  final String initialStatus;

  @override
  State<PanicActivePage> createState() => _PanicActivePageState();
}

class _PanicActivePageState extends State<PanicActivePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flashController;
  late final Timer _elapsedTimer;
  Timer? _pollTimer;
  final _chatController = TextEditingController();
  final _chatMessages = <_ChatMsg>[];
  int _elapsedSeconds = 0;
  late String _currentStatus;
  bool _connectionLost = false;

  static const _workflowOrder = [
    'registered',
    'notified',
    'acknowledged',
    'responding',
    'resolved',
  ];

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
    _currentStatus = widget.initialStatus;

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });

    _startPolling();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final session = GetIt.I<SessionService>();
      final token = session.token;
      if (token == null) return;

      final service = PanicService(token: token);
      final status = await service.fetchStatus(widget.alertId);

      if (!mounted) return;

      if (status == null) {
        setState(() => _connectionLost = true);
        return;
      }

      setState(() {
        _connectionLost = false;
        if (status != _currentStatus) {
          _currentStatus = status;
          final l10n = AppLocalizations.of(context)!;
          _chatMessages.add(
            _ChatMsg(
              sender: 'Sistema',
              text: _statusLabel(l10n, status),
              isSystem: true,
            ),
          );
        }
      });

      if (status == 'resolved' || status == 'cancelled') {
        _pollTimer?.cancel();
      }
    });
  }

  String _statusLabel(AppLocalizations l10n, String status) => switch (status) {
        'pending' => l10n.panicStatusPending,
        'registered' => l10n.panicStatusRegistered,
        'notified' => l10n.panicStatusNotified,
        'acknowledged' => l10n.panicStatusAcknowledged,
        'responding' => l10n.panicStatusResponding,
        'resolved' => l10n.panicStatusResolved,
        'cancelled' => l10n.panicStatusCancelled,
        _ => l10n.panicStatusUnknown,
      };

  bool _isStatusReached(String target) {
    final currentIdx = _workflowOrder.indexOf(_currentStatus);
    final targetIdx = _workflowOrder.indexOf(target);
    if (currentIdx == -1 || targetIdx == -1) return false;
    return currentIdx >= targetIdx;
  }

  @override
  void dispose() {
    _flashController.dispose();
    _elapsedTimer.cancel();
    _pollTimer?.cancel();
    _chatController.dispose();
    super.dispose();
  }

  String _formatElapsed() {
    final m = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _sendChat() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _chatMessages.add(_ChatMsg(sender: 'Tú', text: text, isSystem: false));
    });
    _chatController.clear();
  }

  Future<void> _cancelAlert() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.panicCancelConfirmTitle),
        content: Text(l10n.panicCancelConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.panicCancelConfirmYes),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final panicBg = isDark ? AppColors.panicBgDark : AppColors.panicBg;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: panicBg,
        body: SafeArea(
          child: Column(
            children: [
              // Header with flash
              AnimatedBuilder(
                animation: _flashController,
                builder: (context, child) {
                  final opacity = 0.7 + (_flashController.value * 0.3);
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    color: widget.typeColor.withValues(alpha: opacity * 0.2),
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: widget.typeColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.panicActiveTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: widget.typeColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatElapsed(),
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: widget.typeColor,
                        fontWeight: FontWeight.w900,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      l10n.panicActiveElapsed,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: widget.typeColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              if (_connectionLost)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  color: cs.errorContainer,
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off, size: 16, color: cs.onErrorContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.panicConnectionLost,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Info row
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _InfoChip(
                        label: l10n.panicActiveOrigin,
                        value: l10n.houseUnit('42'),
                        icon: Icons.home_outlined,
                        cs: cs,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoChip(
                        label: l10n.panicActiveType,
                        value: widget.typeName,
                        icon: widget.typeIcon,
                        cs: cs,
                        theme: theme,
                        accentColor: widget.typeColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Status timeline — driven by real backend status
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: _StatusRow(
                  items: [
                    _StatusItem(
                      l10n.panicStatusRegistered,
                      _isStatusReached('registered'),
                    ),
                    _StatusItem(
                      l10n.panicStatusNotified,
                      _isStatusReached('notified'),
                    ),
                    _StatusItem(
                      l10n.panicStatusAcknowledged,
                      _isStatusReached('acknowledged'),
                    ),
                    _StatusItem(
                      l10n.panicStatusResponding,
                      _isStatusReached('responding'),
                    ),
                  ],
                  cs: cs,
                  theme: theme,
                ),
              ),

              const Divider(height: 1),

              // Chat section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_outlined,
                      size: 18,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.panicChatLog, style: theme.textTheme.labelLarge),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final msg = _chatMessages[index];
                    return _ChatBubble(msg: msg, cs: cs, theme: theme);
                  },
                ),
              ),

              // Chat input
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: cs.surface,
                  border: Border(top: BorderSide(color: cs.outline)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                          hintText: l10n.panicChatPlaceholder,
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendChat(),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendChat,
                      icon: Icon(Icons.send, color: cs.primary),
                    ),
                  ],
                ),
              ),

              // Cancel button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                color: cs.surface,
                child: SizedBox(
                  height: 64,
                  child: ElevatedButton.icon(
                    onPressed: _cancelAlert,
                    icon: const Icon(Icons.check_circle_outline, size: 24),
                    label: Text(
                      l10n.panicCancelAlert,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.cs,
    required this.theme,
    this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final ColorScheme cs;
  final ThemeData theme;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accentColor ?? cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.items,
    required this.cs,
    required this.theme,
  });

  final List<_StatusItem> items;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    item.done
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: item.done ? AppColors.success : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: item.done ? cs.onSurface : cs.onSurfaceVariant,
                        fontWeight:
                            item.done ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusItem {
  final String label;
  final bool done;
  const _StatusItem(this.label, this.done);
}

class _ChatMsg {
  final String sender;
  final String text;
  final bool isSystem;
  const _ChatMsg({
    required this.sender,
    required this.text,
    required this.isSystem,
  });
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.msg, required this.cs, required this.theme});

  final _ChatMsg msg;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    if (msg.isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: cs.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                msg.text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(msg.text, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}
