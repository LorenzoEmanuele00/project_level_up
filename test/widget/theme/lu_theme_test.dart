import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/accent_key.dart';
import 'package:levelup/theme/lu_colors.dart';
import 'package:levelup/theme/lu_palettes.dart';
import 'package:levelup/theme/lu_theme.dart';

void main() {
  group('buildLuTheme', () {
    test('light theme carries LuColors.light for the accent', () {
      final theme = buildLuTheme(Brightness.light, AccentKey.salvia);

      final colors = theme.extension<LuColors>()!;

      expect(theme.brightness, Brightness.light);
      expect(colors.accent, LuPalettes.accent(AccentKey.salvia));
      expect(colors.bg, LuColors.light(colors.accent).bg);
    });

    test('dark theme carries LuColors.dark for the accent', () {
      final theme = buildLuTheme(Brightness.dark, AccentKey.rosa);

      final colors = theme.extension<LuColors>()!;

      expect(theme.brightness, Brightness.dark);
      expect(colors.bg, LuColors.dark(colors.accent).bg);
    });

    test('scaffold uses the bg token and colour scheme uses the accent', () {
      final theme = buildLuTheme(Brightness.light, AccentKey.ambra);

      final colors = theme.extension<LuColors>()!;

      expect(theme.scaffoldBackgroundColor, colors.bg);
      expect(theme.colorScheme.primary, colors.accent);
    });

    test('the whole text theme uses SpaceMono', () {
      final theme = buildLuTheme(Brightness.light, AccentKey.terra);

      expect(theme.textTheme.bodyMedium?.fontFamily, 'SpaceMono');
      expect(theme.textTheme.titleLarge?.fontFamily, 'SpaceMono');
    });

    test('different accents produce different themes', () {
      final a = buildLuTheme(Brightness.light, AccentKey.terra);
      final b = buildLuTheme(Brightness.light, AccentKey.ardesia);

      expect(a.colorScheme.primary, isNot(b.colorScheme.primary));
    });
  });

  group('context.lu', () {
    testWidgets('reads the LuColors extension from the active theme', (
      tester,
    ) async {
      late LuColors read;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildLuTheme(Brightness.light, AccentKey.ardesia),
          home: Builder(
            builder: (context) {
              read = context.lu;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(read.accent, LuPalettes.accent(AccentKey.ardesia));
    });

    testWidgets('fails loudly when the theme was not built by buildLuTheme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.lu;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tester.takeException(), isA<StateError>());
    });
  });
}
