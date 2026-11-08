import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:levelup/theme/tokens.dart';

final _reducedShare =
    Motion.reducedFade.inMilliseconds / Motion.riseDuration.inMilliseconds;

/// Page of a full-height sheet: it enters from the bottom with the `rise`
/// curve (380 ms). With reduced motion it only fades, in 150 ms.
CustomTransitionPage<void> risePage({
  required LocalKey key,
  required Widget child,
}) => CustomTransitionPage<void>(
  key: key,
  child: child,
  transitionDuration: Motion.riseDuration,
  reverseTransitionDuration: Motion.riseDuration,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    if (Motion.reduced(context)) {
      return FadeTransition(
        opacity: animation.drive(CurveTween(curve: Interval(0, _reducedShare))),
        child: child,
      );
    }
    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: Motion.rise))
          .drive(Tween(begin: const Offset(0, 1), end: Offset.zero)),
      child: child,
    );
  },
);
