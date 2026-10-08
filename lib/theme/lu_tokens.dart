import 'package:flutter/widgets.dart';

/// Spacing scale (base 4).
abstract final class LuSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const x2 = 24.0;
  static const x3 = 32.0;

  /// Gap of the two-column habit grid.
  static const gridGap = 11.0;
}

/// Corner radii.
abstract final class LuRadius {
  static const bar = 6.0;
  static const chip = 10.0;
  static const field = 14.0;
  static const cta = 16.0;
  static const card = 18.0;
  static const tile = 22.0;
  static const sheet = 26.0;
  static const hero = 30.0;
}

/// Shadows and glows. Colours are passed in so they follow the theme.
abstract final class LuShadow {
  static List<BoxShadow> ctaGlow(Color accent) => [
    BoxShadow(
      color: accent,
      offset: const Offset(0, 12),
      blurRadius: 30,
      spreadRadius: -8,
    ),
  ];

  /// Drop shadow under a medal. The 2 px inset ring is drawn by the medal.
  static List<BoxShadow> medal(Color tone) => [
    BoxShadow(
      color: tone,
      offset: const Offset(0, 6),
      blurRadius: 14,
      spreadRadius: -7,
    ),
  ];

  static const tabActive = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, .4),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: -3,
    ),
  ];

  static const float = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, .5),
      offset: Offset(0, 20),
      blurRadius: 50,
      spreadRadius: -14,
    ),
  ];
}

/// Curves and durations. Honour reduced motion through [duration].
abstract final class LuMotion {
  /// Press feedback.
  static const spring = Cubic(.34, 1.56, .5, 1);

  /// Sheets, bars, rings.
  static const out = Cubic(.2, .8, .2, 1);

  /// Overlays and level up.
  static const pop = Cubic(.2, .9, .3, 1.25);

  /// Screen entrances and list staggering.
  static const apple = Cubic(.32, .72, 0, 1);

  static const springShort = Duration(milliseconds: 180);
  static const springLong = Duration(milliseconds: 200);
  static const outShort = Duration(milliseconds: 300);
  static const outLong = Duration(milliseconds: 500);
  static const popShort = Duration(milliseconds: 450);
  static const popLong = Duration(milliseconds: 600);
  static const appleShort = Duration(milliseconds: 500);
  static const appleLong = Duration(milliseconds: 550);

  /// Replaces pop/confetti animations when animations are disabled.
  static const reducedFade = Duration(milliseconds: 150);

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// [normal], or a 150 ms fade when the platform asks for reduced motion.
  static Duration duration(BuildContext context, Duration normal) =>
      reduced(context) ? reducedFade : normal;
}
