import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/state/theme_settings.dart';

ProviderContainer _container() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('themeSettingsProvider', () {
    test('starts with the light theme and the terracotta accent', () {
      final container = _container();

      final settings = container.read(themeSettingsProvider);

      expect(settings.brightness, Brightness.light);
      expect(settings.accent, AccentKey.terracotta);
    });

    test('setAccent updates only the accent', () {
      final container = _container();

      container.read(themeSettingsProvider.notifier).setAccent(AccentKey.rose);

      final settings = container.read(themeSettingsProvider);
      expect(settings.accent, AccentKey.rose);
      expect(settings.brightness, Brightness.light);
    });

    test('setBrightness updates only the brightness', () {
      final container = _container();

      container
          .read(themeSettingsProvider.notifier)
          .setBrightness(Brightness.dark);

      final settings = container.read(themeSettingsProvider);
      expect(settings.brightness, Brightness.dark);
      expect(settings.accent, AccentKey.terracotta);
    });

    test('updates produce a new immutable value', () {
      final container = _container();
      final before = container.read(themeSettingsProvider);

      container.read(themeSettingsProvider.notifier).setAccent(AccentKey.amber);

      final after = container.read(themeSettingsProvider);
      expect(after, isNot(same(before)));
      expect(before.accent, AccentKey.terracotta);
    });

    test('ThemeSettings has value equality', () {
      const a = ThemeSettings(
        brightness: Brightness.light,
        accent: AccentKey.terracotta,
      );
      const b = ThemeSettings(
        brightness: Brightness.light,
        accent: AccentKey.terracotta,
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
