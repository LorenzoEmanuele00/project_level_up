import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/game_rules.dart';

/// Whether the machine zone changes its clock in spring 2026 (Europe/Rome:
/// run with `TZ=Europe/Rome`). The DST tests are skipped otherwise.
final _hasDst =
    DateTime(2026, 3, 30).difference(DateTime(2026, 3, 29)).inHours == 23;
const _needsDst = 'needs a zone with daylight saving: run TZ=Europe/Rome';

void main() {
  group('completionWindowStart', () {
    test('is the Monday 00:00 of the previous week', () {
      // Wednesday 2026-03-04.
      expect(
        completionWindowStart(DateTime(2026, 3, 4, 15, 30)),
        DateTime(2026, 2, 23),
      );
    });

    test('on a Monday it is still the Monday a week earlier', () {
      expect(
        completionWindowStart(DateTime(2026, 3, 2, 0, 0)),
        DateTime(2026, 2, 23),
      );
    });

    test('on Sunday just before midnight the week is still the same', () {
      expect(
        completionWindowStart(DateTime(2026, 3, 8, 23, 59, 59)),
        DateTime(2026, 2, 23),
      );
    });

    test('reads a UTC instant in local time', () {
      final local = DateTime(2026, 3, 4, 15);

      expect(
        completionWindowStart(local.toUtc()),
        completionWindowStart(local),
      );
    });

    test('across the spring DST change it is still local midnight', () {
      // Sunday 2026-03-29 is 23 hours long; Monday 2026-03-30 starts a week.
      expect(
        completionWindowStart(DateTime(2026, 3, 30, 9)),
        DateTime(2026, 3, 23),
      );
      expect(
        completionWindowStart(DateTime(2026, 3, 29, 12)),
        DateTime(2026, 3, 16),
      );
    }, skip: _hasDst ? false : _needsDst);

    test('across the autumn DST change it is still local midnight', () {
      expect(
        completionWindowStart(DateTime(2026, 10, 26, 9)),
        DateTime(2026, 10, 19),
      );
      expect(
        completionWindowStart(DateTime(2026, 10, 25, 12)),
        DateTime(2026, 10, 12),
      );
    }, skip: _hasDst ? false : _needsDst);
  });

  group('completionWindowEnd', () {
    test('is the exclusive end of the local day of now', () {
      expect(
        completionWindowEnd(DateTime(2026, 3, 4, 15, 30)),
        DateTime(2026, 3, 5),
      );
    });

    test('at 23:59:59.999 it is the very next midnight', () {
      expect(
        completionWindowEnd(DateTime(2026, 3, 4, 23, 59, 59, 999)),
        DateTime(2026, 3, 5),
      );
    });

    test('at midnight it still covers the whole day', () {
      expect(completionWindowEnd(DateTime(2026, 3, 4)), DateTime(2026, 3, 5));
    });

    test('works on the 23 hour spring DST day', () {
      expect(
        completionWindowEnd(DateTime(2026, 3, 29, 12)),
        DateTime(2026, 3, 30),
      );
    }, skip: _hasDst ? false : _needsDst);

    test('works on the 25 hour autumn DST day', () {
      expect(
        completionWindowEnd(DateTime(2026, 10, 25, 12)),
        DateTime(2026, 10, 26),
      );
    }, skip: _hasDst ? false : _needsDst);
  });
}
