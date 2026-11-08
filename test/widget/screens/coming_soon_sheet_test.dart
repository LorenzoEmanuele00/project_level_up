import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/ui/screens/coming_soon_sheet.dart';

import '../../helpers/widget_host.dart';

void main() {
  testWidgets('shows the section name and the coming soon text', (
    tester,
  ) async {
    await tester.pumpWidget(
      widgetHost(
        ComingSoonSheet(section: (context) => 'Profilo', onClose: () {}),
      ),
    );

    expect(find.text('Profilo'), findsOneWidget);
    expect(find.text('Prossimamente'), findsOneWidget);
    expect(find.text('Questa sezione arriva presto.'), findsOneWidget);
  });

  testWidgets('the close button calls onClose', (tester) async {
    var closed = 0;
    await tester.pumpWidget(
      widgetHost(
        ComingSoonSheet(
          section: (context) => 'Profilo',
          onClose: () => closed++,
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Chiudi'));
    expect(closed, 1);
  });

  testWidgets('is localized in English', (tester) async {
    await tester.pumpWidget(
      widgetHost(
        ComingSoonSheet(section: (context) => 'Profile', onClose: () {}),
        locale: const Locale('en'),
      ),
    );

    expect(find.text('Coming soon'), findsOneWidget);
    expect(find.bySemanticsLabel('Close'), findsOneWidget);
  });
}
