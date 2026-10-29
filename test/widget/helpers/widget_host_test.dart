import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/palettes.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/ui/l10n/l10n.dart';

import '../../helpers/widget_host.dart';

BuildContext _context(WidgetTester tester) =>
    tester.element(find.byType(Scaffold));

void main() {
  group('widgetHost', () {
    testWidgets('applies the app theme for brightness and accent', (
      tester,
    ) async {
      await tester.pumpWidget(
        widgetHost(
          const SizedBox(),
          brightness: Brightness.dark,
          accent: AccentKey.sage,
        ),
      );

      final colors = _context(tester).colors;

      expect(colors.isDark, isTrue);
      expect(colors.accent, Palettes.accent(AccentKey.sage));
    });

    testWidgets('defaults to light, terracotta, Italian, animations on', (
      tester,
    ) async {
      await tester.pumpWidget(widgetHost(const SizedBox()));
      final context = _context(tester);

      expect(context.colors.isDark, isFalse);
      expect(context.colors.accent, Palettes.accent(AccentKey.terracotta));
      expect(Localizations.localeOf(context), const Locale('it'));
      expect(MediaQuery.disableAnimationsOf(context), isFalse);
      expect(MediaQuery.textScalerOf(context).scale(10), 10);
    });

    testWidgets('provides localisations for the requested locale', (
      tester,
    ) async {
      await tester.pumpWidget(
        widgetHost(const SizedBox(), locale: const Locale('en')),
      );

      expect(_context(tester).l10n.localeName, 'en');
    });

    testWidgets('forwards reduced motion and text scale', (tester) async {
      await tester.pumpWidget(
        widgetHost(const SizedBox(), disableAnimations: true, textScale: 2),
      );
      final context = _context(tester);

      expect(MediaQuery.disableAnimationsOf(context), isTrue);
      expect(MediaQuery.textScalerOf(context).scale(10), 20);
    });

    testWidgets('puts the child inside the scaffold body', (tester) async {
      await tester.pumpWidget(widgetHost(const Text('hello')));

      expect(find.text('hello'), findsOneWidget);
    });
  });

  final brightnesses = <Brightness>[];
  forBothThemes('forBothThemes runs the body once per brightness', (
    tester,
    brightness,
  ) async {
    brightnesses.add(brightness);
    await tester.pumpWidget(
      widgetHost(const SizedBox(), brightness: brightness),
    );

    expect(_context(tester).colors.isDark, brightness == Brightness.dark);
  });

  tearDownAll(() {
    expect(brightnesses, unorderedEquals(Brightness.values));
  });
}
