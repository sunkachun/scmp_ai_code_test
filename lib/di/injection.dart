import 'package:get_it/get_it.dart';

import '../core/network/api_client.dart';
import '../core/router/app_router.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/datasources/http_auth_data_source.dart';
import '../features/auth/data/datasources/mock_auth_data_source.dart';
import '../features/auth/data/local/token_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/staff/data/datasources/http_staff_data_source.dart';
import '../features/staff/data/datasources/mock_staff_data_source.dart';
import '../features/staff/data/datasources/staff_remote_datasource.dart';
import '../features/staff/data/repositories/staff_repository_impl.dart';
import '../features/staff/domain/repositories/staff_repository.dart';
import '../features/staff/presentation/bloc/staff_bloc.dart';

const bool useMock = true;

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<TokenLocalDataSource>(() => TokenLocalDataSource());

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

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<StaffRepository>(
    () => StaffRepositoryImpl(getIt<StaffRemoteDataSource>()),
  );

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>(), getIt<TokenLocalDataSource>()),
  );
  getIt.registerFactory<StaffBloc>(
    () => StaffBloc(getIt<StaffRepository>(), getIt<TokenLocalDataSource>()),
  );

  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(getIt<TokenLocalDataSource>()),
  );
}
