import 'dart:ui';

const _black = Color(0xFF000000);
const _white = Color(0xFFFFFFFF);

/// Darkens [colour] towards black by [amount] (0..1) when positive, lightens
/// it towards white by `-amount` when negative.
Color shade(Color colour, double amount) {
  if (amount == 0) return colour;
  final target = amount > 0 ? _black : _white;
  return Color.lerp(colour, target, amount.abs()) ?? colour;
}
