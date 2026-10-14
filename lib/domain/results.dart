import 'package:levelup/domain/models.dart';

/// Outcome of trying to complete a habit.
sealed class CompletionResult {
  const CompletionResult();
}

/// The habit was completed: the updated state and what to show the user.
final class Completed extends CompletionResult {
  const Completed({
    required this.hero,
    required this.habit,
    required this.completion,
    required this.feedback,
  });

  final GameHero hero;
  final Habit habit;
  final Completion completion;
  final CompletionFeedback feedback;
}

/// The habit was already completed today: nothing changes.
final class AlreadyDoneToday extends CompletionResult {
  const AlreadyDoneToday();
}

/// The habit is archived and cannot be completed.
final class HabitArchived extends CompletionResult {
  const HabitArchived();
}

/// What to celebrate after a completion.
sealed class CompletionFeedback {
  const CompletionFeedback();
}

/// EXP earned, no level up.
final class ExpGained extends CompletionFeedback {
  const ExpGained({required this.exp, required this.habitName});

  final int exp;
  final String habitName;
}

/// At least one level up happened.
final class LevelledUp extends CompletionFeedback {
  const LevelledUp({
    required this.levelsGained,
    required this.rpGained,
    required this.newLevel,
  });

  final int levelsGained;
  final int rpGained;
  final int newLevel;
}

/// Outcome of trying to redeem a reward.
sealed class RedeemResult {
  const RedeemResult();
}

/// The reward was redeemed: the hero after paying and the receipt.
final class Redeemed extends RedeemResult {
  const Redeemed({required this.hero, required this.redemption});

  final GameHero hero;
  final Redemption redemption;
}

/// Not enough reward points; [missing] more are needed.
final class InsufficientPoints extends RedeemResult {
  const InsufficientPoints({required this.missing});

  final int missing;
}
