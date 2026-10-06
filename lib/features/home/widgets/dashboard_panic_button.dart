import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neighbour_alert/config/app_theme.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class DashboardPanicButton extends StatefulWidget {
  const DashboardPanicButton({super.key});

  @override
  State<DashboardPanicButton> createState() => _DashboardPanicButtonState();
}

class _DashboardPanicButtonState extends State<DashboardPanicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onLongPressStart() {
    setState(() => _isPressed = true);
    HapticFeedback.heavyImpact();
  }

  void _onLongPressEnd() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final panicColor = isDark ? AppColors.panicDark : AppColors.panic;

    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = 1.0 + (_pulseController.value * 0.04);
            final glowOpacity = 0.15 + (_pulseController.value * 0.15);
            return Transform.scale(
              scale: _isPressed ? 0.95 : scale,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: panicColor.withValues(alpha: glowOpacity),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onLongPressStart: (_) => _onLongPressStart(),
            onLongPressEnd: (_) => _onLongPressEnd(),
            onLongPress: () {
              HapticFeedback.heavyImpact();
            },
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    panicColor,
                    panicColor.withValues(alpha: 0.85),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 44,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.panicButtonLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.panicButtonHint,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
