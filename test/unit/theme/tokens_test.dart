import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/tokens.dart';

void main() {
  group('Spacing', () {
    test('exposes the 4-based spacing scale from the design system', () {
      expect(
        [
          Spacing.xs,
          Spacing.sm,
          Spacing.md,
          Spacing.lg,
          Spacing.xl,
          Spacing.x2,
          Spacing.x3,
        ],
        [4.0, 8.0, 12.0, 16.0, 20.0, 24.0, 32.0],
      );
    });

    test('uses 11 as habit grid gap', () {
      expect(Spacing.gridGap, 11.0);
    });
  });

  group('Radii', () {
    test('exposes the radius scale from the design system', () {
      expect(
        [
          Radii.bar,
          Radii.chip,
          Radii.field,
          Radii.cta,
          Radii.card,
          Radii.tile,
          Radii.sheet,
          Radii.hero,
        ],
        [6.0, 10.0, 14.0, 16.0, 18.0, 22.0, 26.0, 30.0],
      );
    });
  });

  group('Shadows', () {
    test('ctaGlow is 0 12 30 -8 in the given accent colour', () {
      const accent = Color(0xFFD9614C);

      final shadow = Shadows.ctaGlow(accent).single;

      expect(shadow.offset, const Offset(0, 12));
      expect(shadow.blurRadius, 30);
      expect(shadow.spreadRadius, -8);
      expect(shadow.color, accent);
    });

    test('medal is 0 6 14 -7 in the given colour', () {
      const tone = Color(0xFFD3A24A);

      final shadow = Shadows.medal(tone).single;

      expect(shadow.offset, const Offset(0, 6));
      expect(shadow.blurRadius, 14);
      expect(shadow.spreadRadius, -7);
      expect(shadow.color, tone);
    });

    test('tabActive is 0 2 8 -3 black at alpha .4', () {
      final shadow = Shadows.tabActive.single;

      expect(shadow.offset, const Offset(0, 2));
      expect(shadow.blurRadius, 8);
      expect(shadow.spreadRadius, -3);
      expect(shadow.color.a, closeTo(.4, .001));
    });

    test('float is 0 20 50 -14 black at alpha .5', () {
      final shadow = Shadows.float.single;

      expect(shadow.offset, const Offset(0, 20));
      expect(shadow.blurRadius, 50);
      expect(shadow.spreadRadius, -14);
      expect(shadow.color.a, closeTo(.5, .001));
    });
  });

  group('Motion curves', () {
    void expectCubic(Curve curve, List<double> abcd) {
      final cubic = curve as Cubic;
      expect([cubic.a, cubic.b, cubic.c, cubic.d], abcd);
    }

    test('spring is cubic(.34, 1.56, .5, 1)', () {
      expectCubic(Motion.spring, [.34, 1.56, .5, 1]);
    });

    test('out is cubic(.2, .8, .2, 1)', () {
      expectCubic(Motion.out, [.2, .8, .2, 1]);
    });

    test('pop is cubic(.2, .9, .3, 1.25)', () {
      expectCubic(Motion.pop, [.2, .9, .3, 1.25]);
    });

    test('apple is cubic(.32, .72, 0, 1)', () {
      expectCubic(Motion.apple, [.32, .72, 0, 1]);
    });
  });

  group('Motion durations', () {
    test('spring lasts 180-200 ms', () {
      expect(Motion.springShort.inMilliseconds, 180);
      expect(Motion.springLong.inMilliseconds, 200);
    });

    test('out lasts 300-500 ms', () {
      expect(Motion.outShort.inMilliseconds, 300);
      expect(Motion.outLong.inMilliseconds, 500);
    });

    test('pop lasts 450-600 ms', () {
      expect(Motion.popShort.inMilliseconds, 450);
      expect(Motion.popLong.inMilliseconds, 600);
    });

    test('apple lasts 500-550 ms', () {
      expect(Motion.appleShort.inMilliseconds, 500);
      expect(Motion.appleLong.inMilliseconds, 550);
    });
  });
}
