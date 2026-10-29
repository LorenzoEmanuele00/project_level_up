import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/ui/motion/entrance.dart';

import '../../helpers/widget_host.dart';

const _content = SizedBox(key: Key('content'), width: 50, height: 50);

double _opacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find.descendant(
        of: find.byType(Entrance),
        matching: find.byType(FadeTransition),
      ),
    )
    .opacity
    .value;

Transform _transform(WidgetTester tester) => tester.widget<Transform>(
  find.descendant(of: find.byType(Entrance), matching: find.byType(Transform)),
);

double _offsetY(WidgetTester tester) =>
    _transform(tester).transform.getTranslation().y;

double _scale(WidgetTester tester) => _transform(tester).transform.entry(0, 0);

Widget _entrance({
  EntranceKind kind = EntranceKind.blockUp,
  int index = 0,
  bool animate = true,
  bool disableAnimations = false,
}) => widgetHost(
  Entrance(kind: kind, index: index, animate: animate, child: _content),
  disableAnimations: disableAnimations,
);

void main() {
  group('Entrance blockUp', () {
    testWidgets('starts transparent, 48 px low and scaled to .965', (
      tester,
    ) async {
      await tester.pumpWidget(_entrance());

      expect(_opacity(tester), 0);
      expect(_offsetY(tester), 48);
      expect(_scale(tester), closeTo(.965, .0001));
    });

    testWidgets('ends opaque, in place and at full size after 600 ms', (
      tester,
    ) async {
      await tester.pumpWidget(_entrance());

      await tester.pump(const Duration(milliseconds: 600));

      expect(_opacity(tester), 1);
      expect(_offsetY(tester), 0);
      expect(_scale(tester), 1);
    });

    testWidgets('is mid-way before the duration elapses', (tester) async {
      await tester.pumpWidget(_entrance());

      await tester.pump(const Duration(milliseconds: 300));

      expect(_opacity(tester), inExclusiveRange(0, 1));
      expect(_offsetY(tester), inExclusiveRange(0, 48));
    });
  });

  group('Entrance itemIn', () {
    testWidgets('starts 12 px low without scaling', (tester) async {
      await tester.pumpWidget(_entrance(kind: EntranceKind.itemIn));

      expect(_opacity(tester), 0);
      expect(_offsetY(tester), 12);
      expect(_scale(tester), 1);
    });

    testWidgets('ends in place after 550 ms', (tester) async {
      await tester.pumpWidget(_entrance(kind: EntranceKind.itemIn));

      await tester.pump(const Duration(milliseconds: 550));

      expect(_opacity(tester), 1);
      expect(_offsetY(tester), 0);
    });
  });

  group('Entrance stagger', () {
    testWidgets('delays each item by 50 ms times its index', (tester) async {
      await tester.pumpWidget(_entrance(kind: EntranceKind.itemIn, index: 3));

      await tester.pump(const Duration(milliseconds: 140));
      expect(_opacity(tester), 0);
      expect(_offsetY(tester), 12);

      await tester.pump(const Duration(milliseconds: 560));
      expect(_opacity(tester), 1);
      expect(_offsetY(tester), 0);
    });

    testWidgets('index 0 starts without delay', (tester) async {
      await tester.pumpWidget(_entrance(kind: EntranceKind.itemIn));

      await tester.pump(const Duration(milliseconds: 100));

      expect(_opacity(tester), greaterThan(0));
    });
  });

  group('Entrance without animation', () {
    testWidgets('animate false shows the content at once', (tester) async {
      await tester.pumpWidget(_entrance(animate: false));

      expect(_opacity(tester), 1);
      expect(_offsetY(tester), 0);
      expect(_scale(tester), 1);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('Entrance with reduced motion', () {
    testWidgets('only fades in 150 ms, no offset, no scale', (tester) async {
      await tester.pumpWidget(_entrance(disableAnimations: true));

      expect(_opacity(tester), 0);
      expect(_offsetY(tester), 0);
      expect(_scale(tester), 1);

      await tester.pump(const Duration(milliseconds: 150));
      expect(_opacity(tester), 1);
    });

    testWidgets('does not stagger', (tester) async {
      await tester.pumpWidget(
        _entrance(kind: EntranceKind.itemIn, index: 8, disableAnimations: true),
      );

      await tester.pump(const Duration(milliseconds: 150));

      expect(_opacity(tester), 1);
    });
  });

  group('Entrance listeners', () {
    Animation<double> opacityAnimation(WidgetTester tester) => tester
        .widget<FadeTransition>(
          find.descendant(
            of: find.byType(Entrance),
            matching: find.byType(FadeTransition),
          ),
        )
        .opacity;

    testWidgets('rebuilds reuse the same progress animation', (tester) async {
      await tester.pumpWidget(_entrance());
      final first = opacityAnimation(tester);

      for (var i = 0; i < 20; i++) {
        await tester.pumpWidget(_entrance());
      }

      expect(identical(opacityAnimation(tester), first), isTrue);
      await tester.pump(const Duration(milliseconds: 600));
    });

    testWidgets('disposes cleanly while animating', (tester) async {
      await tester.pumpWidget(_entrance());
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(widgetHost(const SizedBox()));

      expect(tester.takeException(), isNull);
    });

    testWidgets('switching to reduced motion retimes without a restart', (
      tester,
    ) async {
      await tester.pumpWidget(_entrance());
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(_entrance(disableAnimations: true));
      await tester.pump(const Duration(milliseconds: 600));

      expect(tester.takeException(), isNull);
      expect(_opacity(tester), 1);
      expect(_offsetY(tester), 0);
    });
  });

  group('Entrance lifecycle', () {
    testWidgets('a parent rebuild does not restart the animation', (
      tester,
    ) async {
      await tester.pumpWidget(_entrance());
      await tester.pump(const Duration(milliseconds: 600));

      await tester.pumpWidget(_entrance());

      expect(_opacity(tester), 1);
      expect(_offsetY(tester), 0);
    });

    testWidgets('keeps showing the child', (tester) async {
      await tester.pumpWidget(_entrance());

      expect(find.byKey(const Key('content')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
    });
  });
}
