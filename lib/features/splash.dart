import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/profile/data/profile_repository.dart';
import 'package:neighbour_alert/utils/injection_container.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final session = sl<SessionService>();
    final restored = await session.tryRestoreSession();

    if (kIsWeb) {
      if (!restored || session.user?.role != 'admin') {
        _navigate(RoutePath.adminLogin);
        return;
      }
      try {
        final repo = sl<ProfileRepository>();
        final user = await repo.fetchMe();
        await session.updateUser(user);
        _navigate(RoutePath.adminDashboard);
      } catch (_) {
        _navigate(RoutePath.adminLogin);
      }
      return;
    }

    if (!restored) {
      _navigate(RoutePath.login);
      return;
    }

    try {
      final repo = sl<ProfileRepository>();
      final user = await repo.fetchMe();
      await session.updateUser(user);

      if (!user.hasCompleteProfile) {
        _navigate(RoutePath.login);
        return;
      }

      _navigate(RoutePath.home);
    } catch (_) {
      _navigate(RoutePath.login);
    }
  }

  void _navigate(String route) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, size: 64, color: cs.primary),
            const SizedBox(height: 16),
            Text(
              'AlertaVecino',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
