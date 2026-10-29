import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/palettes.dart';
import 'package:levelup/ui/molecules/stat_tile.dart';

import '../../helpers/widget_host.dart';

Finder get _label =>
    find.descendant(of: find.byType(StatTile), matching: find.byType(Text));

Finder get _box => find.descendant(
  of: find.byType(StatTile),
  matching: find.byType(DecoratedBox),
);

Widget _tile(StatTile tile, {Brightness brightness = Brightness.light}) =>
    widgetHost(SizedBox(width: 100, child: tile), brightness: brightness);

void main() {
  for (final kind in StatKind.values) {
    forBothThemes('${kind.name}: pastel fill and tone colours', (
      tester,
      brightness,
    ) async {
      await tester.pumpWidget(
        _tile(
          StatTile(kind: kind, label: 'Serie', value: '12', total: '30'),
          brightness: brightness,
        ),
      );
      final tone = Palettes.stat(kind);

      final decoration =
          tester.widget<DecoratedBox>(_box.first).decoration as BoxDecoration;
      final label = tester.widget<Text>(_label.first);
      final value = tester.widget<Text>(_label.last);
      final spans = (value.textSpan! as TextSpan).children!.cast<TextSpan>();

      expect(decoration.color, tone.fill);
      expect(decoration.borderRadius, BorderRadius.circular(14));
      expect(label.style!.color, tone.label);
      expect(spans.first.style!.color, tone.value);
      expect(spans.last.style!.color, tone.label);
    });
  }

  testWidgets('label is upper case 9/400, value 18/700, 3 apart', (
    tester,
  ) async {
    await tester.pumpWidget(
      _tile(const StatTile(kind: StatKind.sky, label: 'Serie', value: '12')),
    );

    final label = tester.widget<Text>(_label.first);
    final value = tester.widget<Text>(_label.last);
    final valueStyle = (value.textSpan! as TextSpan).children!.first.style!;

    expect(label.data, 'SERIE');
    expect(label.style!.fontSize, 9);
    expect(label.style!.fontWeight, FontWeight.w400);
    expect(valueStyle.fontSize, 18);
    expect(valueStyle.fontWeight, FontWeight.w700);
    expect(
      tester.getTopLeft(find.byWidget(value)).dy -
          tester.getBottomLeft(find.byWidget(label)).dy,
      3,
    );
  });

  testWidgets('pads 11 vertically and 8 horizontally, centred', (tester) async {
    await tester.pumpWidget(
      _tile(const StatTile(kind: StatKind.mint, label: 'Serie', value: '12')),
    );

    final tile = tester.getRect(find.byType(StatTile));
    final label = tester.getRect(_label.first);

    expect(label.top - tile.top, 11);
    expect(label.center.dx, closeTo(tile.center.dx, .01));
  });

  testWidgets('shows the denominator only when given', (tester) async {
    await tester.pumpWidget(
      _tile(
        const StatTile(
          kind: StatKind.peach,
          label: 'Fatte',
          value: '5',
          total: '8',
        ),
      ),
    );
    expect(find.text('5/8', findRichText: true), findsOneWidget);

    await tester.pumpWidget(
      _tile(const StatTile(kind: StatKind.peach, label: 'Fatte', value: '5')),
    );
    expect(find.text('5', findRichText: true), findsOneWidget);
    expect(find.textContaining('/', findRichText: true), findsNothing);
  });

  testWidgets('long texts at width 80 stay on one line without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      widgetHost(
        const SizedBox(
          width: 80,
          child: StatTile(
            kind: StatKind.butter,
            label: 'Completamenti totali record',
            value: '123456789',
            total: '987654321',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(FittedBox), findsWidgets);
    for (final text in tester.widgetList<Text>(_label)) {
      expect(text.maxLines, 1);
    }
  });
}
