import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/complete_profile/data/repository.dart';
import 'package:neighbour_alert/features/auth/complete_profile/logic/complete_profile_logic.dart';
import 'package:neighbour_alert/features/auth/complete_profile/model/complete_profile_args.dart';
import 'package:neighbour_alert/features/auth/complete_profile/pages/complete_profile_layout.dart';
import 'package:neighbour_alert/utils/injection_container.dart';
import 'package:neighbour_alert/utils/widgets/auth_scaffold.dart';
import 'package:provider/provider.dart';

class CompleteProfilePage extends StatelessWidget {
  const CompleteProfilePage({super.key, required this.args});

  final ProfileCompletionArgs args;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CompleteProfileLogic>(
      create: (context) => CompleteProfileLogic(
        repository: sl.get<CompleteProfileRepository>(),
      ),
      child: AuthScaffold(
        showBackButton: true,
        child: CompleteProfileLayout(args: args),
      ),
    );
  }
}
