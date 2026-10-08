import 'package:flutter/material.dart';
import 'package:levelup/domain/accent_key.dart';
import 'package:levelup/theme/lu_colors.dart';
import 'package:levelup/theme/lu_palettes.dart';

const _onAccent = Color(0xFFFFFFFF);

/// Builds the whole [ThemeData] from the theme brightness and the accent.
/// Called again whenever either changes, so every token is rebuilt.
ThemeData buildLuTheme(Brightness brightness, AccentKey accentKey) {
  final accent = LuPalettes.accent(accentKey);
  final colors = brightness == Brightness.dark
      ? LuColors.dark(accent)
      : LuColors.light(accent);

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

extension LuBuildContext on BuildContext {
  /// The design system colour tokens of the active theme.
  LuColors get lu {
    final colors = Theme.of(this).extension<LuColors>();
    if (colors == null) {
      throw StateError('LuColors missing: build the theme with buildLuTheme.');
    }
    return colors;
  }
}
