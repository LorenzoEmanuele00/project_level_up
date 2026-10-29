import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/l10n/app_localizations.dart';
import 'package:levelup/theme/theme.dart';

/// Hosts [child] in a [MaterialApp] built like the real app: app theme,
/// localisations, and a [MediaQuery] with reduced motion and text scale under
/// the test's control.
Widget widgetHost(
  Widget child, {
  Brightness brightness = Brightness.light,
  AccentKey accent = AccentKey.terracotta,
  Locale locale = const Locale('it'),
  bool disableAnimations = false,
  double textScale = 1,
}) => MaterialApp(
  theme: buildTheme(brightness, accent),
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  builder: (context, home) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      disableAnimations: disableAnimations,
      textScaler: TextScaler.linear(textScale),
    ),
    child: home!,
  ),
  home: Scaffold(body: Center(child: child)),
);

/// Registers [body] as a widget test once per theme brightness.
void forBothThemes(
  String description,
  Future<void> Function(WidgetTester tester, Brightness brightness) body,
) {
  for (final brightness in Brightness.values) {
    testWidgets('$description (${brightness.name})', (tester) {
      return body(tester, brightness);
    });
  }
}
