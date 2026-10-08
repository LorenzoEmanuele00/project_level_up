import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/colors.dart';
import 'package:levelup/theme/icons.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/ui/atoms/app_icon.dart';
import 'package:levelup/ui/atoms/icon_tile.dart';

Widget _host(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: buildTheme(brightness, AccentKey.terra),
      home: Scaffold(body: Center(child: child)),
    );

AppColors _colors(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(Scaffold))).extension<AppColors>()!;

void main() {
  group('AppIcon', () {
    testWidgets('renders the SVG tinted with the given colour', (tester) async {
      await tester.pumpWidget(
        _host(const AppIcon('flame', size: 20, color: Color(0xFF112233))),
      );

      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));

      expect(svg.width, 20);
      expect(svg.height, 20);
      expect(
        svg.colorFilter,
        const ColorFilter.mode(Color(0xFF112233), BlendMode.srcIn),
      );
    });

    testWidgets('unknown key shows the default icon without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppIcon('does-not-exist', size: 20, color: Colors.black)),
      );
      await tester.pumpAndSettle();

      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      final loader = svg.bytesLoader as SvgAssetLoader;

      expect(tester.takeException(), isNull);
      expect(loader.assetName, AppIcons.assetFor(AppIcons.defaultHabit));
    });
  });

  group('IconTile', () {
    testWidgets('uses tint as background and ink for the icon', (tester) async {
      await tester.pumpWidget(
        _host(const IconTile('target', size: 100, hue: HabitHue.teal)),
      );
      final tone = _colors(tester).hue(HabitHue.teal);

      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(IconTile),
          matching: find.byType(DecoratedBox),
        ),
      );
      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));

      expect((box.decoration as BoxDecoration).color, tone.tint);
      expect(svg.colorFilter, ColorFilter.mode(tone.ink, BlendMode.srcIn));
    });

    testWidgets('padding is 23% and radius 29% of the side', (tester) async {
      await tester.pumpWidget(
        _host(const IconTile('target', size: 100, hue: HabitHue.gold)),
      );

      expect(tester.getSize(find.byType(IconTile)), const Size(100, 100));
      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(IconTile),
          matching: find.byType(DecoratedBox),
        ),
      );
      final radius =
          (box.decoration as BoxDecoration).borderRadius! as BorderRadius;
      expect(radius.topLeft.x, closeTo(29, 0.001));
      expect(tester.getSize(find.byType(SvgPicture)), const Size(54, 54));
    });

    testWidgets('follows the dark theme tone', (tester) async {
      await tester.pumpWidget(
        _host(
          const IconTile('gym', size: 48, hue: HabitHue.blue),
          brightness: Brightness.dark,
        ),
      );
      final tone = _colors(tester).hue(HabitHue.blue);

      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));

      expect(svg.colorFilter, ColorFilter.mode(tone.ink, BlendMode.srcIn));
    });
  });
}
