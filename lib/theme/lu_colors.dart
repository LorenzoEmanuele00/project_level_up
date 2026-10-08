import 'package:flutter/material.dart';
import 'package:levelup/domain/habit_hue.dart';
import 'package:levelup/theme/lu_color_math.dart';

/// Background (tint) and text/icon (ink) colours of a habit hue.
@immutable
class LuHueTone {
  const LuHueTone({required this.tint, required this.ink});

  final Color tint;
  final Color ink;
}

const _white = Color(0xFFFFFFFF);

const _lightBlue = LuHueTone(tint: Color(0xFFC7DFF2), ink: Color(0xFF3F79AD));
const _lightTeal = LuHueTone(tint: Color(0xFFC4E7DD), ink: Color(0xFF2F8171));
const _lightGreen = LuHueTone(tint: Color(0xFFD5E8C1), ink: Color(0xFF5B9243));
const _lightGold = LuHueTone(tint: Color(0xFFF3DB95), ink: Color(0xFF9F7419));

const _darkBlue = LuHueTone(
  tint: Color.fromRGBO(89, 136, 192, .16),
  ink: Color(0xFF6F9ED6),
);
const _darkTeal = LuHueTone(
  tint: Color.fromRGBO(63, 168, 155, .16),
  ink: Color(0xFF54C2B4),
);
const _darkGreen = LuHueTone(
  tint: Color.fromRGBO(91, 156, 111, .16),
  ink: Color(0xFF6FBF87),
);
const _darkGold = LuHueTone(
  tint: Color.fromRGBO(211, 162, 74, .16),
  ink: Color(0xFFD3A24A),
);

/// Semantic colour tokens of the design system (`#t-colori`), for one theme
/// and one accent. Widgets read it through `context.lu`.
@immutable
class LuColors extends ThemeExtension<LuColors> {
  const LuColors({
    required this.isDark,
    required this.bg,
    required this.canvas,
    required this.surface,
    required this.elev,
    required this.line,
    required this.text,
    required this.text2,
    required this.text3,
    required this.onCanvas,
    required this.onCanvas2,
    required this.gold,
    required this.goldSoft,
    required this.accent,
    required this.accent2,
    required this.accentDeep,
    required this.accentSoft,
    required this.accentLine,
    required this.obGlow,
  });

  factory LuColors.light(Color accent) => LuColors(
    isDark: false,
    bg: const Color(0xFFF4F0E4),
    canvas: const Color(0xFFDEDAD1),
    surface: const Color(0xFFFDFBF3),
    elev: const Color(0xFFECE7D8),
    line: const Color.fromRGBO(43, 40, 34, .16),
    text: const Color(0xFF2B2823),
    text2: const Color(0xFF655E50),
    text3: const Color(0xFF80786A),
    onCanvas: const Color(0xFF2B2823),
    onCanvas2: const Color(0xFF5B5549),
    gold: const Color(0xFFB0842F),
    goldSoft: const Color.fromRGBO(176, 132, 47, .14),
    accent: accent,
    accent2: shade(accent, -.12),
    accentDeep: shade(accent, .28),
    accentSoft: accent.withValues(alpha: .09),
    accentLine: accent.withValues(alpha: .32),
    obGlow: accent.withValues(alpha: .12),
  );

  factory LuColors.dark(Color accent) => LuColors(
    isDark: true,
    bg: const Color(0xFF191817),
    canvas: const Color(0xFF0C0C0B),
    surface: const Color(0xFF211F1D),
    elev: const Color(0xFF2B2926),
    line: const Color.fromRGBO(255, 255, 255, .08),
    text: const Color(0xFFEDEDEC),
    text2: const Color(0xFF9B9A96),
    text3: const Color(0xFF6D6C66),
    onCanvas: const Color(0xFFECE8DC),
    onCanvas2: const Color(0xFFA8A294),
    gold: const Color(0xFFD3A24A),
    goldSoft: const Color.fromRGBO(211, 162, 74, .14),
    accent: accent,
    accent2: shade(accent, -.12),
    accentDeep: shade(accent, .28),
    accentSoft: accent.withValues(alpha: .15),
    accentLine: accent.withValues(alpha: .32),
    obGlow: accent.withValues(alpha: .22),
  );

  final bool isDark;
  final Color bg;
  final Color canvas;
  final Color surface;
  final Color elev;
  final Color line;
  final Color text;
  final Color text2;
  final Color text3;
  final Color onCanvas;
  final Color onCanvas2;
  final Color gold;
  final Color goldSoft;
  final Color accent;
  final Color accent2;
  final Color accentDeep;
  final Color accentSoft;
  final Color accentLine;
  final Color obGlow;

  /// Every colour token by name. Light and dark expose the same names.
  Map<String, Color> get tokens => {
    'bg': bg,
    'canvas': canvas,
    'surface': surface,
    'elev': elev,
    'line': line,
    'text': text,
    'text2': text2,
    'text3': text3,
    'onCanvas': onCanvas,
    'onCanvas2': onCanvas2,
    'gold': gold,
    'goldSoft': goldSoft,
    'accent': accent,
    'accent2': accent2,
    'accentDeep': accentDeep,
    'accentSoft': accentSoft,
    'accentLine': accentLine,
    'obGlow': obGlow,
  };

  /// Tint/ink pair of a habit hue. `red` follows the accent; the others are
  /// fixed and only depend on the theme.
  LuHueTone hue(HabitHue key) => switch (key) {
    HabitHue.red => _redTone(),
    HabitHue.blue => isDark ? _darkBlue : _lightBlue,
    HabitHue.teal => isDark ? _darkTeal : _lightTeal,
    HabitHue.green => isDark ? _darkGreen : _lightGreen,
    HabitHue.gold => isDark ? _darkGold : _lightGold,
  };

  // The design system only gives the light values for the terra accent, so
  // for the other accents the tint/ink pair is derived (see Domande Aperte).
  LuHueTone _redTone() => isDark
      ? LuHueTone(tint: accent.withValues(alpha: .15), ink: accent)
      : LuHueTone(
          tint: Color.lerp(accent, _white, .70) ?? accent,
          ink: shade(accent, .12),
        );

  @override
  LuColors copyWith({
    bool? isDark,
    Color? bg,
    Color? canvas,
    Color? surface,
    Color? elev,
    Color? line,
    Color? text,
    Color? text2,
    Color? text3,
    Color? onCanvas,
    Color? onCanvas2,
    Color? gold,
    Color? goldSoft,
    Color? accent,
    Color? accent2,
    Color? accentDeep,
    Color? accentSoft,
    Color? accentLine,
    Color? obGlow,
  }) => LuColors(
    isDark: isDark ?? this.isDark,
    bg: bg ?? this.bg,
    canvas: canvas ?? this.canvas,
    surface: surface ?? this.surface,
    elev: elev ?? this.elev,
    line: line ?? this.line,
    text: text ?? this.text,
    text2: text2 ?? this.text2,
    text3: text3 ?? this.text3,
    onCanvas: onCanvas ?? this.onCanvas,
    onCanvas2: onCanvas2 ?? this.onCanvas2,
    gold: gold ?? this.gold,
    goldSoft: goldSoft ?? this.goldSoft,
    accent: accent ?? this.accent,
    accent2: accent2 ?? this.accent2,
    accentDeep: accentDeep ?? this.accentDeep,
    accentSoft: accentSoft ?? this.accentSoft,
    accentLine: accentLine ?? this.accentLine,
    obGlow: obGlow ?? this.obGlow,
  );

  @override
  LuColors lerp(ThemeExtension<LuColors>? other, double t) {
    if (other is! LuColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return LuColors(
      isDark: t < .5 ? isDark : other.isDark,
      bg: mix(bg, other.bg),
      canvas: mix(canvas, other.canvas),
      surface: mix(surface, other.surface),
      elev: mix(elev, other.elev),
      line: mix(line, other.line),
      text: mix(text, other.text),
      text2: mix(text2, other.text2),
      text3: mix(text3, other.text3),
      onCanvas: mix(onCanvas, other.onCanvas),
      onCanvas2: mix(onCanvas2, other.onCanvas2),
      gold: mix(gold, other.gold),
      goldSoft: mix(goldSoft, other.goldSoft),
      accent: mix(accent, other.accent),
      accent2: mix(accent2, other.accent2),
      accentDeep: mix(accentDeep, other.accentDeep),
      accentSoft: mix(accentSoft, other.accentSoft),
      accentLine: mix(accentLine, other.accentLine),
      obGlow: mix(obGlow, other.obGlow),
    );
  }
}
