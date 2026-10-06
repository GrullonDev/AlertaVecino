import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Alerta Vecinos'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido de nuevo'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @keepSessionActive.
  ///
  /// In es, this message translates to:
  /// **'Mantener sesión iniciada'**
  String get keepSessionActive;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In es, this message translates to:
  /// **'o continuar con'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In es, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @passkey.
  ///
  /// In es, this message translates to:
  /// **'Passkey'**
  String get passkey;

  /// No description provided for @newToApp.
  ///
  /// In es, this message translates to:
  /// **'¿Nuevo en Alerta Vecinos? '**
  String get newToApp;

  /// No description provided for @requestAccess.
  ///
  /// In es, this message translates to:
  /// **'Solicitar acceso como vecino'**
  String get requestAccess;

  /// No description provided for @dataProtected.
  ///
  /// In es, this message translates to:
  /// **'Tus datos están protegidos y verificados'**
  String get dataProtected;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registro'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crea una cuenta en Alerta Vecinos'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get fullName;

  /// No description provided for @emailLower.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get emailLower;

  /// No description provided for @phoneNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de teléfono'**
  String get phoneNumber;

  /// No description provided for @departmentMunicipality.
  ///
  /// In es, this message translates to:
  /// **'Departamento / Municipio'**
  String get departmentMunicipality;

  /// No description provided for @colonyOrResidential.
  ///
  /// In es, this message translates to:
  /// **'Colonia o Residencial'**
  String get colonyOrResidential;

  /// No description provided for @sectorPhaseBlock.
  ///
  /// In es, this message translates to:
  /// **'Sector, fase, bloque o calle'**
  String get sectorPhaseBlock;

  /// No description provided for @houseNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de casa/apartamento (Opcional)'**
  String get houseNumber;

  /// No description provided for @verificationDocument.
  ///
  /// In es, this message translates to:
  /// **'Documento de verificación'**
  String get verificationDocument;

  /// No description provided for @verificationHelper.
  ///
  /// In es, this message translates to:
  /// **'Recibo de agua/luz, constancia de residencia o código de invitación'**
  String get verificationHelper;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get alreadyHaveAccount;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @map.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get map;

  /// No description provided for @alerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get alerts;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @logoutTitle.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de cerrar sesión?'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @yesExit.
  ///
  /// In es, this message translates to:
  /// **'Sí, salir'**
  String get yesExit;

  /// No description provided for @logOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logOut;

  /// No description provided for @helloNeighbor.
  ///
  /// In es, this message translates to:
  /// **'Hola, Vecino'**
  String get helloNeighbor;

  /// No description provided for @sampleNeighborhood.
  ///
  /// In es, this message translates to:
  /// **'Colonia La Esperanza, Sector 2'**
  String get sampleNeighborhood;

  /// No description provided for @sos.
  ///
  /// In es, this message translates to:
  /// **'S.O.S'**
  String get sos;

  /// No description provided for @sosHint.
  ///
  /// In es, this message translates to:
  /// **'Mantén presionado por 3 segundos para alertar'**
  String get sosHint;

  /// No description provided for @quickActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones Rápidas'**
  String get quickActions;

  /// No description provided for @reportIncident.
  ///
  /// In es, this message translates to:
  /// **'Reportar\nIncidente'**
  String get reportIncident;

  /// No description provided for @incidentMap.
  ///
  /// In es, this message translates to:
  /// **'Mapa de\nIncidentes'**
  String get incidentMap;

  /// No description provided for @localDirectory.
  ///
  /// In es, this message translates to:
  /// **'Directorio\nLocal'**
  String get localDirectory;

  /// No description provided for @myReports.
  ///
  /// In es, this message translates to:
  /// **'Mis\nReportes'**
  String get myReports;

  /// No description provided for @searchLocations.
  ///
  /// In es, this message translates to:
  /// **'Buscar ubicaciones o reportes...'**
  String get searchLocations;

  /// No description provided for @liveUpdates.
  ///
  /// In es, this message translates to:
  /// **'ACTUALIZACIONES EN VIVO'**
  String get liveUpdates;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @emergencies.
  ///
  /// In es, this message translates to:
  /// **'Emergencias'**
  String get emergencies;

  /// No description provided for @maintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get maintenance;

  /// No description provided for @searchAlerts.
  ///
  /// In es, this message translates to:
  /// **'Buscar alertas...'**
  String get searchAlerts;

  /// No description provided for @allNotifications.
  ///
  /// In es, this message translates to:
  /// **'Todas las Notificaciones'**
  String get allNotifications;

  /// No description provided for @emergencyBroadcasts.
  ///
  /// In es, this message translates to:
  /// **'Transmisiones de Emergencia'**
  String get emergencyBroadcasts;

  /// No description provided for @viewDetails.
  ///
  /// In es, this message translates to:
  /// **'VER DETALLES'**
  String get viewDetails;

  /// No description provided for @readFullStory.
  ///
  /// In es, this message translates to:
  /// **'LEER HISTORIA COMPLETA'**
  String get readFullStory;

  /// No description provided for @urgent.
  ///
  /// In es, this message translates to:
  /// **'URGENTE'**
  String get urgent;

  /// No description provided for @update.
  ///
  /// In es, this message translates to:
  /// **'ACTUALIZACIÓN'**
  String get update;

  /// No description provided for @general.
  ///
  /// In es, this message translates to:
  /// **'GENERAL'**
  String get general;

  /// No description provided for @resolved.
  ///
  /// In es, this message translates to:
  /// **'RESUELTO'**
  String get resolved;

  /// No description provided for @communityNews.
  ///
  /// In es, this message translates to:
  /// **'NOTICIAS COMUNITARIAS'**
  String get communityNews;

  /// No description provided for @share.
  ///
  /// In es, this message translates to:
  /// **'COMPARTIR'**
  String get share;

  /// No description provided for @verifiedResident.
  ///
  /// In es, this message translates to:
  /// **'Residente Verificado'**
  String get verifiedResident;

  /// No description provided for @neighborhoodInfo.
  ///
  /// In es, this message translates to:
  /// **'Información del Vecindario'**
  String get neighborhoodInfo;

  /// No description provided for @activeMemberSince.
  ///
  /// In es, this message translates to:
  /// **'Miembro activo desde marzo 2023'**
  String get activeMemberSince;

  /// No description provided for @personalInformation.
  ///
  /// In es, this message translates to:
  /// **'INFORMACIÓN PERSONAL'**
  String get personalInformation;

  /// No description provided for @phone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// No description provided for @security.
  ///
  /// In es, this message translates to:
  /// **'SEGURIDAD'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get changePassword;

  /// No description provided for @twoFactorAuth.
  ///
  /// In es, this message translates to:
  /// **'Autenticación de Dos Factores'**
  String get twoFactorAuth;

  /// No description provided for @off.
  ///
  /// In es, this message translates to:
  /// **'Desactivado'**
  String get off;

  /// No description provided for @notificationSettings.
  ///
  /// In es, this message translates to:
  /// **'CONFIGURACIÓN DE NOTIFICACIONES'**
  String get notificationSettings;

  /// No description provided for @pushNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones Push'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones por Correo'**
  String get emailNotifications;

  /// No description provided for @emergencyAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas de Emergencia'**
  String get emergencyAlerts;

  /// No description provided for @privacy.
  ///
  /// In es, this message translates to:
  /// **'PRIVACIDAD'**
  String get privacy;

  /// No description provided for @profileVisibility.
  ///
  /// In es, this message translates to:
  /// **'Visibilidad del Perfil'**
  String get profileVisibility;

  /// No description provided for @anonymousReporting.
  ///
  /// In es, this message translates to:
  /// **'Reportes Anónimos'**
  String get anonymousReporting;

  /// No description provided for @enabled.
  ///
  /// In es, this message translates to:
  /// **'Activado'**
  String get enabled;

  /// No description provided for @pageNotFound.
  ///
  /// In es, this message translates to:
  /// **'Página no encontrada'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundMessage.
  ///
  /// In es, this message translates to:
  /// **'La página que buscas no existe o fue movida.'**
  String get pageNotFoundMessage;

  /// No description provided for @goBack.
  ///
  /// In es, this message translates to:
  /// **'Regresar'**
  String get goBack;

  /// No description provided for @continueButton.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueButton;

  /// No description provided for @fieldRequired.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un correo electrónico válido'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres'**
  String get passwordTooShort;

  /// No description provided for @invalidPhone.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número de teléfono válido'**
  String get invalidPhone;

  /// No description provided for @selectResidency.
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu Residencial'**
  String get selectResidency;

  /// No description provided for @selectResidencySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Busca y selecciona el complejo donde resides'**
  String get selectResidencySubtitle;

  /// No description provided for @searchResidency.
  ///
  /// In es, this message translates to:
  /// **'Buscar residencial o colonia...'**
  String get searchResidency;

  /// No description provided for @popularResidencies.
  ///
  /// In es, this message translates to:
  /// **'Residenciales Populares'**
  String get popularResidencies;

  /// No description provided for @allResidencies.
  ///
  /// In es, this message translates to:
  /// **'Todas las Residenciales'**
  String get allResidencies;

  /// No description provided for @selectUnit.
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu Unidad'**
  String get selectUnit;

  /// No description provided for @selectUnitSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Indica tu casa o apartamento dentro del residencial'**
  String get selectUnitSubtitle;

  /// No description provided for @section.
  ///
  /// In es, this message translates to:
  /// **'Sección / Fase / Bloque'**
  String get section;

  /// No description provided for @unitNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de casa o apartamento'**
  String get unitNumber;

  /// No description provided for @confirmResidency.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Residencia'**
  String get confirmResidency;

  /// No description provided for @residents.
  ///
  /// In es, this message translates to:
  /// **'residentes'**
  String get residents;

  /// No description provided for @noResidenciesFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron residenciales'**
  String get noResidenciesFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In es, this message translates to:
  /// **'Intenta con otro término de búsqueda'**
  String get tryDifferentSearch;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In es, this message translates to:
  /// **'Registro Enviado'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu solicitud está en revisión'**
  String get pendingApprovalSubtitle;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In es, this message translates to:
  /// **'La administración de tu residencial verificará tu identidad y dirección. Este proceso puede tomar entre 24 a 48 horas.'**
  String get pendingApprovalMessage;

  /// No description provided for @pendingApprovalStep1.
  ///
  /// In es, this message translates to:
  /// **'Solicitud recibida'**
  String get pendingApprovalStep1;

  /// No description provided for @pendingApprovalStep2.
  ///
  /// In es, this message translates to:
  /// **'Verificación de identidad'**
  String get pendingApprovalStep2;

  /// No description provided for @pendingApprovalStep3.
  ///
  /// In es, this message translates to:
  /// **'Aprobación del administrador'**
  String get pendingApprovalStep3;

  /// No description provided for @pendingApprovalStep4.
  ///
  /// In es, this message translates to:
  /// **'Acceso activado'**
  String get pendingApprovalStep4;

  /// No description provided for @pendingApprovalCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get pendingApprovalCompleted;

  /// No description provided for @pendingApprovalInProgress.
  ///
  /// In es, this message translates to:
  /// **'En progreso'**
  String get pendingApprovalInProgress;

  /// No description provided for @pendingApprovalPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pendingApprovalPending;

  /// No description provided for @pendingApprovalHelp.
  ///
  /// In es, this message translates to:
  /// **'¿Necesitas ayuda? Contacta a la administración de tu residencial.'**
  String get pendingApprovalHelp;

  /// No description provided for @backToLogin.
  ///
  /// In es, this message translates to:
  /// **'Volver al inicio de sesión'**
  String get backToLogin;

  /// No description provided for @contactAdmin.
  ///
  /// In es, this message translates to:
  /// **'Contactar Administración'**
  String get contactAdmin;

  /// No description provided for @goodMorning.
  ///
  /// In es, this message translates to:
  /// **'Buenos días'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In es, this message translates to:
  /// **'Buenas tardes'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In es, this message translates to:
  /// **'Buenas noches'**
  String get goodEvening;

  /// No description provided for @houseUnit.
  ///
  /// In es, this message translates to:
  /// **'Casa #{number}'**
  String houseUnit(String number);

  /// No description provided for @connected.
  ///
  /// In es, this message translates to:
  /// **'Conectado'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In es, this message translates to:
  /// **'Desconectado'**
  String get disconnected;

  /// No description provided for @announcements.
  ///
  /// In es, this message translates to:
  /// **'Anuncios'**
  String get announcements;

  /// No description provided for @announcementFromAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administración'**
  String get announcementFromAdmin;

  /// No description provided for @announcementSample1.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento del portón principal este viernes de 8:00 a 12:00 hrs.'**
  String get announcementSample1;

  /// No description provided for @announcementSample2.
  ///
  /// In es, this message translates to:
  /// **'Asamblea general de vecinos — Sábado 15 a las 10:00 hrs.'**
  String get announcementSample2;

  /// No description provided for @announcementSample3.
  ///
  /// In es, this message translates to:
  /// **'Fumigación en áreas comunes programada para el lunes.'**
  String get announcementSample3;

  /// No description provided for @seeAllAnnouncements.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get seeAllAnnouncements;

  /// No description provided for @visitors.
  ///
  /// In es, this message translates to:
  /// **'Visitantes'**
  String get visitors;

  /// No description provided for @noVisitorsAtGate.
  ///
  /// In es, this message translates to:
  /// **'Sin visitantes en la garita'**
  String get noVisitorsAtGate;

  /// No description provided for @visitorArrived.
  ///
  /// In es, this message translates to:
  /// **'¡Tu visitante {name} acaba de llegar!'**
  String visitorArrived(String name);

  /// No description provided for @generateQrPass.
  ///
  /// In es, this message translates to:
  /// **'Generar pase QR'**
  String get generateQrPass;

  /// No description provided for @visitorHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de visitas'**
  String get visitorHistory;

  /// No description provided for @expectedToday.
  ///
  /// In es, this message translates to:
  /// **'Esperados hoy: {count}'**
  String expectedToday(int count);

  /// No description provided for @panicButtonLabel.
  ///
  /// In es, this message translates to:
  /// **'EMERGENCIA'**
  String get panicButtonLabel;

  /// No description provided for @panicButtonHint.
  ///
  /// In es, this message translates to:
  /// **'Mantén presionado 3 segundos para activar'**
  String get panicButtonHint;

  /// No description provided for @panicButtonActive.
  ///
  /// In es, this message translates to:
  /// **'¡ALERTA ENVIADA!'**
  String get panicButtonActive;

  /// No description provided for @accessHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial\nde Accesos'**
  String get accessHistory;

  /// No description provided for @neighborhoodDirectory.
  ///
  /// In es, this message translates to:
  /// **'Directorio\nVecinal'**
  String get neighborhoodDirectory;

  /// No description provided for @reportsToAdmin.
  ///
  /// In es, this message translates to:
  /// **'Reportes a\nAdministración'**
  String get reportsToAdmin;

  /// No description provided for @communityChat.
  ///
  /// In es, this message translates to:
  /// **'Chat\nComunitario'**
  String get communityChat;

  /// No description provided for @packageDeliveries.
  ///
  /// In es, this message translates to:
  /// **'Paquetería'**
  String get packageDeliveries;

  /// No description provided for @communityEvents.
  ///
  /// In es, this message translates to:
  /// **'Eventos'**
  String get communityEvents;

  /// No description provided for @panicSelectType.
  ///
  /// In es, this message translates to:
  /// **'¿Qué tipo de emergencia?'**
  String get panicSelectType;

  /// No description provided for @panicSelectTypeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona para enviar la alerta correcta'**
  String get panicSelectTypeSubtitle;

  /// No description provided for @panicMedical.
  ///
  /// In es, this message translates to:
  /// **'Emergencia Médica'**
  String get panicMedical;

  /// No description provided for @panicMedicalDesc.
  ///
  /// In es, this message translates to:
  /// **'Ambulancia / Primeros Auxilios'**
  String get panicMedicalDesc;

  /// No description provided for @panicIntruder.
  ///
  /// In es, this message translates to:
  /// **'Intruso / Actividad Sospechosa'**
  String get panicIntruder;

  /// No description provided for @panicIntruderDesc.
  ///
  /// In es, this message translates to:
  /// **'Seguridad Privada / Policía'**
  String get panicIntruderDesc;

  /// No description provided for @panicFire.
  ///
  /// In es, this message translates to:
  /// **'Incendio / Fuga de Gas'**
  String get panicFire;

  /// No description provided for @panicFireDesc.
  ///
  /// In es, this message translates to:
  /// **'Bomberos'**
  String get panicFireDesc;

  /// No description provided for @panicOther.
  ///
  /// In es, this message translates to:
  /// **'Otra / Asistencia General'**
  String get panicOther;

  /// No description provided for @panicOtherDesc.
  ///
  /// In es, this message translates to:
  /// **'Solicitar ayuda general'**
  String get panicOtherDesc;

  /// No description provided for @panicCountdownTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu alerta se enviará en'**
  String get panicCountdownTitle;

  /// No description provided for @panicCountdownCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar — Fue un error'**
  String get panicCountdownCancel;

  /// No description provided for @panicSending.
  ///
  /// In es, this message translates to:
  /// **'Enviando alerta...'**
  String get panicSending;

  /// No description provided for @panicActiveTitle.
  ///
  /// In es, this message translates to:
  /// **'EMERGENCIA EN CURSO'**
  String get panicActiveTitle;

  /// No description provided for @panicActiveElapsed.
  ///
  /// In es, this message translates to:
  /// **'Tiempo transcurrido'**
  String get panicActiveElapsed;

  /// No description provided for @panicActiveOrigin.
  ///
  /// In es, this message translates to:
  /// **'Origen de la alerta'**
  String get panicActiveOrigin;

  /// No description provided for @panicActiveType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get panicActiveType;

  /// No description provided for @panicChatPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Escribe un mensaje a seguridad...'**
  String get panicChatPlaceholder;

  /// No description provided for @panicCancelAlert.
  ///
  /// In es, this message translates to:
  /// **'Estoy bien — Cancelar alerta'**
  String get panicCancelAlert;

  /// No description provided for @panicCancelConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cancelar la alerta?'**
  String get panicCancelConfirmTitle;

  /// No description provided for @panicCancelConfirmMessage.
  ///
  /// In es, this message translates to:
  /// **'Confirma que estás a salvo y deseas cancelar la alerta activa.'**
  String get panicCancelConfirmMessage;

  /// No description provided for @panicCancelConfirmYes.
  ///
  /// In es, this message translates to:
  /// **'Sí, estoy a salvo'**
  String get panicCancelConfirmYes;

  /// No description provided for @panicAlertSent.
  ///
  /// In es, this message translates to:
  /// **'Alerta enviada a seguridad'**
  String get panicAlertSent;

  /// No description provided for @panicAlertCancelled.
  ///
  /// In es, this message translates to:
  /// **'Alerta cancelada'**
  String get panicAlertCancelled;

  /// No description provided for @panicSecurityNotified.
  ///
  /// In es, this message translates to:
  /// **'Seguridad ha sido notificada'**
  String get panicSecurityNotified;

  /// No description provided for @panicNeighborsNotified.
  ///
  /// In es, this message translates to:
  /// **'Vecinos cercanos alertados'**
  String get panicNeighborsNotified;

  /// No description provided for @panicGuardOnWay.
  ///
  /// In es, this message translates to:
  /// **'Guardia en camino'**
  String get panicGuardOnWay;

  /// No description provided for @panicChatLog.
  ///
  /// In es, this message translates to:
  /// **'Registro de comunicación'**
  String get panicChatLog;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
