import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/progress_bar.dart';

import '../../helpers/widget_host.dart';

const _width = 200.0;

Widget _bar(
  ProgressBar bar, {
  Brightness brightness = Brightness.light,
  bool disableAnimations = false,
}) => widgetHost(
  SizedBox(width: _width, child: bar),
  brightness: brightness,
  disableAnimations: disableAnimations,
);

Finder get _fill => find.descendant(
  of: find.byType(ProgressBar),
  matching: find.byType(FractionallySizedBox),
);

double _fillWidth(WidgetTester tester) => tester.getSize(_fill).width;

BoxDecoration _decoration(WidgetTester tester, Finder box) =>
    tester.widget<DecoratedBox>(box).decoration as BoxDecoration;

Finder get _track => find
    .descendant(
      of: find.byType(ProgressBar),
      matching: find.byType(DecoratedBox),
    )
    .first;

Finder get _fillBox =>
    find.descendant(of: _fill, matching: find.byType(DecoratedBox));

void main() {
  group('ProgressBar fill', () {
    testWidgets('width is value times the available width', (tester) async {
      await tester.pumpWidget(_bar(const ProgressBar.quest(value: .25)));

      expect(_fillWidth(tester), closeTo(50, .01));
    });

    testWidgets('clamps values above 1 and below 0', (tester) async {
      await tester.pumpWidget(_bar(const ProgressBar.quest(value: 1.7)));
      expect(_fillWidth(tester), _width);

      await tester.pumpWidget(_bar(const ProgressBar.quest(value: -.4)));
      await tester.pump(const Duration(milliseconds: 500));
      expect(_fillWidth(tester), 0);
    });

    testWidgets('treats NaN as empty', (tester) async {
      await tester.pumpWidget(_bar(const ProgressBar.exp(value: double.nan)));

      expect(_fillWidth(tester), 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('starts from its value on mount, without animating', (
      tester,
    ) async {
      await tester.pumpWidget(_bar(const ProgressBar.exp(value: .6)));

      expect(_fillWidth(tester), closeTo(120, .01));
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('a new value animates over 500 ms', (tester) async {
      await tester.pumpWidget(_bar(const ProgressBar.quest(value: .2)));

      await tester.pumpWidget(_bar(const ProgressBar.quest(value: .8)));
      await tester.pump(const Duration(milliseconds: 250));
      final mid = _fillWidth(tester);
      expect(mid, inExclusiveRange(40, 160));

      await tester.pump(const Duration(milliseconds: 250));
      expect(_fillWidth(tester), closeTo(160, .01));
    });

    testWidgets('reduced motion shortens the change to 150 ms', (tester) async {
      await tester.pumpWidget(
        _bar(const ProgressBar.quest(value: .2), disableAnimations: true),
      );

      await tester.pumpWidget(
        _bar(const ProgressBar.quest(value: .8), disableAnimations: true),
      );
      await tester.pump(Motion.reducedFade);

      expect(_fillWidth(tester), closeTo(160, .01));
    });
  });

  group('ProgressBar.quest', () {
    testWidgets('is 10 high with radius 6, elev track and accent fill', (
      tester,
    ) async {
      await tester.pumpWidget(_bar(const ProgressBar.quest(value: .5)));
      final colors = tester.element(find.byType(ProgressBar)).colors;

      expect(tester.getSize(find.byType(ProgressBar)).height, 10);
      expect(_decoration(tester, _track).color, colors.elev);
      expect(
        _decoration(tester, _track).borderRadius,
        BorderRadius.circular(6),
      );
      expect(_decoration(tester, _fillBox).color, colors.accent);
      expect(_decoration(tester, _fillBox).gradient, isNull);
    });
  });

  group('ProgressBar.exp', () {
    testWidgets('is 8 high with radius 5, line track and accent gradient', (
      tester,
    ) async {
      await tester.pumpWidget(_bar(const ProgressBar.exp(value: .5)));
      final colors = tester.element(find.byType(ProgressBar)).colors;
      final gradient =
          _decoration(tester, _fillBox).gradient! as LinearGradient;

      expect(tester.getSize(find.byType(ProgressBar)).height, 8);
      expect(_decoration(tester, _track).color, colors.line);
      expect(
        _decoration(tester, _track).borderRadius,
        BorderRadius.circular(5),
      );
      expect(gradient.colors, [colors.accent, colors.accent2]);
      expect(gradient.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
    });
  });

  group('ProgressBar semantics', () {
    testWidgets('with a label exposes it and the rounded percentage', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _bar(const ProgressBar.quest(value: .666, semanticLabel: 'Missione')),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Missione'));

      expect(node.label, 'Missione');
      expect(node.value, '67%');
      handle.dispose();
    });

    testWidgets('clamps the announced percentage', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _bar(const ProgressBar.exp(value: 3, semanticLabel: 'Exp')),
      );

      expect(tester.getSemantics(find.bySemanticsLabel('Exp')).value, '100%');
      handle.dispose();
    });

    testWidgets('without a label it announces nothing', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_bar(const ProgressBar.quest(value: .5)));

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.value != null,
        ),
        findsNothing,
      );
      expect(tester.getSemantics(find.byType(ProgressBar)).value, isEmpty);
      handle.dispose();
    });
  });

  group('ProgressBar themes', () {
    for (final brightness in Brightness.values) {
      testWidgets('follows the ${brightness.name} theme tokens', (
        tester,
      ) async {
        await tester.pumpWidget(
          _bar(const ProgressBar.quest(value: .5), brightness: brightness),
        );
        final colors = tester.element(find.byType(ProgressBar)).colors;

        expect(_decoration(tester, _track).color, colors.elev);
        expect(_decoration(tester, _fillBox).color, colors.accent);
      });
    }
  });
}
