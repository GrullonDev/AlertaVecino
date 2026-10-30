class TriggerResult {
  final String? alertId;
  final String? status;
  final String? error;

  const TriggerResult({this.alertId, this.status, this.error});

  bool get isSuccess => alertId != null && error == null;
}
