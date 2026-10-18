import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup/state/today_providers.dart';

/// Keeps the notion of "today" right while the app lives.
///
/// When the app comes back to the foreground it re-reads the day (timers may
/// have been suspended) and resets the streaks that expired. It also keeps
/// [streakRefreshProvider] alive, so the reset runs by itself at every
/// midnight. A failed reset is reported and never blocks the UI.
class DayRefresher extends ConsumerStatefulWidget {
  const DayRefresher({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<DayRefresher> createState() => _DayRefresherState();
}

class _DayRefresherState extends ConsumerState<DayRefresher> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _onResume);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _onResume() {
    ref.read(todayProvider.notifier).refresh();
    ref.invalidate(streakRefreshProvider);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(streakRefreshProvider, (_, next) {
      // A reload keeps the previous error (still an `AsyncError`, but loading).
      if (next.isLoading || next is! AsyncError) return;
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: next.error,
          stack: next.stackTrace,
          library: 'day refresher',
          context: ErrorDescription('while resetting the expired streaks'),
        ),
      );
    });
    return widget.child;
  }
}
