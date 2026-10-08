import 'package:flutter/material.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/palettes.dart';

const _onAccent = Color(0xFFFFFFFF);

/// Builds the whole [ThemeData] from the theme brightness and the accent.
/// Called again whenever either changes, so every token is rebuilt.
ThemeData buildTheme(Brightness brightness, AccentKey accentKey) {
  final accent = Palettes.accent(accentKey);
  final colors = brightness == Brightness.dark
      ? AppColors.dark(accent)
      : AppColors.light(accent);

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'SpaceMono',
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: _onAccent,
      secondary: colors.accent2,
      onSecondary: _onAccent,
      // The design system defines no error token: placeholder until the
      // form cards (habit, reward, registration) decide how errors look.
      error: colors.accentDeep,
      onError: _onAccent,
      surface: colors.surface,
      onSurface: colors.text,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: colors.bg,
    textTheme: base.textTheme.apply(
      bodyColor: colors.text,
      displayColor: colors.text,
    ),
    extensions: <ThemeExtension<dynamic>>[colors],
  );
}

extension AppColorsContext on BuildContext {
  /// The design system colour tokens of the active theme.
  AppColors get colors {
    final colors = Theme.of(this).extension<AppColors>();
    if (colors == null) {
      throw StateError('AppColors missing: build the theme with buildTheme.');
    }
    return colors;
  }
}
