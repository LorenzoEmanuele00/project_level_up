import 'package:flutter/widgets.dart';
import 'package:levelup/theme/tokens.dart';

/// Which entrance a [Entrance] plays.
enum EntranceKind {
  /// A whole block: fade, 48 px rise and scale .965 to 1.
  blockUp(
    duration: Motion.blockUpDuration,
    offset: Motion.blockUpOffset,
    startScale: Motion.blockUpScale,
  ),

  /// A list item: fade and 12 px rise.
  itemIn(
    duration: Motion.itemInDuration,
    offset: Motion.itemInOffset,
    startScale: 1,
  );

  const EntranceKind({
    required this.duration,
    required this.offset,
    required this.startScale,
  });

  final Duration duration;
  final double offset;
  final double startScale;
}

/// Plays the entrance animation once when first built. Items of a list pass
/// their [index] to be staggered by [Motion.stagger] each. With reduced motion
/// only a short fade remains (no offset, scale or stagger). A parent rebuild
/// never restarts it.
///
/// [animate], [index] and [kind] are read once, when the state is first built:
/// changing them later does not replay or retime the entrance. Only a change
/// of the reduced motion setting retimes the running entrance.
class Entrance extends StatefulWidget {
  const Entrance({
    required this.child,
    this.kind = EntranceKind.blockUp,
    this.index = 0,
    this.animate = true,
    super.key,
  });

  final Widget child;
  final EntranceKind kind;
  final int index;

  /// When false the child is shown at once (e.g. on revisits of a screen).
  final bool animate;

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  CurvedAnimation? _curved;
  bool _reduced = false;
  bool _started = false;

  Duration get _delay =>
      _reduced ? Duration.zero : Motion.stagger * widget.index;

  Duration get _total =>
      _reduced ? Motion.reducedFade : _delay + widget.kind.duration;

  CurvedAnimation _buildCurve() => CurvedAnimation(
    parent: _controller,
    curve: Interval(
      _delay.inMicroseconds / _total.inMicroseconds,
      1,
      curve: _reduced ? Curves.linear : Motion.apple,
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = Motion.reduced(context);
    if (_started && reduced == _reduced) return;
    final first = !_started;
    _started = true;
    _reduced = reduced;
    _controller.duration = _total;
    _curved?.dispose();
    _curved = _buildCurve();
    if (!first) return;
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _curved?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _curved!;
    return FadeTransition(
      opacity: progress,
      child: AnimatedBuilder(
        animation: progress,
        child: widget.child,
        builder: (context, child) {
          final remaining = _reduced ? 0.0 : 1 - progress.value;
          final kind = widget.kind;
          final scale = 1 - (1 - kind.startScale) * remaining;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translateByDouble(0, kind.offset * remaining, 0, 1)
              ..scaleByDouble(scale, scale, 1, 1),
            child: child,
          );
        },
      ),
    );
  }
}
