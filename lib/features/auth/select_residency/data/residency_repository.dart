import 'package:neighbour_alert/features/auth/select_residency/data/residency_datasource.dart';

abstract class ResidencyRepository {
  Future<List<ResidencyDto>> listResidencies();
}

class ResidencyRepositoryImpl implements ResidencyRepository {
  ResidencyRepositoryImpl({required ResidencyDataSource dataSource})
      : _dataSource = dataSource;

  final ResidencyDataSource _dataSource;

  @override
  Future<List<ResidencyDto>> listResidencies() =>
      _dataSource.listResidencies();
}
