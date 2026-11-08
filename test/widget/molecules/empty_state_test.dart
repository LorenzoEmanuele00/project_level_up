import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/molecules/empty_state.dart';
import 'package:levelup/ui/painting/dashed_rrect_painter.dart';

import '../../helpers/widget_host.dart';

AppColors _colors(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(EmptyState))).extension<AppColors>()!;

Widget _host(Widget child, {Brightness brightness = Brightness.light}) =>
    widgetHost(SizedBox(width: 280, child: child), brightness: brightness);

DashedRRectPainter _dashed(WidgetTester tester) => tester
    .widgetList<CustomPaint>(
      find.descendant(
        of: find.byType(EmptyState),
        matching: find.byType(CustomPaint),
      ),
    )
    .map((p) => p.foregroundPainter)
    .whereType<DashedRRectPainter>()
    .single;

void main() {
  forBothThemes('surface fill with a dashed 1 px line border, radius 22', (
    tester,
    brightness,
  ) async {
    await tester.pumpWidget(
      _host(const EmptyState(title: 'Niente da fare'), brightness: brightness),
    );
    final colors = _colors(tester);

    final painter = _dashed(tester);
    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(EmptyState),
        matching: find.byType(DecoratedBox),
      ),
    );

    expect(painter.color, colors.line);
    expect(painter.strokeWidth, 1);
    expect(painter.radius, AppRadius.tile);
    expect(painter.dash, greaterThan(0));
    expect(painter.gap, greaterThan(0));
    expect((box.decoration as BoxDecoration).color, colors.surface);
    expect(
      (box.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(AppRadius.tile),
    );
  });

  forBothThemes('title is 15/700 text, subtitle 12 text2 with 4 above', (
    tester,
    brightness,
  ) async {
    await tester.pumpWidget(
      _host(
        const EmptyState(title: 'Niente da fare', subtitle: 'Aggiungi una'),
        brightness: brightness,
      ),
    );
    final colors = _colors(tester);

    final title = tester.widget<Text>(find.text('Niente da fare'));
    final subtitle = tester.widget<Text>(find.text('Aggiungi una'));

    expect(title.style!.fontSize, 15);
    expect(title.style!.fontWeight, FontWeight.w700);
    expect(title.style!.color, colors.text);
    expect(subtitle.style!.fontSize, 12);
    expect(subtitle.style!.color, colors.text2);
    expect(
      tester.getTopLeft(find.text('Aggiungi una')).dy -
          tester.getBottomLeft(find.text('Niente da fare')).dy,
      4,
    );
  });

  testWidgets('pads 30 vertically and 16 horizontally', (tester) async {
    await tester.pumpWidget(_host(const EmptyState(title: 'Niente')));

    final state = tester.getRect(find.byType(EmptyState));
    final title = tester.getRect(find.text('Niente'));

    expect(title.top - state.top, 30);
    expect(state.bottom - title.bottom, 30);
    expect(state.width, 280);
  });

  testWidgets('without a subtitle only the title is shown', (tester) async {
    await tester.pumpWidget(_host(const EmptyState(title: 'Niente')));

    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('shows the leading widget above the title', (tester) async {
    await tester.pumpWidget(
      _host(
        const EmptyState(
          title: 'Niente',
          leading: SizedBox(key: Key('lead'), width: 24, height: 24),
        ),
      ),
    );

    expect(
      tester.getBottomLeft(find.byKey(const Key('lead'))).dy,
      lessThan(tester.getTopLeft(find.text('Niente')).dy),
    );
  });

  testWidgets('long texts wrap, stay centred and do not overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        EmptyState(
          title: 'Un titolo davvero lungo ' * 6,
          subtitle: 'Un sottotitolo ancora piu lungo ' * 6,
        ),
      ),
    );

    final title = tester.widget<Text>(find.textContaining('Un titolo'));
    final subtitle = tester.widget<Text>(find.textContaining('Un sottotitolo'));

    expect(tester.takeException(), isNull);
    expect(title.textAlign, TextAlign.center);
    expect(subtitle.textAlign, TextAlign.center);
    expect(
      tester.getSize(find.textContaining('Un titolo')).height,
      greaterThan(40),
    );
  });
}
