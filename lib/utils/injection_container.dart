import 'package:get_it/get_it.dart';

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

final GetIt sl = GetIt.instance;

Future<void> init() async {
  initDependencies();
}

void initDependencies() {
  if (!sl.isRegistered<SessionService>()) {
    sl.registerLazySingleton<SessionService>(() => SessionService());
  }

  // DataSource -> Repository
  if (!sl.isRegistered<DataSource>()) {
    sl.registerLazySingleton<DataSource>(() => DataSourceImpl());
  }
  if (!sl.isRegistered<RepositoryImpl>()) {
    sl.registerLazySingleton<RepositoryImpl>(
      () => RepositoryImpl(dataSource: sl<DataSource>()),
    );
  }
  if (!sl.isRegistered<Repository>()) {
    sl.registerLazySingleton<Repository>(() => sl<RepositoryImpl>());
  }

  // Registro de vecinos
  if (!sl.isRegistered<register.RegisterDataSource>()) {
    sl.registerLazySingleton<register.RegisterDataSource>(
      () => register.RegisterDataSourceImpl(),
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
      () => announcements.AnnouncementsDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<announcements.AnnouncementsRepository>()) {
    sl.registerLazySingleton<announcements.AnnouncementsRepository>(
      () => announcements.AnnouncementsRepositoryImpl(
        dataSource: sl<announcements.AnnouncementsDataSource>(),
      ),
    );
  }

  // Completar perfil de un usuario autenticado
  if (!sl.isRegistered<complete_profile.CompleteProfileDataSource>()) {
    sl.registerLazySingleton<complete_profile.CompleteProfileDataSource>(
      () => complete_profile.CompleteProfileDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<complete_profile.CompleteProfileRepository>()) {
    sl.registerLazySingleton<complete_profile.CompleteProfileRepository>(
      () => complete_profile.CompleteProfileRepositoryImpl(
        dataSource: sl<complete_profile.CompleteProfileDataSource>(),
      ),
    );
  }
}
