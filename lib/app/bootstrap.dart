import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:levelup/state/game_providers.dart';

/// Builds the provider container and prepares the data the app needs before
/// the first frame.
///
/// For now that is the temporary development seed (removed by PLU-22).
/// [overrides] let tests swap the database or repository.
Future<ProviderContainer> createAppContainer({
  List<Override> overrides = const [],
}) async {
  final container = ProviderContainer(overrides: overrides);
  try {
    await container.read(devSeedProvider.future);
  } catch (_) {
    container.dispose();
    rethrow;
  }
  return container;
}
