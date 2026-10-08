import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:levelup/domain/accent_key.dart';
import 'package:levelup/domain/medal_tier.dart';
import 'package:levelup/domain/reward_tier.dart';

enum LuStatKind { peach, mint, sky, butter }

/// Fill, label and value colours of a pastel stat tile. Same in both themes.
@immutable
class LuStatTone {
  const LuStatTone({
    required this.fill,
    required this.label,
    required this.value,
  });

  final Color fill;
  final Color label;
  final Color value;
}

/// Gradient pair and ring colour of a medal tier. Same in both themes.
@immutable
class LuMedalTone {
  const LuMedalTone({required this.c1, required this.c2, required this.ring});

  final Color c1;
  final Color c2;
  final Color ring;

  /// 155 degrees, from [c1] to [c2].
  LinearGradient get gradient =>
      LinearGradient(begin: -_gradientEnd, end: _gradientEnd, colors: [c1, c2]);
}

/// End point of a CSS `linear-gradient(155deg)` on a square box. The CSS
/// gradient line is `|sin| + |cos|` times the box side, so the unit direction
/// is scaled by that factor to avoid clamping the colours early.
final _gradientEnd = () {
  final radians = 155 * math.pi / 180;
  final dx = math.sin(radians);
  final dy = -math.cos(radians);
  final length = dx.abs() + dy.abs();
  return Alignment(dx * length, dy * length);
}();

/// Palettes that do not depend on the theme (light/dark), plus the accents.
abstract final class LuPalettes {
  static Color accent(AccentKey key) => switch (key) {
    AccentKey.terra => const Color(0xFFD9614C),
    AccentKey.ambra => const Color(0xFFCF9C4D),
    AccentKey.salvia => const Color(0xFF5B9C6F),
    AccentKey.ardesia => const Color(0xFF5988C0),
    AccentKey.rosa => const Color(0xFFC56B7A),
  };

  static LuStatTone stat(LuStatKind kind) => switch (kind) {
    LuStatKind.peach => const LuStatTone(
      fill: Color(0xFFF6D6C1),
      label: Color(0xFFA55A33),
      value: Color(0xFF7A3D1E),
    ),
    LuStatKind.mint => const LuStatTone(
      fill: Color(0xFFCFE6C4),
      label: Color(0xFF3F7A2E),
      value: Color(0xFF26401C),
    ),
    LuStatKind.sky => const LuStatTone(
      fill: Color(0xFFC7DEF2),
      label: Color(0xFF3A5A74),
      value: Color(0xFF16324A),
    ),
    LuStatKind.butter => const LuStatTone(
      fill: Color(0xFFF2D385),
      label: Color(0xFF8A6A1C),
      value: Color(0xFF4A3D17),
    ),
  };

  static LuMedalTone medal(MedalTier tier) => switch (tier) {
    MedalTier.bronzo => const LuMedalTone(
      c1: Color(0xFFD69457),
      c2: Color(0xFFA05A2C),
      ring: Color(0xFFC67F45),
    ),
    MedalTier.argento => const LuMedalTone(
      c1: Color(0xFFD3D7DE),
      c2: Color(0xFF9298A3),
      ring: Color(0xFFB7BCC5),
    ),
    MedalTier.oro => const LuMedalTone(
      c1: Color(0xFFE6C060),
      c2: Color(0xFFB3831F),
      ring: Color(0xFFD3A24A),
    ),
  };

  /// Reward rarity colour. `grande` follows the accent.
  static Color rarity(RewardTier tier, Color accent) => switch (tier) {
    RewardTier.piccola => const Color(0xFF6F9ED6),
    RewardTier.media => const Color(0xFF54C2B4),
    RewardTier.grande => accent,
  };

  /// Streak flame.
  static const flame = Color(0xFFE8863A);

  /// Active sync.
  static const success = Color(0xFF3FBF7F);

  /// Overlay scrim, alpha between .72 and .92 depending on the overlay.
  static Color scrim(double alpha) => Color.fromRGBO(6, 4, 5, alpha);

  /// Blur sigma that goes with [scrim].
  static const scrimBlur = 6.0;
}
