import 'package:flutter/widgets.dart';
import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/enums.dart' as domain;
import 'package:levelup/domain/game_config.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/today.dart';
import 'package:levelup/l10n/app_localizations.dart';
import 'package:levelup/theme/palettes.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/avatar.dart';
import 'package:levelup/ui/atoms/points_pill.dart';
import 'package:levelup/ui/atoms/progress_bar.dart';
import 'package:levelup/ui/l10n/home_date.dart';
import 'package:levelup/ui/l10n/l10n.dart';
import 'package:levelup/ui/molecules/stat_tile.dart';
import 'package:levelup/ui/motion/pressable.dart';

const _headerGap = Spacing.md;
const _sectionGap = Spacing.lg;
const _statGap = Spacing.sm;
const _barGap = Spacing.md;
const _lineGap = Spacing.sm;
const _textGap = 2.0;

/// Top of the Home: avatar with the level ring, greeting and date, reward
/// points, the four stats of the day and the mission bar.
///
/// Tapping the avatar calls [onProfile], the pill [onRewards] and the stats
/// area (tiles, bar and line) [onMission]. [now] picks the greeting and the
/// date; it is passed in so the block never reads the clock itself.
class HeroBlock extends StatelessWidget {
  const HeroBlock({
    required this.hero,
    required this.summary,
    required this.now,
    this.onProfile,
    this.onRewards,
    this.onMission,
    super.key,
  });

  final GameHero hero;
  final TodaySummary summary;
  final DateTime now;
  final VoidCallback? onProfile;
  final VoidCallback? onRewards;
  final VoidCallback? onMission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = _heroName(hero, l10n);
    final line = l10n.heroMissionProgress(
      summary.doneCount,
      summary.dueCount,
      summary.expLeft,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          hero: hero,
          name: name,
          now: now,
          onProfile: onProfile,
          onRewards: onRewards,
        ),
        const SizedBox(height: _sectionGap),
        Pressable(
          onTap: onMission,
          semanticLabel: onMission == null
              ? null
              : '${l10n.homeOpenMission}. $line',
          scale: PressScale.small,
          child: ExcludeSemantics(
            child: _Mission(hero: hero, summary: summary, line: line),
          ),
        ),
      ],
    );
  }
}

String _heroName(GameHero hero, AppLocalizations l10n) {
  final trimmed = hero.name?.trim() ?? '';
  return trimmed.isEmpty ? l10n.heroFallbackName : trimmed;
}

class _Header extends StatelessWidget {
  const _Header({
    required this.hero,
    required this.name,
    required this.now,
    required this.onProfile,
    required this.onRewards,
  });

  final GameHero hero;
  final String name;
  final DateTime now;
  final VoidCallback? onProfile;
  final VoidCallback? onRewards;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);
    final greeting = switch (greetingPeriodAt(now)) {
      domain.GreetingPeriod.morning => l10n.homeGreetingMorning(name),
      domain.GreetingPeriod.afternoon => l10n.homeGreetingAfternoon(name),
      domain.GreetingPeriod.evening => l10n.homeGreetingEvening(name),
    };
    return Row(
      children: [
        Avatar(
          name: name,
          mode: switch (hero.avatarMode) {
            domain.AvatarMode.initial => AvatarMode.initial,
            domain.AvatarMode.icon => AvatarMode.icon,
          },
          icon: hero.avatarIcon,
          expProgress: _levelProgress(hero),
          onTap: onProfile,
          semanticLabel: onProfile == null ? null : l10n.homeOpenProfile,
        ),
        const SizedBox(width: _headerGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatHomeDate(now, locale),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(color: colors.text2),
              ),
              const SizedBox(height: _textGap),
              Text(
                greeting,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.title.copyWith(color: colors.text),
              ),
            ],
          ),
        ),
        const SizedBox(width: _headerGap),
        PointsPill(
          value: hero.rewardPoints,
          onTap: onRewards,
          semanticLabel: onRewards == null
              ? null
              : l10n.homeOpenRewards(hero.rewardPoints),
        ),
      ],
    );
  }
}

double _levelProgress(GameHero hero) =>
    (hero.exp / GameConfig.standard.expPerLevel).clamp(0.0, 1.0);

class _Mission extends StatelessWidget {
  const _Mission({
    required this.hero,
    required this.summary,
    required this.line,
  });

  final GameHero hero;
  final TodaySummary summary;
  final String line;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final (index, tile) in _tiles(l10n).indexed) ...[
              if (index > 0) const SizedBox(width: _statGap),
              Expanded(child: tile),
            ],
          ],
        ),
        const SizedBox(height: _barGap),
        ProgressBar.quest(value: summary.questPct),
        const SizedBox(height: _lineGap),
        Text(line, style: AppText.caption.copyWith(color: colors.text2)),
      ],
    );
  }

  List<Widget> _tiles(AppLocalizations l10n) => [
    StatTile(
      kind: StatKind.peach,
      label: l10n.statDone,
      value: '${summary.doneCount}',
      total: '${summary.dueCount}',
    ),
    StatTile(
      kind: StatKind.mint,
      label: l10n.statExp,
      value: '${summary.expToday}',
    ),
    StatTile(
      kind: StatKind.sky,
      label: l10n.statStreak,
      value: '${summary.maxStreak}',
    ),
    StatTile(
      kind: StatKind.butter,
      label: l10n.statLevel,
      value: '${hero.level}',
    ),
  ];
}
