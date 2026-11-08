import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:levelup/app/rise_page.dart';
import 'package:levelup/ui/l10n/l10n.dart';
import 'package:levelup/ui/screens/coming_soon_sheet.dart';
import 'package:levelup/ui/screens/home_screen.dart';

/// Paths of the app routes.
abstract final class AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const rewards = '/rewards';
  static const mission = '/mission';
  static const habits = '/habits';
}

typedef _SectionName = String Function(BuildContext context);

/// Closes a sheet; when it is the only page (opened with `go` or a link) it
/// goes to the Home instead of popping an empty stack.
void _close(BuildContext context) =>
    context.canPop() ? context.pop() : context.go(AppRoutes.home);

/// A placeholder sheet that rises from the bottom; replaced route by route
/// by the cards that build the real sheets.
GoRoute _comingSoon(String path, _SectionName section) => GoRoute(
  path: path,
  pageBuilder: (context, state) => risePage(
    key: state.pageKey,
    child: ComingSoonSheet(section: section, onClose: () => _close(context)),
  ),
);

/// App router: the Home on `/` and the placeholder sheets it opens.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      _comingSoon(AppRoutes.profile, (c) => c.l10n.comingSoonProfile),
      _comingSoon(AppRoutes.rewards, (c) => c.l10n.comingSoonRewards),
      _comingSoon(AppRoutes.mission, (c) => c.l10n.comingSoonMission),
      _comingSoon(AppRoutes.habits, (c) => c.l10n.comingSoonHabits),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
