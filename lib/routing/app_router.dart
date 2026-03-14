import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/engagement/daily_challenge_screen.dart';
import '../screens/engagement/engagement_screen.dart';
import '../screens/engagement/mini_game_screen.dart';
import '../screens/explore/article_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../services/auth_service.dart';
import '../widgets/main_shell.dart';

class AppRouter {
  AppRouter(this.authService);

  final AuthService authService;

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: authService,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (authService.isLoading) return null;
      if (!authService.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }
      if (isLoggingIn || state.matchedLocation == '/') {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/article/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return ArticleScreen(articleId: id);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/engagement',
                builder: (context, state) => const EngagementScreen(),
                routes: [
                  GoRoute(
                    path: 'daily-challenge',
                    builder: (context, state) => const DailyChallengeScreen(),
                  ),
                  GoRoute(
                    path: 'memory-games',
                    builder: (context, state) => const MiniGameScreen(type: MiniGameType.memory),
                  ),
                  GoRoute(
                    path: 'puzzle-games',
                    builder: (context, state) => const MiniGameScreen(type: MiniGameType.puzzle),
                  ),
                  GoRoute(
                    path: 'word-games',
                    builder: (context, state) => const MiniGameScreen(type: MiniGameType.word),
                  ),
                  GoRoute(
                    path: 'logic-games',
                    builder: (context, state) => const MiniGameScreen(type: MiniGameType.logic),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
