import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:levelup/state/game_providers.dart';
import 'package:levelup/state/today_providers.dart';

/// Builds the provider container and prepares the data the app needs before
/// the first frame.
///
/// That is the temporary development seed (removed by PLU-22) and the reset
/// of the streaks that expired while the app was closed. A failure of the
/// reset is reported but does not stop the launch: the streaks are fixed
/// again at the next refresh. [overrides] let tests swap the database or
/// repository.
Future<ProviderContainer> createAppContainer({
  List<Override> overrides = const [],
}) async {
  final container = ProviderContainer(overrides: overrides);
  try {
    await container.read(devSeedProvider.future);
    await _refreshStreaks(container);
  } catch (_) {
    container.dispose();
    rethrow;
  }
  return container;
}

Future<void> _refreshStreaks(ProviderContainer container) async {
  try {
    await container.read(streakRefreshProvider.future);
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'app bootstrap',
        context: ErrorDescription('while resetting the expired streaks'),
      ),
    );
  }
}
