import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:levelup/app/router.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/today.dart';
import 'package:levelup/state/game_providers.dart';
import 'package:levelup/state/today_providers.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/l10n/l10n.dart';
import 'package:levelup/ui/molecules/empty_state.dart';
import 'package:levelup/ui/molecules/habit_tile.dart';
import 'package:levelup/ui/molecules/section_header.dart';
import 'package:levelup/ui/motion/entrance.dart';
import 'package:levelup/ui/organisms/hero_block.dart';

const _heroBlockIndex = 0;
const _headerBlockIndex = 1;
const _firstTileIndex = 2;
const _blockGap = Spacing.x2;
const _headerGap = Spacing.md;
const _tilesPerRow = 2;

/// The Home ("Oggi"): hero block with the day stats and the grid of the
/// habits due today. Completing a habit and opening one come with later
/// cards, so the tiles are inert for now.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hero = ref.watch(heroProvider);
    final summary = ref.watch(todaySummaryProvider);
    final loadedHero = hero.value;
    final loadedSummary = summary.value;

    final Widget body;
    if (hero.hasError || summary.hasError) {
      body = const _LoadError();
    } else if (loadedHero == null || loadedSummary == null) {
      body = const SizedBox.shrink();
    } else {
      body = _HomeContent(
        hero: loadedHero,
        summary: loadedSummary,
        now: ref.watch(greetingClockProvider),
      );
    }
    return Scaffold(body: SafeArea(child: body));
  }
}

/// Opens a sheet over the Home, unless one is already open or opening: a quick
/// double tap must not stack two copies of the same sheet.
void _open(BuildContext context, String path) {
  final router = GoRouter.of(context);
  if (router.routerDelegate.currentConfiguration.uri.path != AppRoutes.home) {
    return;
  }
  router.push(path);
}

class _LoadError extends StatelessWidget {
  const _LoadError();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Spacing.x2),
      child: Text(
        context.l10n.homeLoadError,
        textAlign: TextAlign.center,
        style: AppText.body.copyWith(color: context.colors.text2),
      ),
    ),
  );
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.hero,
    required this.summary,
    required this.now,
  });

  final GameHero hero;
  final TodaySummary summary;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final habits = summary.dueHabits;
    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        Entrance(
          index: _heroBlockIndex,
          child: HeroBlock(
            hero: hero,
            summary: summary,
            now: now,
            onProfile: () => _open(context, AppRoutes.profile),
            onRewards: () => _open(context, AppRoutes.rewards),
            onMission: () => _open(context, AppRoutes.mission),
          ),
        ),
        const SizedBox(height: _blockGap),
        Entrance(
          index: _headerBlockIndex,
          child: SectionHeader(
            title: l10n.homeTodayTitle,
            actionLabel: l10n.homeSeeAll,
            onAction: () => _open(context, AppRoutes.habits),
          ),
        ),
        const SizedBox(height: _headerGap),
        for (var start = 0; start < habits.length; start += _tilesPerRow)
          _TileRow(
            habits: habits.skip(start).take(_tilesPerRow).toList(),
            firstIndex: _firstTileIndex + start,
          ),
        if (summary.allDone) EmptyState(title: l10n.homeAllDone),
      ],
    );
  }
}

class _TileRow extends StatelessWidget {
  const _TileRow({required this.habits, required this.firstIndex});

  final List<DueHabit> habits;
  final int firstIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.gridGap),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < _tilesPerRow; i++) ...[
              if (i > 0) const SizedBox(width: Spacing.gridGap),
              Expanded(
                child: i < habits.length
                    ? Entrance(
                        key: ValueKey(habits[i].habit.id),
                        kind: EntranceKind.itemIn,
                        index: firstIndex + i,
                        child: HabitTile(
                          habit: habits[i].habit,
                          done: habits[i].done,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
