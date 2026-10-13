import 'package:neighbour_alert/features/auth/complete_profile/data/datasource.dart';

abstract class CompleteProfileRepository {
  Future<void> completeProfile({
    required String token,
    required String userId,
    required String residency,
    required String house,
  });
}

class CompleteProfileRepositoryImpl implements CompleteProfileRepository {
  CompleteProfileRepositoryImpl({required this.dataSource});

  final CompleteProfileDataSource dataSource;

  @override
  Future<void> completeProfile({
    required String token,
    required String userId,
    required String residency,
    required String house,
  }) {
    return dataSource.completeProfile(
      token: token,
      userId: userId,
      residency: residency,
      house: house,
    );
  }
}
