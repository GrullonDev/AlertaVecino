import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';
import 'package:neighbour_alert/features/visitors/pages/create_pass_page.dart';
import 'package:neighbour_alert/features/visitors/widgets/visitor_history_tab.dart';
import 'package:neighbour_alert/features/visitors/widgets/visitor_passes_tab.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';

class VisitorsPage extends StatefulWidget {
  const VisitorsPage({super.key});

  @override
  State<VisitorsPage> createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {
  final List<VisitorPass> _passes = [
    VisitorPass(
      id: 'pass-001',
      visitorName: 'María López',
      plate: 'P-123ABC',
      visitType: VisitType.family,
      validFrom: DateTime.now(),
      validUntil: DateTime.now().add(const Duration(hours: 8)),
      status: VisitorStatus.expected,
    ),
    VisitorPass(
      id: 'pass-002',
      visitorName: 'Carlos Pérez',
      visitType: VisitType.delivery,
      validFrom: DateTime.now().subtract(const Duration(hours: 1)),
      validUntil: DateTime.now().add(const Duration(hours: 2)),
      status: VisitorStatus.atGate,
    ),
  ];

  final List<VisitorPass> _history = [
    VisitorPass(
      id: 'hist-001',
      visitorName: 'Ana García',
      plate: 'C-456DEF',
      visitType: VisitType.family,
      validFrom: DateTime.now().subtract(const Duration(hours: 3)),
      validUntil: DateTime.now().subtract(const Duration(hours: 1)),
      status: VisitorStatus.entered,
      entryTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
    ),
    VisitorPass(
      id: 'hist-002',
      visitorName: 'Delivery Express',
      visitType: VisitType.delivery,
      validFrom: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      validUntil: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      status: VisitorStatus.entered,
      entryTime: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    ),
    VisitorPass(
      id: 'hist-003',
      visitorName: 'Roberto Méndez',
      plate: 'M-789GHI',
      visitType: VisitType.service,
      validFrom: DateTime.now().subtract(const Duration(days: 2)),
      validUntil: DateTime.now()
          .subtract(const Duration(days: 2))
          .add(const Duration(hours: 4)),
      status: VisitorStatus.expired,
    ),
  ];

  void _onPassCreated(VisitorPass pass) {
    setState(() => _passes.insert(0, pass));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.visitorsTitle),
          bottom: TabBar(
            indicatorColor: cs.primary,
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurfaceVariant,
            tabs: [
              Tab(text: l10n.visitorsPasses),
              Tab(text: l10n.visitorsHistory),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VisitorPassesTab(passes: _passes),
            VisitorHistoryTab(history: _history),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final pass = await Navigator.push<VisitorPass>(
              context,
              MaterialPageRoute(builder: (_) => const CreatePassPage()),
            );
            if (pass != null) _onPassCreated(pass);
          },
          icon: const Icon(Icons.add),
          label: Text(l10n.createPass),
        ),
      ),
    );
  }
}
