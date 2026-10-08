import 'package:flutter/painting.dart';

/// Type scale of the design system (Space Mono only). Styles carry no colour:
/// the component applies it from `context.lu`.
abstract final class LuText {
  static const _family = 'SpaceMono';

  static const display = TextStyle(
    fontFamily: _family,
    fontSize: 52,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -1.04,
  );

  static const levelXl = TextStyle(
    fontFamily: _family,
    fontSize: 42,
    fontWeight: FontWeight.w700,
    height: 1,
  );

  static const title = TextStyle(
    fontFamily: _family,
    fontSize: 27,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  static const section = TextStyle(
    fontFamily: _family,
    fontSize: 21,
    fontWeight: FontWeight.w700,
  );

  static const sheetTitle = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const label = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const body = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const caption = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const overline = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.68,
  );

  static const micro = TextStyle(
    fontFamily: _family,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: .3,
  );

  static const all = [
    display,
    levelXl,
    title,
    section,
    sheetTitle,
    label,
    body,
    caption,
    overline,
    micro,
  ];

  /// Overline copy is always upper case.
  static String upper(String text) => text.toUpperCase();
}
