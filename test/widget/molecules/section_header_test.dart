import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/molecules/section_header.dart';

import '../../helpers/widget_host.dart';

AppColors _colors(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(SectionHeader)))
        .extension<AppColors>()!;

Text _title(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text));

Widget _host(Widget header, {Brightness brightness = Brightness.light}) =>
    widgetHost(SizedBox(width: 300, child: header), brightness: brightness);

void main() {
  group('SectionHeader title', () {
    forBothThemes('lg uses the 21 section style in onCanvas', (
      tester,
      brightness,
    ) async {
      await tester.pumpWidget(
        _host(const SectionHeader(title: 'Oggi'), brightness: brightness),
      );

      final style = _title(tester, 'Oggi').style!;

      expect(style.fontSize, 21);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.color, _colors(tester).onCanvas);
    });

    testWidgets('md uses the 16 sheet title style', (tester) async {
      await tester.pumpWidget(
        _host(const SectionHeader(title: 'Oggi', size: SectionSize.md)),
      );

      expect(_title(tester, 'Oggi').style!.fontSize, 16);
    });

    for (final scale in [1.0, 2.0]) {
      testWidgets('a long action at text scale $scale does not overflow', (
        tester,
      ) async {
        await tester.pumpWidget(
          widgetHost(
            SizedBox(
              width: 300,
              child: SectionHeader(
                title: 'Oggi',
                actionLabel: 'Vedi tutte le abitudini della settimana',
                onAction: () {},
              ),
            ),
            textScale: scale,
          ),
        );

        final header = tester.getRect(find.byType(SectionHeader));
        final action = tester.getRect(find.byType(AnimatedScale));

        expect(tester.takeException(), isNull);
        expect(action.right, lessThanOrEqualTo(header.right));
        expect(action.height, greaterThanOrEqualTo(AppSizes.minTapTarget));
        expect(
          tester.getRect(find.text('Oggi')).width,
          greaterThanOrEqualTo(header.width / 3),
        );
      });
    }

    testWidgets('a long title takes one line and the action stays visible', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          SectionHeader(
            title: 'Un titolo molto molto lungo ' * 5,
            actionLabel: 'Tutte',
            onAction: () {},
          ),
        ),
      );

      final title = tester.widget<Text>(find.textContaining('Un titolo'));

      expect(tester.takeException(), isNull);
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(find.text('Tutte'), findsOneWidget);
      expect(
        tester.getRect(find.text('Tutte')).right,
        lessThanOrEqualTo(tester.getRect(find.byType(SectionHeader)).right),
      );
    });
  });

  group('SectionHeader action', () {
    testWidgets('is absent without a label', (tester) async {
      await tester.pumpWidget(
        _host(SectionHeader(title: 'Oggi', onAction: () {})),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    forBothThemes('is 12/700 in onCanvas2 and calls onAction', (
      tester,
      brightness,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          SectionHeader(
            title: 'Oggi',
            actionLabel: 'Tutte',
            onAction: () => taps++,
          ),
          brightness: brightness,
        ),
      );

      final style = _title(tester, 'Tutte').style!;
      await tester.tap(find.text('Tutte'));

      expect(style.fontSize, 12);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.color, _colors(tester).onCanvas2);
      expect(taps, 1);
    });

    testWidgets('without onAction the label shows but is inert', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const SectionHeader(title: 'Oggi', actionLabel: 'Tutte')),
      );

      await tester.startGesture(tester.getCenter(find.text('Tutte')));
      await tester.pump();

      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(find.text('Tutte'), findsOneWidget);
      expect(scale.scale, 1);
    });

    testWidgets('has a touch area of at least 44', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          SectionHeader(title: 'Oggi', actionLabel: 'Tutte', onAction: () {}),
        ),
      );

      final action = tester.getSize(find.byType(AnimatedScale));

      expect(action.height, greaterThanOrEqualTo(AppSizes.minTapTarget));
      expect(action.width, greaterThanOrEqualTo(AppSizes.minTapTarget));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });
  });
}
