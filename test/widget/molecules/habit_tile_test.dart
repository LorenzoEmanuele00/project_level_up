import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models/habit.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/habit_check.dart';
import 'package:levelup/ui/atoms/icon_tile.dart';
import 'package:levelup/ui/molecules/habit_tile.dart';
import 'package:levelup/ui/motion/pressable.dart';

import '../../helpers/widget_host.dart';

const _tileWidth = 170.0;

Habit _habit({
  String name = 'Leggere',
  HabitHue hue = HabitHue.teal,
  int streak = 7,
  Difficulty difficulty = Difficulty.medium,
}) => Habit(
  id: 'h1',
  name: name,
  icon: 'book',
  difficulty: difficulty,
  frequency: Frequency.daily,
  hue: hue,
  streak: streak,
  bestStreak: streak,
  totalCompletions: 10,
  archived: false,
  createdAt: DateTime(2026, 1, 1),
);

Widget _tile(
  Habit habit, {
  bool done = false,
  VoidCallback? onComplete,
  VoidCallback? onOpen,
  Brightness brightness = Brightness.light,
  Locale locale = const Locale('it'),
  double textScale = 1,
  bool disableAnimations = false,
}) => widgetHost(
  SizedBox(
    width: _tileWidth,
    child: HabitTile(
      habit: habit,
      done: done,
      onComplete: onComplete,
      onOpen: onOpen,
    ),
  ),
  brightness: brightness,
  locale: locale,
  textScale: textScale,
  disableAnimations: disableAnimations,
);

AppColors _colors(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(HabitTile))).extension<AppColors>()!;

Finder get _tilePressable => find.byWidgetPredicate(
  (w) => w is Pressable && w.scale == PressScale.large,
);

Finder get _checkPressable => find.descendant(
  of: find.byType(HabitCheck),
  matching: find.byType(Pressable),
);

double _scaleOf(WidgetTester tester, Finder pressable) => tester
    .widget<AnimatedScale>(
      find.descendant(of: pressable, matching: find.byType(AnimatedScale)),
    )
    .scale;

Finder get _body => find.descendant(
  of: _tilePressable,
  matching: find.byWidgetPredicate(
    (w) =>
        w is DecoratedBox &&
        (w.decoration as BoxDecoration).borderRadius != null,
  ),
);

void main() {
  group('HabitTile look', () {
    for (final hue in HabitHue.values) {
      forBothThemes('${hue.name}: tint fill, radius 22, ink text', (
        tester,
        brightness,
      ) async {
        await tester.pumpWidget(
          _tile(_habit(hue: hue), brightness: brightness),
        );
        final colors = _colors(tester);
        final tone = colors.hue(hue);

        final decoration =
            tester.widget<DecoratedBox>(_body.first).decoration
                as BoxDecoration;
        final name = tester.widget<Text>(find.text('Leggere'));
        final tile = tester.widget<IconTile>(find.byType(IconTile));

        expect(decoration.color, tone.tint);
        expect(decoration.borderRadius, BorderRadius.circular(AppRadius.tile));
        expect(name.style!.color, tone.ink);
        expect(name.style!.fontSize, 14);
        expect(name.style!.fontWeight, FontWeight.w700);
        expect(name.style!.height, 1.2);
        expect(tile.hue, hue);
        expect(tile.size, 44);
        expect(tile.background, colors.onTintFill);
      });
    }

    testWidgets('is at least 134 tall and pads 15', (tester) async {
      await tester.pumpWidget(_tile(_habit()));

      final tile = tester.getRect(find.byType(HabitTile));
      final icon = tester.getRect(find.byType(IconTile));

      expect(tile.height, 134);
      expect(tile.width, _tileWidth);
      expect(icon.left - tile.left, 15);
      expect(icon.top - tile.top, 15);
    });

    testWidgets('the check sits at the top right corner', (tester) async {
      await tester.pumpWidget(_tile(_habit()));

      final tile = tester.getRect(find.byType(HabitTile));
      final check = tester.getRect(find.byType(HabitCheck));

      expect(tile.right - check.right, 10);
      expect(check.top - tile.top, 10);
    });

    testWidgets('shows EXP in Italian and English', (tester) async {
      await tester.pumpWidget(_tile(_habit()));
      expect(find.text('+20 EXP'), findsOneWidget);

      await tester.pumpWidget(
        _tile(_habit(difficulty: Difficulty.hard), locale: const Locale('en')),
      );
      expect(find.text('+40 EXP'), findsOneWidget);
    });

    testWidgets('shows the streak of the habit with a flame', (tester) async {
      await tester.pumpWidget(_tile(_habit(streak: 12)));

      final streak = tester.widget<Text>(find.text('12'));

      expect(streak.style!.fontSize, 11);
      expect(streak.style!.fontWeight, FontWeight.w400);
      expect(
        find.descendant(
          of: find.byType(HabitTile),
          matching: find.byType(SvgPicture),
        ),
        findsNWidgets(3),
      );
    });

    testWidgets('formats a 4 digit streak per locale', (tester) async {
      await tester.pumpWidget(_tile(_habit(streak: 1234)));
      expect(find.text('1.234'), findsOneWidget);

      await tester.pumpWidget(
        _tile(_habit(streak: 1234), locale: const Locale('en')),
      );
      expect(find.text('1,234'), findsOneWidget);
    });

    testWidgets('a long name takes two lines with an ellipsis', (tester) async {
      await tester.pumpWidget(_tile(_habit(name: 'Parola ' * 12)));

      final name = tester.widget<Text>(find.textContaining('Parola'));

      expect(tester.takeException(), isNull);
      expect(name.maxLines, 2);
      expect(name.overflow, TextOverflow.ellipsis);
    });

    testWidgets('80 characters at text scale 2 grow the tile, no overflow', (
      tester,
    ) async {
      await tester.pumpWidget(_tile(_habit(name: 'A' * 80), textScale: 2));

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(HabitTile)).height, greaterThan(134));
    });
  });

  group('HabitTile done', () {
    testWidgets('todo is fully opaque with an empty check', (tester) async {
      await tester.pumpWidget(_tile(_habit()));

      final opacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      final check = tester.widget<HabitCheck>(find.byType(HabitCheck));

      expect(opacity.opacity, 1);
      expect(check.done, isFalse);
    });

    testWidgets('done fades to .72 over 300 ms with a filled check', (
      tester,
    ) async {
      await tester.pumpWidget(_tile(_habit(), done: true));

      final opacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      final check = tester.widget<HabitCheck>(find.byType(HabitCheck));

      expect(opacity.opacity, .72);
      expect(opacity.duration, Motion.outShort);
      expect(check.done, isTrue);
    });
  });

  group('HabitTile interaction', () {
    testWidgets('tapping the check only completes', (tester) async {
      var completed = 0;
      var opened = 0;
      await tester.pumpWidget(
        _tile(_habit(), onComplete: () => completed++, onOpen: () => opened++),
      );

      await tester.tap(find.byType(HabitCheck));

      expect(completed, 1);
      expect(opened, 0);
    });

    testWidgets('tapping elsewhere only opens the detail', (tester) async {
      var completed = 0;
      var opened = 0;
      await tester.pumpWidget(
        _tile(_habit(), onComplete: () => completed++, onOpen: () => opened++),
      );

      await tester.tap(find.text('Leggere'));

      expect(opened, 1);
      expect(completed, 0);
    });

    testWidgets('the check of a done habit is inert', (tester) async {
      var completed = 0;
      await tester.pumpWidget(
        _tile(_habit(), done: true, onComplete: () => completed++),
      );

      await tester.tap(find.byType(HabitCheck));

      expect(completed, 0);
    });

    testWidgets('the check is a sibling of the tile pressable, not a child', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(_habit(), onComplete: () {}, onOpen: () {}),
      );

      expect(
        find.descendant(of: _tilePressable, matching: find.byType(HabitCheck)),
        findsNothing,
      );
    });

    testWidgets('holding the check shrinks the check, not the tile', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(_habit(), onComplete: () {}, onOpen: () {}),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(HabitCheck)),
      );
      await tester.pump();

      expect(_scaleOf(tester, _checkPressable), Motion.pressScaleSmall);
      expect(_scaleOf(tester, _tilePressable), 1);
      await gesture.up();
    });

    testWidgets('holding the tile shrinks it to .965', (tester) async {
      await tester.pumpWidget(
        _tile(_habit(), onComplete: () {}, onOpen: () {}),
      );

      await tester.startGesture(tester.getCenter(find.text('Leggere')));
      await tester.pump();

      expect(_scaleOf(tester, _tilePressable), Motion.pressScaleLarge);
      expect(_scaleOf(tester, _checkPressable), 1);
    });

    testWidgets('without callbacks the tile is inert', (tester) async {
      await tester.pumpWidget(_tile(_habit()));

      await tester.startGesture(tester.getCenter(find.text('Leggere')));
      await tester.pump();

      expect(_scaleOf(tester, _tilePressable), 1);
      expect(_scaleOf(tester, _checkPressable), 1);
    });

    testWidgets('exposes localized labels for the check', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_tile(_habit(), onComplete: () {}));
      expect(find.bySemanticsLabel('Completa Leggere'), findsOneWidget);

      await tester.pumpWidget(_tile(_habit(), done: true, onComplete: () {}));
      expect(find.bySemanticsLabel('Leggere completata'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('the name is read once by the tile, not twice', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_tile(_habit(), onOpen: () {}));

      final node = tester.getSemantics(_tilePressable);

      expect(RegExp('Leggere').allMatches(node.label), hasLength(1));
      expect(
        node,
        matchesSemantics(
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
          label: node.label,
        ),
      );
      handle.dispose();
    });

    testWidgets('with reduced motion taps still work', (tester) async {
      var opened = 0;
      await tester.pumpWidget(
        _tile(_habit(), onOpen: () => opened++, disableAnimations: true),
      );

      await tester.tap(find.text('Leggere'));

      expect(opened, 1);
    });
  });
}
