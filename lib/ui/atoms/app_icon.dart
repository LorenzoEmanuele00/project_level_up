import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:levelup/theme/icons.dart';

/// A line icon from the Streamline set, tinted with a single [color].
class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {required this.size, required this.color, super.key});

  /// Icon key (see [AppIcons]); an unknown key shows the default icon.
  final String name;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    AppIcons.assetFor(name),
    width: size,
    height: size,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}
