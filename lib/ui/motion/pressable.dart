import 'package:flutter/widgets.dart';
import 'package:levelup/theme/tokens.dart';

/// How far a pressed element shrinks: large ones (tiles, cards) barely, small
/// ones (checks, chips) clearly.
enum PressScale {
  large(Motion.pressScaleLarge),
  small(Motion.pressScaleSmall);

  const PressScale(this.value);

  final double value;
}

/// Tap target with the design system press feedback: the child scales down on
/// press and springs back. Without [onTap] it is inert (no scale, disabled
/// button for accessibility). With reduced motion the tap works but the scale
/// is skipped.
class Pressable extends StatefulWidget {
  const Pressable({
    required this.child,
    this.onTap,
    this.scale = PressScale.large,
    this.semanticLabel,
    this.checked,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final PressScale scale;
  final String? semanticLabel;

  /// Checked state for check like targets; null for plain buttons.
  final bool? checked;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final scaled = enabled && _pressed && !Motion.reduced(context);
    return Semantics(
      button: true,
      enabled: enabled,
      checked: widget.checked,
      label: widget.semanticLabel,
      container: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scaled ? widget.scale.value : 1,
          duration: Motion.springShort,
          curve: Motion.spring,
          child: widget.child,
        ),
      ),
    );
  }
}
