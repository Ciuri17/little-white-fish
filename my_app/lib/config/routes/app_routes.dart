import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/game/menu_page.dart';
import '../../presentation/pages/game/game_page.dart';
import '../../presentation/pages/game/game_over_page.dart';

// Route paths
class RoutePaths {
  static const String home = '/';
  static const String game = '/game';
  static const String gameOver = '/game-over';
}

// Router configuration
final appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    );
  },
  routes: [
    GoRoute(
      path: RoutePaths.home,
      builder: (context, state) => const MenuPage(),
    ),
    GoRoute(
      path: RoutePaths.game,
      builder: (context, state) => const GamePage(),
    ),
    GoRoute(
      path: RoutePaths.gameOver,
      builder: (context, state) => const GameOverPage(),
    ),
  ],
);
