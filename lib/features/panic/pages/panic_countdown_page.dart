import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/panic/data/panic_service.dart';
import 'package:neighbour_alert/features/panic/pages/panic_active_page.dart';
import 'package:neighbour_alert/features/panic/pages/panic_type_selection_page.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class PanicCountdownPage extends StatefulWidget {
  const PanicCountdownPage({
    super.key,
    required this.panicType,
    required this.typeName,
    required this.typeColor,
    required this.typeIcon,
  });

  final PanicType panicType;
  final String typeName;
  final Color typeColor;
  final IconData typeIcon;

  @override
  State<PanicCountdownPage> createState() => _PanicCountdownPageState();
}

class _PanicCountdownPageState extends State<PanicCountdownPage>
    with TickerProviderStateMixin {
  late final AnimationController _countdownController;
  late final AnimationController _pulseController;
  int _secondsLeft = 3;
  bool _cancelled = false;
  bool _sending = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _countdownController.addListener(() {
      final newSeconds = 3 - (_countdownController.value * 3).floor();
      if (newSeconds != _secondsLeft && newSeconds >= 0) {
        setState(() => _secondsLeft = newSeconds);
        HapticFeedback.heavyImpact();
      }
    });

    _countdownController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_cancelled) {
        _triggerAlert();
      }
    });

    HapticFeedback.heavyImpact();
    _countdownController.forward();
  }

  Future<void> _triggerAlert() async {
    if (_sending) return;
    setState(() {
      _sending = true;
      _failed = false;
    });

    final session = GetIt.I<SessionService>();
    final token = session.token;
    if (token == null) {
      setState(() => _failed = true);
      return;
    }

    final service = PanicService(token: token);
    final emergencyType = _mapPanicType(widget.panicType);

    // TODO: use real device location
    final result = await service.trigger(
      latitude: 18.4861,
      longitude: -69.9312,
      emergencyType: emergencyType,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PanicActivePage(
            panicType: widget.panicType,
            typeName: widget.typeName,
            typeColor: widget.typeColor,
            typeIcon: widget.typeIcon,
            alertId: result.alertId!,
            initialStatus: result.status ?? 'registered',
          ),
        ),
      );
    } else {
      setState(() {
        _sending = false;
        _failed = true;
      });
    }
  }

  String _mapPanicType(PanicType type) => switch (type) {
        PanicType.medical => 'medical',
        PanicType.intruder => 'intrusion',
        PanicType.fire => 'fire',
        PanicType.other => 'other',
      };

  void _cancel() {
    _cancelled = true;
    _countdownController.stop();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _countdownController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel();
      },
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.typeIcon, size: 48, color: widget.typeColor),
                  const SizedBox(height: 8),
                  Text(
                    widget.typeName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: widget.typeColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (_failed) ...[
                    Icon(Icons.error_outline, size: 48, color: cs.error),
                    const SizedBox(height: 12),
                    Text(
                      l10n.panicTriggerFailed,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _triggerAlert,
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.panicTriggerFailedRetry),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.typeColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            launchUrl(Uri.parse('tel:911')),
                        icon: const Icon(Icons.phone),
                        label: Text(l10n.panicTriggerFailedCall),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cs.error,
                          side: BorderSide(color: cs.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ] else if (_sending) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      l10n.panicSendingAlert,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ] else ...[
                    Text(
                      l10n.panicCountdownTitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = 1.0 + (_pulseController.value * 0.08);
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.typeColor.withValues(alpha: 0.15),
                          border:
                              Border.all(color: widget.typeColor, width: 4),
                        ),
                        child: Center(
                          child: Text(
                            '$_secondsLeft',
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: widget.typeColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 56,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 4,
                      child: AnimatedBuilder(
                        animation: _countdownController,
                        builder: (context, _) {
                          return LinearProgressIndicator(
                            value: _countdownController.value,
                            backgroundColor: cs.outline,
                            color: widget.typeColor,
                            borderRadius: BorderRadius.circular(2),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 48),
                  if (!_sending)
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton.icon(
                        onPressed: _cancel,
                        icon: const Icon(Icons.close, size: 24),
                        label: Text(
                          l10n.panicCountdownCancel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.surface,
                          foregroundColor: cs.onSurface,
                          side: BorderSide(color: cs.outline, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
