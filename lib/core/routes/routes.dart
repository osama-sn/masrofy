import 'package:go_router/go_router.dart';
import 'package:masrofy/app.dart';
import 'package:masrofy/core/routes/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(path: AppRoutes.home, builder: (context, state) => HomePage()),
    GoRoute(path: AppRoutes.settings, builder: (context, state) => SettingsPage()),
  ],
);
