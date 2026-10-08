import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/palettes.dart';
import 'package:levelup/theme/theme.dart';

void main() {
  group('buildTheme', () {
    test('light theme carries AppColors.light for the accent', () {
      final theme = buildTheme(Brightness.light, AccentKey.salvia);

      final colors = theme.extension<AppColors>()!;

      expect(theme.brightness, Brightness.light);
      expect(colors.accent, Palettes.accent(AccentKey.salvia));
      expect(colors.bg, AppColors.light(colors.accent).bg);
    });

    test('dark theme carries AppColors.dark for the accent', () {
      final theme = buildTheme(Brightness.dark, AccentKey.rosa);

      final colors = theme.extension<AppColors>()!;

      expect(theme.brightness, Brightness.dark);
      expect(colors.bg, AppColors.dark(colors.accent).bg);
    });

    test('scaffold uses the bg token and colour scheme uses the accent', () {
      final theme = buildTheme(Brightness.light, AccentKey.ambra);

      final colors = theme.extension<AppColors>()!;

      expect(theme.scaffoldBackgroundColor, colors.bg);
      expect(theme.colorScheme.primary, colors.accent);
    });

    test('the whole text theme uses SpaceMono', () {
      final theme = buildTheme(Brightness.light, AccentKey.terra);

      expect(theme.textTheme.bodyMedium?.fontFamily, 'SpaceMono');
      expect(theme.textTheme.titleLarge?.fontFamily, 'SpaceMono');
    });

    test('different accents produce different themes', () {
      final a = buildTheme(Brightness.light, AccentKey.terra);
      final b = buildTheme(Brightness.light, AccentKey.ardesia);

      expect(a.colorScheme.primary, isNot(b.colorScheme.primary));
    });
  });

  group('context.colors', () {
    testWidgets('reads the AppColors extension from the active theme', (
      tester,
    ) async {
      late AppColors read;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(Brightness.light, AccentKey.ardesia),
          home: Builder(
            builder: (context) {
              read = context.colors;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(read.accent, Palettes.accent(AccentKey.ardesia));
    });

    testWidgets('fails loudly when the theme was not built by buildTheme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.colors;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tester.takeException(), isA<StateError>());
    });
  });
}
