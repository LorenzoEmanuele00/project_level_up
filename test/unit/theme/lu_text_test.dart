import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/lu_text.dart';

void main() {
  group('LuText', () {
    test('display is 52 / 700 / height 1 / -2% tracking', () {
      expect(LuText.display.fontSize, 52);
      expect(LuText.display.fontWeight, FontWeight.w700);
      expect(LuText.display.height, 1);
      expect(LuText.display.letterSpacing, closeTo(-1.04, .001));
    });

    test('title is 27 / 700 / height 1.15', () {
      expect(LuText.title.fontSize, 27);
      expect(LuText.title.fontWeight, FontWeight.w700);
      expect(LuText.title.height, 1.15);
    });

    test('section is 21 / 700', () {
      expect(LuText.section.fontSize, 21);
      expect(LuText.section.fontWeight, FontWeight.w700);
    });

    test('body is 14 / 400 / height 1.5', () {
      expect(LuText.body.fontSize, 14);
      expect(LuText.body.fontWeight, FontWeight.w400);
      expect(LuText.body.height, 1.5);
    });

    test('overline is 12 / 700 with +14% tracking', () {
      expect(LuText.overline.fontSize, 12);
      expect(LuText.overline.fontWeight, FontWeight.w700);
      expect(LuText.overline.letterSpacing, closeTo(1.68, .001));
    });

    test('remaining scale entries follow the typography table', () {
      expect(LuText.levelXl.fontSize, 42);
      expect(LuText.sheetTitle.fontSize, 16);
      expect(LuText.label.fontSize, 14);
      expect(LuText.label.fontWeight, FontWeight.w700);
      expect(LuText.caption.fontSize, 12);
      expect(LuText.caption.fontWeight, FontWeight.w400);
      expect(LuText.micro.fontSize, 10);
    });

    test('every style uses the SpaceMono family and nothing else', () {
      for (final style in LuText.all) {
        expect(style.fontFamily, 'SpaceMono');
      }
    });

    test('styles carry no colour (applied by the component)', () {
      for (final style in LuText.all) {
        expect(style.color, isNull);
      }
    });

    test('upper upper-cases overline copy', () {
      expect(LuText.upper('passo 1 · il tuo eroe'), 'PASSO 1 · IL TUO EROE');
    });
  });
}
