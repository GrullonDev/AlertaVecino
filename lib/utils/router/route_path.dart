class RoutePath {
  // 1. Autenticación y Onboarding
  static const String login = '/login';
  static const String register = '/register';
  static const String userVerification = '/user-verification';
  static const String sectorSelection = '/sector-selection';

  // 2. Reportes de Incidente y Emergencia
  static const String panicButton = '/panic-button';
  static const String incidentReport = '/incident-report';
  static const String incidentList = '/incident-list';
  static const String incidentDetail = '/incident-detail';

  // 3. Mapas y Geolocalización
  static const String incidentMap = '/incident-map';
  static const String activeReportsMap = '/active-reports-map';

  // 4. Estados e Historial
  static const String reportStatus = '/report-status';
  static const String history = '/history';

  // 5. Alertas y Notificaciones
  static const String notifications = '/notifications';

  // 6. Preferencias de Usuario
  static const String profile = '/profile';
  static const String settings = '/settings';

  // 7. Administración
  static const String adminPanel = '/admin-panel';
}
