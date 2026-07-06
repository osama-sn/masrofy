import 'package:go_router/go_router.dart';
import 'package:masrofy/core/routes/app_routes.dart';
import 'package:masrofy/features/auth/view/pages/auth_page.dart';
import 'package:masrofy/features/home/view/pages/home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.auth,
  routes: [
    GoRoute(path: AppRoutes.auth, builder: (context, state) => AuthPage()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => HomePage()),
    
  ],
);
