import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/app/app.dart';
import 'package:levelup/l10n/app_localizations.dart';
import 'package:levelup/ui/screens/home_placeholder.dart';

Future<Locale> _pumpWithDeviceLocales(
  WidgetTester tester,
  List<Locale> locales,
) async {
  tester.platformDispatcher.localesTestValue = locales;
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);

  final container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const LevelUpApp()),
  );
  await tester.pumpAndSettle();
  return Localizations.localeOf(tester.element(find.byType(HomePlaceholder)));
}

void main() {
  group('LevelUpApp localization', () {
    testWidgets('Italian device resolves to it with Material strings in it', (
      tester,
    ) async {
      final locale = await _pumpWithDeviceLocales(tester, [
        const Locale('it', 'IT'),
      ]);

      expect(locale.languageCode, 'it');
      final material = MaterialLocalizations.of(
        tester.element(find.byType(HomePlaceholder)),
      );
      expect(material.cancelButtonLabel, 'Annulla');
    });

    testWidgets('English device resolves to en', (tester) async {
      final locale = await _pumpWithDeviceLocales(tester, [
        const Locale('en', 'US'),
      ]);

      expect(locale.languageCode, 'en');
    });

    testWidgets('unsupported device language falls back to en', (tester) async {
      final locale = await _pumpWithDeviceLocales(tester, [
        const Locale('fr', 'FR'),
      ]);

      expect(locale.languageCode, 'en');
    });

    testWidgets('first supported language in the device list wins', (
      tester,
    ) async {
      final locale = await _pumpWithDeviceLocales(tester, [
        const Locale('fr', 'FR'),
        const Locale('it', 'IT'),
      ]);

      expect(locale.languageCode, 'it');
    });

    test('supports exactly it and en', () {
      expect(AppLocalizations.supportedLocales.toSet(), {
        const Locale('it'),
        const Locale('en'),
      });
    });
  });
}
