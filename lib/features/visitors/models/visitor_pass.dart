enum VisitType { family, delivery, service, other }

enum VisitorStatus { expected, atGate, entered, expired }

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
}
