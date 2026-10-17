import 'package:flutter/widgets.dart' show Brightness;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup/data/database/app_database.dart';
import 'package:levelup/data/dev_seed.dart';
import 'package:levelup/data/drift_game_repository.dart';
import 'package:levelup/data/game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/state/theme_settings.dart';

/// How the app database is opened. Tests override it with an in-memory one.
final appDatabaseOpenerProvider = Provider<AppDatabase Function()>(
  (ref) => AppDatabase.new,
);

/// The local database, closed when the provider scope is disposed.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = ref.watch(appDatabaseOpenerProvider)();
  ref.onDispose(database.close);
  return database;
});

/// The data access used by the app. Tests override it with an
/// `InMemoryGameRepository`.
final gameRepositoryProvider = Provider<GameRepository>(
  (ref) => DriftGameRepository(ref.watch(appDatabaseProvider)),
);

/// The clock. Overridable so that code reading it stays deterministic in
/// tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// The hero, or null before one exists.
final heroProvider = StreamProvider<GameHero?>(
  (ref) => ref.watch(gameRepositoryProvider).watchHero(),
);

/// The habits that are not archived.
final activeHabitsProvider = StreamProvider<List<Habit>>(
  (ref) => ref.watch(gameRepositoryProvider).watchHabits(),
);

/// TEMPORARY (removed by PLU-22): creates the development hero and habits on
/// the first launch, in the theme the app is currently showing.
final devSeedProvider = FutureProvider<void>((ref) {
  final brightness = ref.read(themeSettingsProvider).brightness;
  return seedDevelopmentData(
    ref.read(gameRepositoryProvider),
    now: ref.read(clockProvider)(),
    theme: brightness == Brightness.dark ? ThemeKey.dark : ThemeKey.light,
  );
});
