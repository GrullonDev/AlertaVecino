import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/register/data/repository.dart';
import 'package:neighbour_alert/features/auth/register/logic/register_logic.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';
import 'package:neighbour_alert/features/auth/select_residency/pages/select_residency_layout.dart';
import 'package:neighbour_alert/utils/injection_container.dart';
import 'package:neighbour_alert/utils/widgets/auth_scaffold.dart';
import 'package:provider/provider.dart';

class SelectResidencyPage extends StatelessWidget {
  const SelectResidencyPage({super.key, required this.draft});

  final RegistrationDraft draft;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterLogic>(
      create: (context) =>
          RegisterLogic(repository: sl.get<RegisterRepository>()),
      child: AuthScaffold(
        showBackButton: true,
        child: SelectResidencyLayout(draft: draft),
      ),
    );
  }
}
