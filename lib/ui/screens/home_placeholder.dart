import 'package:flutter/material.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/ui/l10n/l10n.dart';

/// Empty home shown until the real Home screen is built.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          context.l10n.appTitle,
          style: AppText.display.copyWith(color: context.colors.text),
        ),
      ),
    );
  }
}
