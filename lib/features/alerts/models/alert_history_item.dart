enum AlertCategory { medical, security, fire, general }

enum AlertStatus { active, handled, resolved, falseAlarm }

class AlertHistoryItem {
  const AlertHistoryItem({
    required this.id,
    required this.category,
    required this.status,
    required this.title,
    required this.location,
    required this.reportedAt,
    required this.duration,
    required this.description,
    this.guardNotes,
    this.responseTime,
    this.reportedBy,
  });

  final String id;
  final AlertCategory category;
  final AlertStatus status;
  final String title;
  final String location;
  final DateTime reportedAt;
  final String duration;
  final String description;
  final String? guardNotes;
  final String? responseTime;
  final String? reportedBy;
}
