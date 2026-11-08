import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/enums.dart';

void main() {
  group('greetingPeriodAt', () {
    DateTime at(int hour, [int minute = 0]) =>
        DateTime(2026, 10, 29, hour, minute);

    test('is morning from 05:00 to 11:59', () {
      expect(greetingPeriodAt(at(5)), GreetingPeriod.morning);
      expect(greetingPeriodAt(at(11, 59)), GreetingPeriod.morning);
    });

    test('is afternoon from 12:00 to 17:59', () {
      expect(greetingPeriodAt(at(12)), GreetingPeriod.afternoon);
      expect(greetingPeriodAt(at(17, 59)), GreetingPeriod.afternoon);
    });

    test('is evening from 18:00 through the night until 04:59', () {
      expect(greetingPeriodAt(at(18)), GreetingPeriod.evening);
      expect(greetingPeriodAt(at(23, 59)), GreetingPeriod.evening);
      expect(greetingPeriodAt(at(0)), GreetingPeriod.evening);
      expect(greetingPeriodAt(at(4, 59)), GreetingPeriod.evening);
    });

    test('reads the local hour of a UTC instant', () {
      final utc = DateTime.utc(2026, 10, 29, 9);
      expect(greetingPeriodAt(utc), greetingPeriodAt(utc.toLocal()));
    });
  });

  group('nextGreetingChange', () {
    DateTime at(int hour, [int minute = 0]) =>
        DateTime(2026, 10, 29, hour, minute);

    test('is the next boundary of the day', () {
      expect(nextGreetingChange(at(9)), at(12));
      expect(nextGreetingChange(at(12)), at(18));
      expect(nextGreetingChange(at(17, 59)), at(18));
      expect(nextGreetingChange(at(3)), at(5));
    });

    test('rolls over midnight, when the date changes too', () {
      expect(nextGreetingChange(at(18, 30)), DateTime(2026, 10, 30));
      expect(nextGreetingChange(at(23, 59)), DateTime(2026, 10, 30));
    });

    test('at midnight the next change is 05:00', () {
      expect(nextGreetingChange(at(0)), at(5));
    });
  });
}
