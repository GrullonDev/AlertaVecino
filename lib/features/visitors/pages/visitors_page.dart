import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/features/visitors/data/visitors_repository.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';
import 'package:neighbour_alert/features/visitors/pages/create_pass_page.dart';
import 'package:neighbour_alert/features/visitors/widgets/visitor_history_tab.dart';
import 'package:neighbour_alert/features/visitors/widgets/visitor_passes_tab.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';

class VisitorsPage extends StatefulWidget {
  const VisitorsPage({super.key});

  @override
  State<VisitorsPage> createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {
  final VisitorsRepository _repository = sl<VisitorsRepository>();

  List<VisitorPass> _passes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPasses();
  }

  Future<void> _loadPasses() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final passes = await _repository.listPasses();
      if (!mounted) return;
      setState(() {
        _passes = passes;
        _loading = false;
      });
    } on ApiException catch (e) {
      dev.log('[visitors] $e');
      if (!mounted) return;
      setState(() {
        _error = e.serverMessage ?? 'Error al cargar los pases';
        _loading = false;
      });
    } catch (e) {
      dev.log('[visitors] unexpected: $e');
      if (!mounted) return;
      setState(() {
        _error = 'Error inesperado';
        _loading = false;
      });
    }
  }

  List<VisitorPass> get _activePasses =>
      _passes.where((p) => p.status != VisitorStatus.entered &&
          p.status != VisitorStatus.expired).toList();

  List<VisitorPass> get _history =>
      _passes.where((p) => p.status == VisitorStatus.entered ||
          p.status == VisitorStatus.expired).toList();

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
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: cs.error),
                        const SizedBox(height: 12),
                        Text(_error!,
                            style: TextStyle(color: cs.onSurfaceVariant)),
                        const SizedBox(height: 12),
                        FilledButton.tonal(
                          onPressed: _loadPasses,
                          child: Text(l10n.announcementsRetry),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadPasses,
                    child: TabBarView(
                      children: [
                        VisitorPassesTab(passes: _activePasses),
                        VisitorHistoryTab(history: _history),
                      ],
                    ),
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
