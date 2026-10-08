import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/palettes.dart';

void main() {
  group('Palettes.accent', () {
    test('maps the five accent keys to the design system colours', () {
      expect(Palettes.accent(AccentKey.terra), const Color(0xFFD9614C));
      expect(Palettes.accent(AccentKey.ambra), const Color(0xFFCF9C4D));
      expect(Palettes.accent(AccentKey.salvia), const Color(0xFF5B9C6F));
      expect(Palettes.accent(AccentKey.ardesia), const Color(0xFF5988C0));
      expect(Palettes.accent(AccentKey.rosa), const Color(0xFFC56B7A));
    });
  });

  group('Palettes.stat (fixed pastel)', () {
    test('peach, mint, sky and butter expose fill, label and value', () {
      final peach = Palettes.stat(StatKind.peach);
      expect(peach.fill, const Color(0xFFF6D6C1));
      expect(peach.label, const Color(0xFFA55A33));
      expect(peach.value, const Color(0xFF7A3D1E));

      final mint = Palettes.stat(StatKind.mint);
      expect(mint.fill, const Color(0xFFCFE6C4));
      expect(mint.label, const Color(0xFF3F7A2E));
      expect(mint.value, const Color(0xFF26401C));

      final sky = Palettes.stat(StatKind.sky);
      expect(sky.fill, const Color(0xFFC7DEF2));
      expect(sky.label, const Color(0xFF3A5A74));
      expect(sky.value, const Color(0xFF16324A));

      final butter = Palettes.stat(StatKind.butter);
      expect(butter.fill, const Color(0xFFF2D385));
      expect(butter.label, const Color(0xFF8A6A1C));
      expect(butter.value, const Color(0xFF4A3D17));
    });
  });

  group('Palettes.medal (fixed tiers)', () {
    test('bronzo gradient and ring', () {
      final tone = Palettes.medal(MedalTier.bronzo);

      expect(tone.c1, const Color(0xFFD69457));
      expect(tone.c2, const Color(0xFFA05A2C));
      expect(tone.ring, const Color(0xFFC67F45));
    });

    test('argento gradient and ring', () {
      final tone = Palettes.medal(MedalTier.argento);

      expect(tone.c1, const Color(0xFFD3D7DE));
      expect(tone.c2, const Color(0xFF9298A3));
      expect(tone.ring, const Color(0xFFB7BCC5));
    });

    test('oro gradient and ring', () {
      final tone = Palettes.medal(MedalTier.oro);

      expect(tone.c1, const Color(0xFFE6C060));
      expect(tone.c2, const Color(0xFFB3831F));
      expect(tone.ring, const Color(0xFFD3A24A));
    });

    test('gradient goes from c1 to c2 along the CSS 155deg line', () {
      final tone = Palettes.medal(MedalTier.oro);

      final gradient = tone.gradient;

      expect(gradient.colors, [tone.c1, tone.c2]);
      final end = gradient.end as Alignment;
      expect(end.x, closeTo(.5616, .001));
      expect(end.y, closeTo(1.2044, .001));
      expect(gradient.begin, -end);
    });
  });

  group('Palettes.rarity', () {
    const accent = Color(0xFF5988C0);

    test('piccola and media are fixed', () {
      expect(
        Palettes.rarity(RewardTier.piccola, accent),
        const Color(0xFF6F9ED6),
      );
      expect(
        Palettes.rarity(RewardTier.media, accent),
        const Color(0xFF54C2B4),
      );
    });

    test('grande follows the accent', () {
      expect(Palettes.rarity(RewardTier.grande, accent), accent);
    });
  });

  group('Palettes functional colours', () {
    test('flame is the streak orange and success the sync green', () {
      expect(Palettes.flame, const Color(0xFFE8863A));
      expect(Palettes.success, const Color(0xFF3FBF7F));
    });

    test('scrim is dark with the requested alpha and blur 6', () {
      final scrim = Palettes.scrim(.9);

      expect(scrim.a, closeTo(.9, .005));
      expect(scrim.r, closeTo(6 / 255, .005));
      expect(Palettes.scrimBlur, 6);
    });
  });
}
