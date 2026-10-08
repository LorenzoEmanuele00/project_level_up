import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup/domain/enums.dart';

/// Theme choice of the user: light/dark and accent.
///
/// Held in memory for now. Persistence on the hero comes with the profile
/// settings card.
@immutable
class ThemeSettings {
  const ThemeSettings({required this.brightness, required this.accent});

  final Brightness brightness;
  final AccentKey accent;

  ThemeSettings copyWith({Brightness? brightness, AccentKey? accent}) =>
      ThemeSettings(
        brightness: brightness ?? this.brightness,
        accent: accent ?? this.accent,
      );

  @override
  bool operator ==(Object other) =>
      other is ThemeSettings &&
      other.brightness == brightness &&
      other.accent == accent;

  @override
  int get hashCode => Object.hash(brightness, accent);
}

class ThemeSettingsNotifier extends Notifier<ThemeSettings> {
  @override
  ThemeSettings build() => const ThemeSettings(
    brightness: Brightness.light,
    accent: AccentKey.terra,
  );

  void setAccent(AccentKey accent) => state = state.copyWith(accent: accent);

  void setBrightness(Brightness brightness) =>
      state = state.copyWith(brightness: brightness);
}

final themeSettingsProvider =
    NotifierProvider<ThemeSettingsNotifier, ThemeSettings>(
      ThemeSettingsNotifier.new,
    );
