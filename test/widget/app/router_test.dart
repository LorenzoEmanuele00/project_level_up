import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:levelup/app/router.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/l10n/app_localizations.dart';
import 'package:levelup/state/game_providers.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/ui/screens/coming_soon_sheet.dart';
import 'package:levelup/ui/screens/home_screen.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(InMemoryGameRepository()),
      ],
    );
    addTearDown(container.dispose);
  });

  GoRouter router() => container.read(routerProvider);

  List<String> topLevelPaths() => [
    for (final route in router().configuration.routes)
      if (route is GoRoute) route.path,
  ];

  test('declares the home and the four placeholder routes', () {
    expect(
      topLevelPaths(),
      unorderedEquals(['/', '/profile', '/rewards', '/mission', '/habits']),
    );
  });

  test('AppRoutes names match the declared paths', () {
    expect({
      AppRoutes.home,
      AppRoutes.profile,
      AppRoutes.rewards,
      AppRoutes.mission,
      AppRoutes.habits,
    }, topLevelPaths().toSet());
  });

  testWidgets('each placeholder route builds a coming soon sheet', (
    tester,
  ) async {
    for (final path in ['/profile', '/rewards', '/mission', '/habits']) {
      router().go(path);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router(),
            theme: buildTheme(Brightness.light, AccentKey.terracotta),
            locale: const Locale('it'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ComingSoonSheet), findsOneWidget, reason: path);
      await tester.pumpWidget(const SizedBox());
    }
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('closing a sheet reached with go() returns to the home', (
    tester,
  ) async {
    final own = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(InMemoryGameRepository()),
      ],
    );
    final ownRouter = own.read(routerProvider);
    ownRouter.go(AppRoutes.profile);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: own,
        child: MaterialApp.router(
          routerConfig: ownRouter,
          theme: buildTheme(Brightness.light, AccentKey.terracotta),
          locale: const Locale('it'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Chiudi'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    own.dispose();
  });
}
