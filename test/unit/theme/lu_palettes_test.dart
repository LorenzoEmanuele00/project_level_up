import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/accent_key.dart';
import 'package:levelup/domain/medal_tier.dart';
import 'package:levelup/domain/reward_tier.dart';
import 'package:levelup/theme/lu_palettes.dart';

void main() {
  group('LuPalettes.accent', () {
    test('maps the five accent keys to the design system colours', () {
      expect(LuPalettes.accent(AccentKey.terra), const Color(0xFFD9614C));
      expect(LuPalettes.accent(AccentKey.ambra), const Color(0xFFCF9C4D));
      expect(LuPalettes.accent(AccentKey.salvia), const Color(0xFF5B9C6F));
      expect(LuPalettes.accent(AccentKey.ardesia), const Color(0xFF5988C0));
      expect(LuPalettes.accent(AccentKey.rosa), const Color(0xFFC56B7A));
    });
  });

  group('LuPalettes.stat (fixed pastel)', () {
    test('peach, mint, sky and butter expose fill, label and value', () {
      final peach = LuPalettes.stat(LuStatKind.peach);
      expect(peach.fill, const Color(0xFFF6D6C1));
      expect(peach.label, const Color(0xFFA55A33));
      expect(peach.value, const Color(0xFF7A3D1E));

      final mint = LuPalettes.stat(LuStatKind.mint);
      expect(mint.fill, const Color(0xFFCFE6C4));
      expect(mint.label, const Color(0xFF3F7A2E));
      expect(mint.value, const Color(0xFF26401C));

      final sky = LuPalettes.stat(LuStatKind.sky);
      expect(sky.fill, const Color(0xFFC7DEF2));
      expect(sky.label, const Color(0xFF3A5A74));
      expect(sky.value, const Color(0xFF16324A));

      final butter = LuPalettes.stat(LuStatKind.butter);
      expect(butter.fill, const Color(0xFFF2D385));
      expect(butter.label, const Color(0xFF8A6A1C));
      expect(butter.value, const Color(0xFF4A3D17));
    });
  });

  group('LuPalettes.medal (fixed tiers)', () {
    test('bronzo gradient and ring', () {
      final tone = LuPalettes.medal(MedalTier.bronzo);

      expect(tone.c1, const Color(0xFFD69457));
      expect(tone.c2, const Color(0xFFA05A2C));
      expect(tone.ring, const Color(0xFFC67F45));
    });

    test('argento gradient and ring', () {
      final tone = LuPalettes.medal(MedalTier.argento);

      expect(tone.c1, const Color(0xFFD3D7DE));
      expect(tone.c2, const Color(0xFF9298A3));
      expect(tone.ring, const Color(0xFFB7BCC5));
    });

    test('oro gradient and ring', () {
      final tone = LuPalettes.medal(MedalTier.oro);

      expect(tone.c1, const Color(0xFFE6C060));
      expect(tone.c2, const Color(0xFFB3831F));
      expect(tone.ring, const Color(0xFFD3A24A));
    });

    test('gradient goes from c1 to c2 along the CSS 155deg line', () {
      final tone = LuPalettes.medal(MedalTier.oro);

      final gradient = tone.gradient;

      expect(gradient.colors, [tone.c1, tone.c2]);
      final end = gradient.end as Alignment;
      expect(end.x, closeTo(.5616, .001));
      expect(end.y, closeTo(1.2044, .001));
      expect(gradient.begin, -end);
    });
  });

  group('LuPalettes.rarity', () {
    const accent = Color(0xFF5988C0);

    test('piccola and media are fixed', () {
      expect(
        LuPalettes.rarity(RewardTier.piccola, accent),
        const Color(0xFF6F9ED6),
      );
      expect(
        LuPalettes.rarity(RewardTier.media, accent),
        const Color(0xFF54C2B4),
      );
    });

    test('grande follows the accent', () {
      expect(LuPalettes.rarity(RewardTier.grande, accent), accent);
    });
  });

  group('LuPalettes functional colours', () {
    test('flame is the streak orange and success the sync green', () {
      expect(LuPalettes.flame, const Color(0xFFE8863A));
      expect(LuPalettes.success, const Color(0xFF3FBF7F));
    });

    test('scrim is dark with the requested alpha and blur 6', () {
      final scrim = LuPalettes.scrim(.9);

      expect(scrim.a, closeTo(.9, .005));
      expect(scrim.r, closeTo(6 / 255, .005));
      expect(LuPalettes.scrimBlur, 6);
    });
  });
}
