import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'di/injection.dart';
import 'features/auth/data/local/token_local_datasource.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/staff/presentation/bloc/staff_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await getIt<TokenLocalDataSource>().getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<StaffBloc>(create: (_) => getIt<StaffBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Staff Directory',
        theme: AppTheme.light,
        routerConfig: getIt<AppRouter>().router,
      ),
    );
  }
}
