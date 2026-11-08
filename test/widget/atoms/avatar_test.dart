import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/avatar.dart';
import 'package:levelup/ui/atoms/progress_ring.dart';
import 'package:levelup/ui/motion/pressable.dart';

import '../../helpers/widget_host.dart';

AppColors _colors(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(Avatar))).extension<AppColors>()!;

Finder get _initialText =>
    find.descendant(of: find.byType(Avatar), matching: find.byType(Text));

String _initial(WidgetTester tester) => tester.widget<Text>(_initialText).data!;

Finder get _disc => find.descendant(
  of: find.byType(Avatar),
  matching: find.byWidgetPredicate(
    (w) =>
        w is DecoratedBox && (w.decoration as BoxDecoration).gradient != null,
  ),
);

void main() {
  group('Avatar initial', () {
    testWidgets('shows the first letter in upper case', (tester) async {
      await tester.pumpWidget(widgetHost(const Avatar(name: 'marco')));

      expect(_initial(tester), 'M');
    });

    testWidgets('keeps a multi-codepoint grapheme whole', (tester) async {
      await tester.pumpWidget(widgetHost(const Avatar(name: '👨‍👩‍👧 Rossi')));

      expect(_initial(tester), '👨‍👩‍👧');
    });

    testWidgets('trims leading spaces', (tester) async {
      await tester.pumpWidget(widgetHost(const Avatar(name: '  àda')));

      expect(_initial(tester), 'À');
    });

    for (final name in ['', '   ']) {
      testWidgets('falls back to E for "$name"', (tester) async {
        await tester.pumpWidget(widgetHost(Avatar(name: name)));

        expect(_initial(tester), 'E');
      });
    }

    testWidgets('initial is 14/700 in onAccent', (tester) async {
      await tester.pumpWidget(widgetHost(const Avatar(name: 'Ada')));

      final style = tester.widget<Text>(_initialText).style!;

      expect(style.fontSize, 14);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.color, _colors(tester).onAccent);
    });
  });

  group('Avatar icon mode', () {
    testWidgets('shows the icon at 56% of the disc', (tester) async {
      await tester.pumpWidget(
        widgetHost(
          const Avatar(name: 'Ada', mode: AvatarMode.icon, icon: 'rocket'),
        ),
      );

      expect(_initialText, findsNothing);
      final side = tester.getSize(_disc).width;
      expect(
        tester.getSize(find.byType(SvgPicture)).width,
        closeTo(side * .56, .01),
      );
    });

    testWidgets('without an icon falls back to the initial', (tester) async {
      await tester.pumpWidget(
        widgetHost(const Avatar(name: 'Ada', mode: AvatarMode.icon)),
      );

      expect(_initial(tester), 'A');
      expect(find.byType(SvgPicture), findsNothing);
    });
  });

  group('Avatar look', () {
    testWidgets('is 46 wide, enough to tap', (tester) async {
      await tester.pumpWidget(widgetHost(const Avatar(name: 'Ada')));

      final size = tester.getSize(find.byType(Avatar));

      expect(size, const Size.square(46));
      expect(size.shortestSide, greaterThanOrEqualTo(AppSizes.minTapTarget));
    });

    forBothThemes('disc is a 155 degree accent to accentDeep gradient', (
      tester,
      brightness,
    ) async {
      await tester.pumpWidget(
        widgetHost(const Avatar(name: 'Ada'), brightness: brightness),
      );
      final colors = _colors(tester);

      final decoration =
          tester.widget<DecoratedBox>(_disc).decoration as BoxDecoration;
      final gradient = decoration.gradient! as LinearGradient;
      const angle = 155 * math.pi / 180;

      expect(gradient.colors, [colors.accent, colors.accentDeep]);
      expect(gradient.begin, Alignment(-math.sin(angle), math.cos(angle)));
      expect(gradient.end, Alignment(math.sin(angle), -math.cos(angle)));
      expect(
        (decoration.border! as Border).top,
        BorderSide(color: colors.surface, width: 3),
      );
    });

    testWidgets('has no ring without expProgress', (tester) async {
      await tester.pumpWidget(widgetHost(const Avatar(name: 'Ada')));

      expect(find.byType(ProgressRing), findsNothing);
    });

    forBothThemes('ring is 3 thick, accent on an elev track', (
      tester,
      brightness,
    ) async {
      await tester.pumpWidget(
        widgetHost(
          const Avatar(name: 'Ada', expProgress: .4),
          brightness: brightness,
        ),
      );
      final colors = _colors(tester);

      final ring = tester.widget<ProgressRing>(find.byType(ProgressRing));

      expect(ring.value, .4);
      expect(ring.size, 46);
      expect(ring.strokeWidth, 3);
      expect(ring.color, colors.accent);
      expect(ring.trackColor, colors.elev);
      expect(tester.getSize(find.byType(Avatar)), const Size.square(46));
    });
  });

  group('Avatar tap', () {
    testWidgets('calls onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        widgetHost(Avatar(name: 'Ada', onTap: () => taps++)),
      );

      await tester.tap(find.byType(Avatar));

      expect(taps, 1);
    });

    testWidgets('without onTap it is inert', (tester) async {
      await tester.pumpWidget(widgetHost(const Avatar(name: 'Ada')));

      await tester.startGesture(tester.getCenter(find.byType(Avatar)));
      await tester.pump();

      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scale.scale, 1);
      expect(find.byType(Pressable), findsOneWidget);
    });
  });
}
