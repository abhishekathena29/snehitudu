import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/engagement/daily_challenge_screen.dart';
import '../screens/engagement/engagement_screen.dart';
import '../screens/engagement/mini_game_screen.dart';
import '../screens/engagement/photo_puzzle_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/main_shell.dart';

class AppRouter {
  AppRouter();

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
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
                    builder: (context, state) =>
                        const MiniGameScreen(type: MiniGameType.memory),
                  ),
                  GoRoute(
                    path: 'puzzle-games',
                    builder: (context, state) =>
                        const MiniGameScreen(type: MiniGameType.puzzle),
                  ),
                  GoRoute(
                    path: 'word-games',
                    builder: (context, state) =>
                        const MiniGameScreen(type: MiniGameType.word),
                  ),
                  GoRoute(
                    path: 'logic-games',
                    builder: (context, state) =>
                        const MiniGameScreen(type: MiniGameType.logic),
                  ),
                  GoRoute(
                    path: 'photo-puzzle',
                    builder: (context, state) => const PhotoPuzzleScreen(),
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
