import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/color_math.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/palettes.dart';

/// Asserts that [actual] has the RGB channels described by [hex] (0xRRGGBB)
/// within [tolerance] per channel (0..1). Alpha is checked separately.
void expectRgb(Color actual, int hex, {double tolerance = .004}) {
  expect(actual.r, closeTo(((hex >> 16) & 0xFF) / 255, tolerance));
  expect(actual.g, closeTo(((hex >> 8) & 0xFF) / 255, tolerance));
  expect(actual.b, closeTo((hex & 0xFF) / 255, tolerance));
}

void main() {
  final terra = Palettes.accent(AccentKey.terra);
  final light = AppColors.light(terra);
  final dark = AppColors.dark(terra);

  group('AppColors semantic tokens (#t-colori)', () {
    test('light theme matches the design system table', () {
      expectRgb(light.bg, 0xF4F0E4);
      expectRgb(light.canvas, 0xDEDAD1);
      expectRgb(light.surface, 0xFDFBF3);
      expectRgb(light.elev, 0xECE7D8);
      expectRgb(light.text, 0x2B2823);
      expectRgb(light.text2, 0x655E50);
      expectRgb(light.text3, 0x80786A);
      expectRgb(light.onCanvas, 0x2B2823);
      expectRgb(light.onCanvas2, 0x5B5549);
      expectRgb(light.gold, 0xB0842F);
    });

    test('dark theme matches the design system table', () {
      expectRgb(dark.bg, 0x191817);
      expectRgb(dark.canvas, 0x0C0C0B);
      expectRgb(dark.surface, 0x211F1D);
      expectRgb(dark.elev, 0x2B2926);
      expectRgb(dark.text, 0xEDEDEC);
      expectRgb(dark.text2, 0x9B9A96);
      expectRgb(dark.text3, 0x6D6C66);
      expectRgb(dark.onCanvas, 0xECE8DC);
      expectRgb(dark.onCanvas2, 0xA8A294);
      expectRgb(dark.gold, 0xD3A24A);
    });

    test('line is a translucent border colour in both themes', () {
      expectRgb(light.line, 0x2B2822);
      expect(light.line.a, closeTo(.16, .005));
      expectRgb(dark.line, 0xFFFFFF);
      expect(dark.line.a, closeTo(.08, .005));
    });

    test('goldSoft is gold at alpha .14 in both themes', () {
      expectRgb(light.goldSoft, 0xB0842F);
      expect(light.goldSoft.a, closeTo(.14, .005));
      expectRgb(dark.goldSoft, 0xD3A24A);
      expect(dark.goldSoft.a, closeTo(.14, .005));
    });

    test('light and dark expose exactly the same token names', () {
      expect(light.tokens.keys.toSet(), dark.tokens.keys.toSet());
    });

    test('exposes the 17 design tokens plus obGlow', () {
      expect(light.tokens.keys.toSet(), {
        'bg',
        'surface',
        'elev',
        'line',
        'text',
        'text2',
        'text3',
        'gold',
        'goldSoft',
        'canvas',
        'onCanvas',
        'onCanvas2',
        'accent',
        'accent2',
        'accentDeep',
        'accentSoft',
        'accentLine',
        'obGlow',
      });
    });
  });

  group('AppColors accent derivatives (#t-accenti)', () {
    test('accent is the colour passed to the factory', () {
      expect(light.accent, terra);
      expect(dark.accent, terra);
    });

    test('accentDeep is the accent darkened by 28%', () {
      expect(light.accentDeep, shade(terra, .28));
      expect(dark.accentDeep, shade(terra, .28));
    });

    test('accent2 is the accent lightened by 12%', () {
      expect(light.accent2, shade(terra, -.12));
    });

    test('accentSoft is accent at alpha .09 light and .15 dark', () {
      expect(light.accentSoft.a, closeTo(.09, .005));
      expect(dark.accentSoft.a, closeTo(.15, .005));
      expectRgb(light.accentSoft, 0xD9614C);
    });

    test('accentLine is accent at alpha .32 in both themes', () {
      expect(light.accentLine.a, closeTo(.32, .005));
      expect(dark.accentLine.a, closeTo(.32, .005));
    });

    test('obGlow is accent at alpha .12 light and .22 dark', () {
      expect(light.obGlow.a, closeTo(.12, .005));
      expect(dark.obGlow.a, closeTo(.22, .005));
    });

    test('derivatives follow every accent palette', () {
      for (final key in AccentKey.values) {
        final accent = Palettes.accent(key);

        final colors = AppColors.light(accent);

        expect(colors.accent, accent, reason: key.name);
        expect(colors.accentDeep, shade(accent, .28), reason: key.name);
      }
    });
  });

  group('AppColors habit hues (#t-hue)', () {
    test('blue, teal, green and gold are fixed in the light theme', () {
      expectRgb(light.hue(HabitHue.blue).tint, 0xC7DFF2);
      expectRgb(light.hue(HabitHue.blue).ink, 0x3F79AD);
      expectRgb(light.hue(HabitHue.teal).tint, 0xC4E7DD);
      expectRgb(light.hue(HabitHue.teal).ink, 0x2F8171);
      expectRgb(light.hue(HabitHue.green).tint, 0xD5E8C1);
      expectRgb(light.hue(HabitHue.green).ink, 0x5B9243);
      expectRgb(light.hue(HabitHue.gold).tint, 0xF3DB95);
      expectRgb(light.hue(HabitHue.gold).ink, 0x9F7419);
    });

    test('blue, teal, green and gold are fixed in the dark theme', () {
      expectRgb(dark.hue(HabitHue.blue).tint, 0x5988C0);
      expect(dark.hue(HabitHue.blue).tint.a, closeTo(.16, .005));
      expectRgb(dark.hue(HabitHue.blue).ink, 0x6F9ED6);
      expectRgb(dark.hue(HabitHue.teal).ink, 0x54C2B4);
      expectRgb(dark.hue(HabitHue.green).ink, 0x6FBF87);
      expectRgb(dark.hue(HabitHue.gold).ink, 0xD3A24A);
    });

    test('fixed hues do not change with the accent', () {
      final other = AppColors.light(Palettes.accent(AccentKey.ardesia));

      expect(other.hue(HabitHue.teal).tint, light.hue(HabitHue.teal).tint);
      expect(other.hue(HabitHue.teal).ink, light.hue(HabitHue.teal).ink);
    });

    test('dark red hue is the accent at alpha .15 with accent ink', () {
      final tone = dark.hue(HabitHue.red);

      expectRgb(tone.tint, 0xD9614C);
      expect(tone.tint.a, closeTo(.15, .005));
      expect(tone.ink, terra);
    });

    test('light red hue stays close to the design system values for terra', () {
      final tone = light.hue(HabitHue.red);

      expectRgb(tone.tint, 0xF6D6C1, tolerance: .06);
      expectRgb(tone.ink, 0xC0562B, tolerance: .1);
    });

    test('red hue follows the accent', () {
      final salvia = AppColors.dark(Palettes.accent(AccentKey.salvia));

      expect(salvia.hue(HabitHue.red).ink, Palettes.accent(AccentKey.salvia));
    });
  });

  group('AppColors as ThemeExtension', () {
    test('copyWith replaces only the given token', () {
      final copy = light.copyWith(bg: const Color(0xFF123456));

      expect(copy.bg, const Color(0xFF123456));
      expect(copy.surface, light.surface);
      expect(copy.accent, light.accent);
    });

    test('lerp at 0 returns this and at 1 returns the other', () {
      expect(light.lerp(dark, 0).bg, light.bg);
      expect(light.lerp(dark, 1).bg, dark.bg);
    });

    test('lerp with a non AppColors value returns this', () {
      expect(light.lerp(null, .5), same(light));
    });

    test('lerp at the midpoint blends tokens', () {
      final mid = light.lerp(dark, .5);

      expect(mid.bg, Color.lerp(light.bg, dark.bg, .5));
    });
  });
}
