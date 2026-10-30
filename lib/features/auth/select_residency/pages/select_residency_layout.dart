import 'package:flutter/material.dart';
import 'package:neighbour_alert/core/api/api_exception.dart';
import 'package:neighbour_alert/features/auth/register/logic/register_logic.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';
import 'package:neighbour_alert/features/auth/select_residency/data/residency_datasource.dart';
import 'package:neighbour_alert/features/auth/select_residency/data/residency_repository.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/residency_list.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/residency_picker.dart';
import 'package:neighbour_alert/l10n/app_localizations.dart';
import 'package:neighbour_alert/utils/injection_container.dart';
import 'package:neighbour_alert/utils/router/route_path.dart';
import 'package:neighbour_alert/utils/widgets/error_banner.dart';
import 'package:provider/provider.dart';

class SelectResidencyLayout extends StatefulWidget {
  const SelectResidencyLayout({super.key, required this.draft});

  final RegistrationDraft draft;

  @override
  State<SelectResidencyLayout> createState() => _SelectResidencyLayoutState();
}

class _SelectResidencyLayoutState extends State<SelectResidencyLayout> {
  List<ResidencyItem>? _residencies;
  bool _loadingList = true;
  String? _loadError;

  static const _icons = [
    Icons.location_city,
    Icons.apartment,
    Icons.home_work,
    Icons.villa,
    Icons.domain,
    Icons.holiday_village,
    Icons.corporate_fare,
    Icons.house,
  ];

  @override
  void initState() {
    super.initState();
    _loadResidencies();
  }

  Future<void> _loadResidencies() async {
    setState(() {
      _loadingList = true;
      _loadError = null;
    });

    try {
      final repo = sl<ResidencyRepository>();
      final dtos = await repo.listResidencies();
      if (!mounted) return;
      setState(() {
        _residencies = [
          for (var i = 0; i < dtos.length; i++)
            _toItem(dtos[i], i),
        ];
        _loadingList = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.serverMessage ?? 'Error al cargar residencias';
        _loadingList = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Error de conexión';
        _loadingList = false;
      });
    }
  }

  static ResidencyItem _toItem(ResidencyDto dto, int index) => ResidencyItem(
        name: dto.name,
        location: dto.location,
        residentCount: dto.residentCount,
        icon: _icons[index % _icons.length],
      );

  Future<void> _submit(String residency, String section, String unit) async {
    final logic = context.read<RegisterLogic>();
    final l10n = AppLocalizations.of(context)!;
    final house = [section, unit].where((s) => s.isNotEmpty).join(' ');

    final ok = await logic.register(
      draft: widget.draft,
      l10n: l10n,
      residency: residency,
      house: house,
    );

    if (ok && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePath.pendingApproval,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Consumer<RegisterLogic>(
      builder: (context, logic, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.apartment, size: 40, color: cs.primary),
                const SizedBox(height: 12),
                Text(
                  l10n.selectResidency,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.selectResidencySubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                if (logic.hasError) ...[
                  const SizedBox(height: 16),
                  ErrorBanner(message: logic.errorMessage!),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildBody(logic),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(RegisterLogic logic) {
    if (logic.isLoading || _loadingList) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(_loadError!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadResidencies,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      );
    }

    return ResidencyPicker(
      residencies: _residencies ?? [],
      onConfirm: _submit,
    );
  }
}
