import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/features/visitors/models/visitor_pass.dart';

abstract class VisitorsDataSource {
  Future<List<VisitorPass>> listPasses();
  Future<VisitorPass> createPass(VisitorPass pass);
  Future<VisitorPass> getPass(String id);
  Future<void> updatePassStatus(String id, String status);
}

class VisitorsDataSourceImpl implements VisitorsDataSource {
  VisitorsDataSourceImpl({required ApiClient apiClient})
      : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<VisitorPass>> listPasses() async {
    final json = await _api.get('/v1/visitors/passes');
    final items = json['passes'] as List<dynamic>? ?? [];
    return items
        .cast<Map<String, dynamic>>()
        .map(VisitorPass.fromJson)
        .toList();
  }

  @override
  Future<VisitorPass> createPass(VisitorPass pass) async {
    final json = await _api.post(
      '/v1/visitors/passes',
      body: pass.toJson(),
    );
    final passData = json['pass'] as Map<String, dynamic>? ?? {};
    return VisitorPass(
      id: passData['id'] as String? ?? '',
      visitorName: pass.visitorName,
      dpi: pass.dpi,
      plate: pass.plate,
      visitType: pass.visitType,
      validFrom: pass.validFrom,
      validUntil: pass.validUntil,
      status: VisitorStatus.expected,
    );
  }

  @override
  Future<VisitorPass> getPass(String id) async {
    final json = await _api.get('/v1/visitors/passes/$id');
    final passData = json['pass'] as Map<String, dynamic>? ?? {};
    return VisitorPass.fromJson(passData);
  }

  @override
  Future<void> updatePassStatus(String id, String status) async {
    await _api.patch(
      '/v1/visitors/passes/$id/status',
      body: {'status': status},
    );
  }
}
