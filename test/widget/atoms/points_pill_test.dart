import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/points_pill.dart';

import '../../helpers/widget_host.dart';

AppColors _colors(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(PointsPill))).extension<AppColors>()!;

Finder get _text =>
    find.descendant(of: find.byType(PointsPill), matching: find.byType(Text));

Finder get _pill => find.descendant(
  of: find.byType(PointsPill),
  matching: find.byWidgetPredicate(
    (w) =>
        w is DecoratedBox &&
        (w.decoration as BoxDecoration).borderRadius != null,
  ),
);

void main() {
  group('PointsPill value', () {
    testWidgets('formats thousands for Italian', (tester) async {
      await tester.pumpWidget(widgetHost(const PointsPill(value: 1250)));

      expect(tester.widget<Text>(_text).data, '1.250');
    });

    testWidgets('formats thousands for English', (tester) async {
      await tester.pumpWidget(
        widgetHost(const PointsPill(value: 1250), locale: const Locale('en')),
      );

      expect(tester.widget<Text>(_text).data, '1,250');
    });

    testWidgets('999999 fits a narrow row without overflow', (tester) async {
      await tester.pumpWidget(
        widgetHost(
          const SizedBox(width: 130, child: PointsPill(value: 999999)),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.widget<Text>(_text).data, '999.999');
    });
  });

  group('PointsPill look', () {
    forBothThemes('elev fill, radius 14, gold gem and value', (
      tester,
      brightness,
    ) async {
      await tester.pumpWidget(
        widgetHost(const PointsPill(value: 40), brightness: brightness),
      );
      final colors = _colors(tester);

      final decoration =
          tester.widget<DecoratedBox>(_pill).decoration as BoxDecoration;
      final style = tester.widget<Text>(_text).style!;
      final gem = tester.widget<SvgPicture>(find.byType(SvgPicture));

      expect(decoration.color, colors.elev);
      expect(decoration.borderRadius, BorderRadius.circular(14));
      expect(style.color, colors.gold);
      expect(style.fontSize, 15);
      expect(style.fontWeight, FontWeight.w700);
      expect(gem.colorFilter, ColorFilter.mode(colors.gold, BlendMode.srcIn));
      expect(tester.getSize(find.byType(SvgPicture)), const Size.square(18));
    });

    testWidgets('pads 9 by 14 with a 7 gap between gem and value', (
      tester,
    ) async {
      await tester.pumpWidget(widgetHost(const PointsPill(value: 40)));

      final pill = tester.getRect(_pill);
      final gem = tester.getRect(find.byType(SvgPicture));
      final text = tester.getRect(_text);

      expect(gem.left - pill.left, 14);
      expect(text.left - gem.right, 7);
      expect(pill.right - text.right, 14);
      expect(gem.top - pill.top, greaterThanOrEqualTo(9));
    });
  });

  group('PointsPill tap', () {
    testWidgets('touch area is at least 44 tall', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        widgetHost(PointsPill(value: 40, onTap: () => taps++)),
      );

      expect(
        tester.getSize(find.byType(PointsPill)).height,
        greaterThanOrEqualTo(AppSizes.minTapTarget),
      );
      await tester.tap(find.byType(PointsPill));
      expect(taps, 1);
    });

    testWidgets('meets the iOS tap target guideline', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(widgetHost(PointsPill(value: 40, onTap: () {})));

      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('shrinks to .965 while pressed', (tester) async {
      await tester.pumpWidget(widgetHost(PointsPill(value: 40, onTap: () {})));

      await tester.startGesture(tester.getCenter(find.byType(PointsPill)));
      await tester.pump();

      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scale.scale, Motion.pressScaleLarge);
    });

    testWidgets('without onTap it is inert', (tester) async {
      await tester.pumpWidget(widgetHost(const PointsPill(value: 40)));

      await tester.startGesture(tester.getCenter(find.byType(PointsPill)));
      await tester.pump();

      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scale.scale, 1);
    });
  });
}
