import 'package:get_it/get_it.dart';

import '../core/network/api_client.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/datasources/http_auth_data_source.dart';
import '../features/auth/data/datasources/mock_auth_data_source.dart';
import '../features/staff/data/datasources/http_staff_data_source.dart';
import '../features/staff/data/datasources/mock_staff_data_source.dart';
import '../features/staff/data/datasources/staff_remote_datasource.dart';

const bool useMock = false;

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  if (useMock) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(() => MockAuthDataSource());
    getIt.registerLazySingleton<StaffRemoteDataSource>(() => MockStaffDataSource());
  } else {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => HttpAuthDataSource(getIt<ApiClient>()),
    );
    getIt.registerLazySingleton<StaffRemoteDataSource>(
      () => HttpStaffDataSource(getIt<ApiClient>()),
    );
  }
}
