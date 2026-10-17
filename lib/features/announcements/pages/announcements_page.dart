import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/announcements/data/repository.dart';
import 'package:neighbour_alert/features/announcements/logic/announcements_logic.dart';
import 'package:neighbour_alert/features/announcements/pages/announcements_layout.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnnouncementsLogic(
        repository: GetIt.instance<AnnouncementsRepository>(),
        session: GetIt.instance<SessionService>(),
      )..load(),
      child: const AnnouncementsLayout(),
    );
  }
}
