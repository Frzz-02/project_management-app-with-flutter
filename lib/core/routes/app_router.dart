import 'package:go_router/go_router.dart';
import 'package:project_management/core/layout/main_page.dart';
import 'package:project_management/core/services/secure_storage_service.dart';
import 'package:project_management/features/authentication/data/data_sources/auth_local_data_source_impl.dart';
import 'package:project_management/features/authentication/presentation/pages/login_page.dart';
import 'package:project_management/features/authentication/presentation/pages/register_page.dart';
import 'package:project_management/features/card/presentation/pages/cards_page.dart';
import 'package:project_management/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:project_management/features/profile/presentation/pages/profile_page.dart';
import 'package:project_management/features/task/presentation/pages/task_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: LoginPage.routeName,
    redirect: (context, state) async {
      final token = AuthLocalDataSourceImpl(SecureStorageService());
      final getToken = await token.getCacheToken();

      final location = state.uri.toString();

      if (getToken == null &&
          (location == '/login' || location == '/register')) {
        return null;
      }

      if (getToken == null && location != '/login' && location != '/register') {
        return '/login';
      }

      if (getToken != null &&
          (location == '/login' || location == '/register')) {
        return '/main';
      }
      // if ((location == '/login' || location == '/register')) {
      //   await token.clearToken();
      //   return '/login';
      // }

      return null;
    },

    routes: [
      GoRoute(
        path: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.routeName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: MainPage.routeName,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: CardsPage.routeName,
        builder: (context, state) => const CardsPage(),
      ),
      GoRoute(
        path: DashboardPage.routeName,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: TaskPage.routeName,
        builder: (context, state) => const TaskPage(),
      ),
      GoRoute(
        path: ProfilePage.routeName,
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
