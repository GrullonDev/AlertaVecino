import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/select_residency/pages/select_residency_layout.dart';
import 'package:neighbour_alert/utils/widgets/auth_scaffold.dart';

class SelectResidencyPage extends StatelessWidget {
  const SelectResidencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      showBackButton: true,
      child: SelectResidencyLayout(),
    );
  }
}
