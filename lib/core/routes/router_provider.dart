
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:protection/core/routes/app_routes.dart';
import 'package:protection/features/main/view/pages/dashboard_page.dart';
import 'package:protection/features/main/view/pages/home_page.dart';
import 'package:protection/features/main/view/pages/logs_page.dart';
import 'package:protection/features/main/view/pages/settings_page.dart';


final routerProvider = Provider((ref) {
  return GoRouter(routes: [
    GoRoute(path: AppRoutes.home, builder: (context, state) => HomePage()),
    GoRoute(path: AppRoutes.dashboard, builder: (context, state) => DashboardPage()),
    GoRoute(path: AppRoutes.settings, builder: (context, state) => SettingsPage()),
    GoRoute(path: AppRoutes.logs, builder: (context, state) => LogsPage()),
  ]);
});