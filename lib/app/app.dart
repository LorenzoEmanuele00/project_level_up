import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup/app/router.dart';
import 'package:levelup/state/theme_settings.dart';
import 'package:levelup/theme/theme.dart';

class LevelUpApp extends ConsumerWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(themeSettingsProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'LevelUp',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(settings.brightness, settings.accent),
      routerConfig: router,
    );
  }
}
