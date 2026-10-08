import 'package:flutter/material.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';

/// Empty home shown until the real Home screen is built.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'LevelUp',
          style: AppText.display.copyWith(color: context.colors.text),
        ),
      ),
    );
  }
}
