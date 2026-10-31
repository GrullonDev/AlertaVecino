import 'package:get_it/get_it.dart';

import 'package:neighbour_alert/core/api/api_client.dart';
import 'package:neighbour_alert/core/session/session_service.dart';
import 'package:neighbour_alert/features/announcements/data/datasource.dart'
    as announcements;
import 'package:neighbour_alert/features/announcements/data/repository.dart'
    as announcements;
import 'package:neighbour_alert/features/auth/login/data/datasource.dart';
import 'package:neighbour_alert/features/auth/login/data/repository.dart';
import 'package:neighbour_alert/features/auth/complete_profile/data/datasource.dart'
    as complete_profile;
import 'package:neighbour_alert/features/auth/complete_profile/data/repository.dart'
    as complete_profile;
import 'package:neighbour_alert/features/auth/register/data/datasource.dart'
    as register;
import 'package:neighbour_alert/features/auth/register/data/repository.dart'
    as register;
import 'package:neighbour_alert/features/alerts/data/alerts_datasource.dart';
import 'package:neighbour_alert/features/alerts/data/alerts_repository.dart';
import 'package:neighbour_alert/features/auth/select_residency/data/residency_datasource.dart';
import 'package:neighbour_alert/features/auth/select_residency/data/residency_repository.dart';
import 'package:neighbour_alert/features/maps/data/map_datasource.dart';
import 'package:neighbour_alert/features/maps/data/map_repository.dart';
import 'package:neighbour_alert/features/admin/data/admin_datasource.dart';
import 'package:neighbour_alert/features/admin/data/admin_repository.dart';
import 'package:neighbour_alert/features/profile/data/profile_datasource.dart';
import 'package:neighbour_alert/features/profile/data/profile_repository.dart';
import 'package:neighbour_alert/features/panic/data/panic_datasource.dart';
import 'package:neighbour_alert/features/panic/data/panic_repository.dart';
import 'package:neighbour_alert/features/visitors/data/visitors_datasource.dart';
import 'package:neighbour_alert/features/visitors/data/visitors_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  initDependencies();
}

void initDependencies() {
  // Core
  if (!sl.isRegistered<SessionService>()) {
    sl.registerLazySingleton<SessionService>(() => SessionService());
  }
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(session: sl<SessionService>()),
    );
  }

  // Auth — Login
  if (!sl.isRegistered<DataSource>()) {
    sl.registerLazySingleton<DataSource>(
      () => DataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<RepositoryImpl>()) {
    sl.registerLazySingleton<RepositoryImpl>(
      () => RepositoryImpl(dataSource: sl<DataSource>()),
    );
  }
  if (!sl.isRegistered<Repository>()) {
    sl.registerLazySingleton<Repository>(() => sl<RepositoryImpl>());
  }

  // Auth — Registro
  if (!sl.isRegistered<register.RegisterDataSource>()) {
    sl.registerLazySingleton<register.RegisterDataSource>(
      () => register.RegisterDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<register.RegisterRepository>()) {
    sl.registerLazySingleton<register.RegisterRepository>(
      () => register.RegisterRepositoryImpl(
        dataSource: sl<register.RegisterDataSource>(),
      ),
    );
  }

  // Comunicados
  if (!sl.isRegistered<announcements.AnnouncementsDataSource>()) {
    sl.registerLazySingleton<announcements.AnnouncementsDataSource>(
      () => announcements.AnnouncementsDataSourceImpl(
        apiClient: sl<ApiClient>(),
      ),
    );
  }
  if (!sl.isRegistered<announcements.AnnouncementsRepository>()) {
    sl.registerLazySingleton<announcements.AnnouncementsRepository>(
      () => announcements.AnnouncementsRepositoryImpl(
        dataSource: sl<announcements.AnnouncementsDataSource>(),
      ),
    );
  }

  // Completar perfil
  if (!sl.isRegistered<complete_profile.CompleteProfileDataSource>()) {
    sl.registerLazySingleton<complete_profile.CompleteProfileDataSource>(
      () => complete_profile.CompleteProfileDataSourceImpl(
        apiClient: sl<ApiClient>(),
      ),
    );
  }
  if (!sl.isRegistered<complete_profile.CompleteProfileRepository>()) {
    sl.registerLazySingleton<complete_profile.CompleteProfileRepository>(
      () => complete_profile.CompleteProfileRepositoryImpl(
        dataSource: sl<complete_profile.CompleteProfileDataSource>(),
      ),
    );
  }

  // Pánico
  if (!sl.isRegistered<PanicDataSource>()) {
    sl.registerLazySingleton<PanicDataSource>(
      () => PanicDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<PanicRepository>()) {
    sl.registerLazySingleton<PanicRepository>(
      () => PanicRepositoryImpl(dataSource: sl<PanicDataSource>()),
    );
  }

  // Visitantes
  if (!sl.isRegistered<VisitorsDataSource>()) {
    sl.registerLazySingleton<VisitorsDataSource>(
      () => VisitorsDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<VisitorsRepository>()) {
    sl.registerLazySingleton<VisitorsRepository>(
      () => VisitorsRepositoryImpl(dataSource: sl<VisitorsDataSource>()),
    );
  }

  // Residencias
  if (!sl.isRegistered<ResidencyDataSource>()) {
    sl.registerLazySingleton<ResidencyDataSource>(
      () => ResidencyDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<ResidencyRepository>()) {
    sl.registerLazySingleton<ResidencyRepository>(
      () => ResidencyRepositoryImpl(dataSource: sl<ResidencyDataSource>()),
    );
  }

  // Alertas (historial)
  if (!sl.isRegistered<AlertsDataSource>()) {
    sl.registerLazySingleton<AlertsDataSource>(
      () => AlertsDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<AlertsRepository>()) {
    sl.registerLazySingleton<AlertsRepository>(
      () => AlertsRepositoryImpl(dataSource: sl<AlertsDataSource>()),
    );
  }

  // Mapa
  if (!sl.isRegistered<MapDataSource>()) {
    sl.registerLazySingleton<MapDataSource>(
      () => MapDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<MapRepository>()) {
    sl.registerLazySingleton<MapRepository>(
      () => MapRepositoryImpl(dataSource: sl<MapDataSource>()),
    );
  }

  // Admin
  if (!sl.isRegistered<AdminDataSource>()) {
    sl.registerLazySingleton<AdminDataSource>(
      () => AdminDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<AdminRepository>()) {
    sl.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(dataSource: sl<AdminDataSource>()),
    );
  }

  // Perfil
  if (!sl.isRegistered<ProfileDataSource>()) {
    sl.registerLazySingleton<ProfileDataSource>(
      () => ProfileDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }
  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(dataSource: sl<ProfileDataSource>()),
    );
  }
}
