import 'package:neighbour_alert/core/api/api_client.dart';

class ResidencyDto {
  const ResidencyDto({
    required this.id,
    required this.name,
    required this.location,
    required this.residentCount,
  });

  factory ResidencyDto.fromJson(Map<String, dynamic> json) => ResidencyDto(
        id: json['id'] as String,
        name: json['name'] as String,
        location: json['location'] as String? ?? '',
        residentCount: json['residentCount'] as int? ?? 0,
      );

  final String id;
  final String name;
  final String location;
  final int residentCount;
}

abstract class ResidencyDataSource {
  Future<List<ResidencyDto>> listResidencies();
}

class ResidencyDataSourceImpl implements ResidencyDataSource {
  ResidencyDataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<ResidencyDto>> listResidencies() async {
    final json = await _api.get('/v1/residencies');
    final list = json['residencies'] as List<dynamic>;
    return [
      for (final item in list)
        ResidencyDto.fromJson(item as Map<String, dynamic>),
    ];
  }
}
