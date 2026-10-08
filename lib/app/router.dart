import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:levelup/ui/screens/home_placeholder.dart';

/// App router. Only the placeholder home exists for now; the other routes are
/// added by the cards that build the screens.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePlaceholder()),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
