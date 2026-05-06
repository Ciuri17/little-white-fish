import 'package:go_router/go_router.dart';

// Route paths
class RoutePaths {
  static const String home = '/';
  static const String detail = '/detail/:id';
}

// Router configuration
GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    );
  },
  routes: [
    // Add your routes here
  ],
);
