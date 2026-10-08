/// Icon keys (stored in the model, e.g. `Habit.icon`) mapped to SVG assets.
///
/// Keys come from the design system (`#t-icone`) plus the interface icons.
/// Streamline free set, line style: see `docs/icons-license.md`.
abstract final class AppIcons {
  /// Icon of a new habit.
  static const defaultHabit = 'target';

  static const _dir = 'assets/icons';

  /// Habit and avatar pickers.
  static const _picker = [
    'gym', 'book', 'code', 'yoga', 'run', 'candy', 'water', 'leaf', 'sleep',
    'pencil', 'paint', 'wallet', 'phone', 'target', 'star', 'crown', 'rocket',
    'moon', 'trophy', 'medal', 'list', 'lock',
  ];

  /// Interface icons, also used by the four medal tracks
  /// (streak: flame, completions: check, level: flash, rewards: gift).
  static const _interface = [
    'close', 'back', 'add', 'cog', 'chevron-down', 'check', 'gem', 'flame',
    'flash', 'gift',
  ];

  /// Every known key.
  static const keys = [..._picker, ..._interface];

  static final _known = keys.toSet();

  static bool isKnown(String key) => _known.contains(key);

  /// Asset path of [key]. An unknown key (e.g. synced from a newer app
  /// version) resolves to the default icon instead of failing.
  static String assetFor(String key) =>
      '$_dir/${isKnown(key) ? key : defaultHabit}.svg';
}
