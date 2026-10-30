enum VisitType { family, delivery, service, other }

enum VisitorStatus { expected, atGate, entered, expired }

VisitType _parseVisitType(String? value) => switch (value) {
      'family' => VisitType.family,
      'delivery' => VisitType.delivery,
      'service' => VisitType.service,
      _ => VisitType.other,
    };

String _visitTypeToString(VisitType type) => switch (type) {
      VisitType.family => 'family',
      VisitType.delivery => 'delivery',
      VisitType.service => 'service',
      VisitType.other => 'other',
    };

VisitorStatus _parseStatus(String? value) => switch (value) {
      'expected' => VisitorStatus.expected,
      'at_gate' => VisitorStatus.atGate,
      'entered' => VisitorStatus.entered,
      'expired' => VisitorStatus.expired,
      _ => VisitorStatus.expected,
    };

class VisitorPass {
  final String id;
  final String visitorName;
  final String? dpi;
  final String? plate;
  final VisitType visitType;
  final DateTime validFrom;
  final DateTime validUntil;
  final VisitorStatus status;
  final DateTime? entryTime;

  const VisitorPass({
    required this.id,
    required this.visitorName,
    this.dpi,
    this.plate,
    required this.visitType,
    required this.validFrom,
    required this.validUntil,
    this.status = VisitorStatus.expected,
    this.entryTime,
  });

  factory VisitorPass.fromJson(Map<String, dynamic> json) {
    return VisitorPass(
      id: json['id'] as String? ?? '',
      visitorName: json['visitorName'] as String? ?? '',
      dpi: json['dpi'] as String?,
      plate: json['plate'] as String?,
      visitType: _parseVisitType(json['visitType'] as String?),
      validFrom: DateTime.tryParse(json['validFrom'] as String? ?? '') ??
          DateTime.now(),
      validUntil: DateTime.tryParse(json['validUntil'] as String? ?? '') ??
          DateTime.now(),
      status: _parseStatus(json['status'] as String?),
      entryTime: json['entryTime'] != null
          ? DateTime.tryParse(json['entryTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'visitor_name': visitorName,
        if (dpi != null && dpi!.isNotEmpty) 'dpi': dpi,
        if (plate != null && plate!.isNotEmpty) 'plate': plate,
        'visit_type': _visitTypeToString(visitType),
        'valid_from': validFrom.toUtc().toIso8601String(),
        'valid_until': validUntil.toUtc().toIso8601String(),
      };
}
