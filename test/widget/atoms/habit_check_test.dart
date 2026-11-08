import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/habit_check.dart';
import 'package:levelup/ui/motion/pressable.dart';

import '../../helpers/widget_host.dart';

AppColors _colors(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(HabitCheck))).extension<AppColors>()!;

Finder get _circle => find.descendant(
  of: find.byType(HabitCheck),
  matching: find.byWidgetPredicate(
    (w) =>
        w is DecoratedBox &&
        (w.decoration as BoxDecoration).shape == BoxShape.circle,
  ),
);

BoxDecoration _decoration(WidgetTester tester) =>
    tester.widget<DecoratedBox>(_circle).decoration as BoxDecoration;

void main() {
  group('HabitCheck', () {
    for (final hue in HabitHue.values) {
      forBothThemes(
        'todo (${hue.name}): onTintFill fill, line border, ink tick',
        (tester, brightness) async {
          await tester.pumpWidget(
            widgetHost(
              HabitCheck(hue: hue, done: false, onTap: () {}),
              brightness: brightness,
            ),
          );
          final colors = _colors(tester);
          final tone = colors.hue(hue);

          final decoration = _decoration(tester);
          final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));

          expect(decoration.color, colors.onTintFill);
          expect((decoration.border! as Border).top.color, colors.line);
          expect(svg.colorFilter, ColorFilter.mode(tone.ink, BlendMode.srcIn));
        },
      );

      forBothThemes('done (${hue.name}): ink fill and border, onAccent tick', (
        tester,
        brightness,
      ) async {
        await tester.pumpWidget(
          widgetHost(
            HabitCheck(hue: hue, done: true, onTap: () {}),
            brightness: brightness,
          ),
        );
        final colors = _colors(tester);
        final tone = colors.hue(hue);

        final decoration = _decoration(tester);
        final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(decoration.color, tone.ink);
        expect((decoration.border! as Border).top.color, tone.ink);
        expect(
          svg.colorFilter,
          ColorFilter.mode(colors.onAccent, BlendMode.srcIn),
        );
      });
    }

    testWidgets('draws 34 inside a 44 touch area', (tester) async {
      await tester.pumpWidget(
        widgetHost(HabitCheck(hue: HabitHue.teal, done: false, onTap: () {})),
      );

      expect(tester.getSize(_circle), const Size.square(34));
      expect(
        tester.getSize(find.byType(HabitCheck)),
        const Size.square(AppSizes.minTapTarget),
      );
    });

    testWidgets('meets the iOS tap target guideline', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        widgetHost(
          HabitCheck(
            hue: HabitHue.teal,
            done: false,
            onTap: () {},
            semanticLabel: 'Completa',
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('done exposes a checked and disabled state', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        widgetHost(
          HabitCheck(
            hue: HabitHue.teal,
            done: true,
            onTap: () {},
            semanticLabel: 'Fatta',
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Fatta')),
        matchesSemantics(
          label: 'Fatta',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          hasCheckedState: true,
          isImage: true,
          isChecked: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('todo exposes an unchecked, enabled state', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        widgetHost(
          HabitCheck(
            hue: HabitHue.teal,
            done: false,
            onTap: () {},
            semanticLabel: 'Da fare',
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Da fare')),
        matchesSemantics(
          label: 'Da fare',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasCheckedState: true,
          isImage: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('tapping the 44 area outside the circle calls onTap', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        widgetHost(
          HabitCheck(hue: HabitHue.teal, done: false, onTap: () => taps++),
        ),
      );

      await tester.tapAt(
        tester.getTopLeft(find.byType(HabitCheck)) + const Offset(2, 2),
      );

      expect(taps, 1);
    });

    testWidgets('shrinks to .88 while pressed', (tester) async {
      await tester.pumpWidget(
        widgetHost(HabitCheck(hue: HabitHue.teal, done: false, onTap: () {})),
      );

      await tester.startGesture(tester.getCenter(find.byType(HabitCheck)));
      await tester.pump();

      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scale.scale, Motion.pressScaleSmall);
    });

    testWidgets('without onTap it is inert', (tester) async {
      await tester.pumpWidget(
        widgetHost(const HabitCheck(hue: HabitHue.teal, done: false)),
      );

      await tester.startGesture(tester.getCenter(find.byType(HabitCheck)));
      await tester.pump();

      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scale.scale, 1);
    });

    testWidgets('when done it ignores taps and does not scale', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        widgetHost(
          HabitCheck(hue: HabitHue.teal, done: true, onTap: () => taps++),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(HabitCheck)),
      );
      await tester.pump();
      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      await gesture.up();

      expect(taps, 0);
      expect(scale.scale, 1);
    });

    testWidgets('exposes the label to accessibility', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        widgetHost(
          HabitCheck(
            hue: HabitHue.teal,
            done: false,
            onTap: () {},
            semanticLabel: 'Completa Leggere',
          ),
        ),
      );

      expect(find.bySemanticsLabel('Completa Leggere'), findsOneWidget);
      expect(find.byType(Pressable), findsOneWidget);
      handle.dispose();
    });
  });
}
