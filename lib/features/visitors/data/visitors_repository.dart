import 'package:neighbour_alert/features/visitors/data/visitors_datasource.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';

abstract class VisitorsRepository {
  Future<List<VisitorPass>> listPasses();
  Future<VisitorPass> createPass(VisitorPass pass);
  Future<VisitorPass> getPass(String id);
  Future<void> updatePassStatus(String id, String status);
}

class VisitorsRepositoryImpl implements VisitorsRepository {
  VisitorsRepositoryImpl({required VisitorsDataSource dataSource})
      : _dataSource = dataSource;

  final VisitorsDataSource _dataSource;

  @override
  Future<List<VisitorPass>> listPasses() => _dataSource.listPasses();

  @override
  Future<VisitorPass> createPass(VisitorPass pass) =>
      _dataSource.createPass(pass);

  @override
  Future<VisitorPass> getPass(String id) => _dataSource.getPass(id);

  @override
  Future<void> updatePassStatus(String id, String status) =>
      _dataSource.updatePassStatus(id, status);
}
