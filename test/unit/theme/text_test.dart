import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/text.dart';

void main() {
  group('AppText', () {
    test('display is 52 / 700 / height 1 / -2% tracking', () {
      expect(AppText.display.fontSize, 52);
      expect(AppText.display.fontWeight, FontWeight.w700);
      expect(AppText.display.height, 1);
      expect(AppText.display.letterSpacing, closeTo(-1.04, .001));
    });

    test('title is 27 / 700 / height 1.15', () {
      expect(AppText.title.fontSize, 27);
      expect(AppText.title.fontWeight, FontWeight.w700);
      expect(AppText.title.height, 1.15);
    });

    test('section is 21 / 700', () {
      expect(AppText.section.fontSize, 21);
      expect(AppText.section.fontWeight, FontWeight.w700);
    });

    test('body is 14 / 400 / height 1.5', () {
      expect(AppText.body.fontSize, 14);
      expect(AppText.body.fontWeight, FontWeight.w400);
      expect(AppText.body.height, 1.5);
    });

    test('overline is 12 / 700 with +14% tracking', () {
      expect(AppText.overline.fontSize, 12);
      expect(AppText.overline.fontWeight, FontWeight.w700);
      expect(AppText.overline.letterSpacing, closeTo(1.68, .001));
    });

    test('remaining scale entries follow the typography table', () {
      expect(AppText.levelXl.fontSize, 42);
      expect(AppText.sheetTitle.fontSize, 16);
      expect(AppText.label.fontSize, 14);
      expect(AppText.label.fontWeight, FontWeight.w700);
      expect(AppText.caption.fontSize, 12);
      expect(AppText.caption.fontWeight, FontWeight.w400);
      expect(AppText.micro.fontSize, 10);
    });

    test('every style uses the SpaceMono family and nothing else', () {
      for (final style in AppText.all) {
        expect(style.fontFamily, 'SpaceMono');
      }
    });

    test('styles carry no colour (applied by the component)', () {
      for (final style in AppText.all) {
        expect(style.color, isNull);
      }
    });

    test('upper upper-cases overline copy', () {
      expect(AppText.upper('passo 1 · il tuo eroe'), 'PASSO 1 · IL TUO EROE');
    });

    test('new scale entries follow the Home component table', () {
      expect(AppText.statLabel.fontSize, 9);
      expect(AppText.statLabel.fontWeight, FontWeight.w400);
      expect(AppText.statLabel.letterSpacing, closeTo(.27, .001));
      expect(AppText.tag.fontSize, 11);
      expect(AppText.tag.fontWeight, FontWeight.w700);
      expect(AppText.small.fontSize, 11);
      expect(AppText.small.fontWeight, FontWeight.w400);
      expect(AppText.emphasis.fontSize, 15);
      expect(AppText.emphasis.fontWeight, FontWeight.w700);
      expect(AppText.statValue.fontSize, 18);
      expect(AppText.statValue.fontWeight, FontWeight.w700);
    });

    test('new styles are part of AppText.all', () {
      expect(
        AppText.all,
        containsAll([
          AppText.statLabel,
          AppText.tag,
          AppText.small,
          AppText.emphasis,
          AppText.statValue,
        ]),
      );
    });
  });
}
