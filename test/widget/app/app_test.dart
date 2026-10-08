import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/app/app.dart';
import 'package:levelup/domain/accent_key.dart';
import 'package:levelup/state/theme_settings.dart';
import 'package:levelup/theme/lu_colors.dart';
import 'package:levelup/theme/lu_palettes.dart';
import 'package:levelup/ui/screens/home_placeholder.dart';

Future<ProviderContainer> _pumpApp(WidgetTester tester) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const LuApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

ThemeData _theme(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(HomePlaceholder)));

LuColors _colors(WidgetTester tester) => _theme(tester).extension<LuColors>()!;

void main() {
  group('LuApp', () {
    testWidgets('opens the placeholder home on route /', (tester) async {
      await _pumpApp(tester);

      expect(find.byType(HomePlaceholder), findsOneWidget);
    });

    testWidgets('starts in the light theme with the terra accent', (
      tester,
    ) async {
      await _pumpApp(tester);

      final colors = _colors(tester);
      expect(colors.accent, LuPalettes.accent(AccentKey.terra));
      expect(colors.bg, LuColors.light(colors.accent).bg);
    });

    testWidgets('changing the accent rebuilds the whole theme', (tester) async {
      final container = await _pumpApp(tester);

      container
          .read(themeSettingsProvider.notifier)
          .setAccent(AccentKey.salvia);
      await tester.pumpAndSettle();

      final colors = _colors(tester);
      expect(colors.accent, LuPalettes.accent(AccentKey.salvia));
      expect(colors.accentDeep, LuColors.light(colors.accent).accentDeep);
      expect(_theme(tester).colorScheme.primary, colors.accent);
    });

    testWidgets('switching to dark swaps the surface tokens', (tester) async {
      final container = await _pumpApp(tester);
      final lightBg = _colors(tester).bg;

      container
          .read(themeSettingsProvider.notifier)
          .setBrightness(Brightness.dark);
      await tester.pumpAndSettle();

      expect(_colors(tester).bg, isNot(lightBg));
      expect(_theme(tester).brightness, Brightness.dark);
    });

    testWidgets('placeholder paints with the theme background and title', (
      tester,
    ) async {
      await _pumpApp(tester);

      expect(_theme(tester).scaffoldBackgroundColor, _colors(tester).bg);
      expect(find.text('LevelUp'), findsOneWidget);
    });
  });
}
