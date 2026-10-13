import 'package:neighbour_alert/features/auth/register/data/datasource.dart';
import 'package:neighbour_alert/features/auth/register/model/registration_draft.dart';

abstract class RegisterRepository {
  Future<void> register(
    RegistrationDraft draft, {
    String? residency,
    String? house,
  });
}

class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl({required this.dataSource});

  final RegisterDataSource dataSource;

  @override
  Future<void> register(
    RegistrationDraft draft, {
    String? residency,
    String? house,
  }) {
    return dataSource.register(draft, residency: residency, house: house);
  }
}
