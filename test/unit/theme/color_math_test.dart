import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/color_math.dart';

void main() {
  const white = Color(0xFFFFFFFF);
  const black = Color(0xFF000000);

  group('shade', () {
    test('returns the same colour when amount is 0', () {
      const colour = Color(0xFFD9614C);

      expect(shade(colour, 0), colour);
    });

    test('darkens towards black by the given fraction when positive', () {
      final result = shade(white, .28);

      expect(result.r, closeTo(.72, .005));
      expect(result.g, closeTo(.72, .005));
      expect(result.b, closeTo(.72, .005));
    });

    test('lightens towards white by the given fraction when negative', () {
      final result = shade(black, -.12);

      expect(result.r, closeTo(.12, .005));
      expect(result.g, closeTo(.12, .005));
      expect(result.b, closeTo(.12, .005));
    });

    test('keeps the colour fully opaque', () {
      expect(shade(const Color(0xFF5B9C6F), .28).a, 1.0);
    });

    test('darkening never makes a channel brighter', () {
      const colour = Color(0xFFCF9C4D);

      final result = shade(colour, .28);

      expect(result.r, lessThan(colour.r));
      expect(result.g, lessThan(colour.g));
      expect(result.b, lessThan(colour.b));
    });
  });
}
