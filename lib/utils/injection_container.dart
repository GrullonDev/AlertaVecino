import 'package:get_it/get_it.dart';

import 'package:neighbour_alert/features/auth/login/data/datasource.dart';
import 'package:neighbour_alert/features/auth/login/data/repository.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
   initDependencies();
}

void initDependencies() {
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
}
