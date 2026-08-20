import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/local/token_local_datasource.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/staff/domain/entities/user.dart';
import '../../features/staff/presentation/pages/staff_detail_page.dart';
import '../../features/staff/presentation/pages/staff_directory_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter(this._tokenLocalDataSource);

  final TokenLocalDataSource _tokenLocalDataSource;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.staff,
        builder: (context, state) => const StaffDirectoryPage(),
      ),
      GoRoute(
        path: AppRoutes.staffDetail,
        builder: (context, state) =>
            StaffDetailPage(user: state.extra as User),
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final hasToken = _tokenLocalDataSource.currentToken != null;
    final location = state.matchedLocation;

    if (!hasToken && location.startsWith(AppRoutes.staff)) {
      return AppRoutes.login;
    }
    return null;
  }
}
