import 'package:serverpod/src/server/future_call_manager/cron.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a valid 5-field cron expression with single value fields, '
    'when parsing, '
    'then all fields are parsed correctly',
    () {
      final schedule = Cron.parse('1 13 3 3 6');
      expect(schedule.seconds, isNull);
      expect(schedule.minutes, [1]);
      expect(schedule.hours, [13]);
      expect(schedule.days, [3]);
      expect(schedule.months, [3]);
      expect(schedule.weekdays, [6]);
    },
  );

  test(
    'Given a valid 5-field cron expression with wildcard fields, '
    'when parsing, '
    'then all fields are parsed correctly',
    () {
      final schedule = Cron.parse('* * * * *');
      expect(schedule.seconds, isNull);
      expect(schedule.minutes, List.generate(60, (i) => i));
      expect(schedule.hours, List.generate(24, (i) => i));
      expect(schedule.days, List.generate(31, (i) => i + 1));
      expect(schedule.months, List.generate(12, (i) => i + 1));
      expect(schedule.weekdays, [7, 1, 2, 3, 4, 5, 6]);
    },
  );

  test(
    'Given a valid 5-field cron expression with a field containing comma-separated values, '
    'when parsing, '
    'then the field is parsed correctly',
    () {
      final schedule = Cron.parse('0,15,30,45 * * * *');
      expect(schedule.minutes, [0, 15, 30, 45]);
    },
  );

  test(
    'Given a valid 5-field cron expression with a field containing an n-th interval, '
    'when parsing, '
    'then the field is parsed correctly',
    () {
      final schedule = Cron.parse('*/15 * * * *');
      expect(schedule.minutes, [0, 15, 30, 45]);
    },
  );

  test(
    'Given a valid 5-field cron expression with a field containing a range, '
    'when parsing, '
    'then the field is parsed correctly',
    () {
      final schedule = Cron.parse('1-5 * * * *');
      expect(schedule.minutes, [1, 2, 3, 4, 5]);
    },
  );

  test(
    'Given a valid 5-field cron expression with a field containing a range interval with increment, '
    'when parsing, '
    'then the field is parsed correctly',
    () {
      final schedule = Cron.parse('0-10/2 * * * *');
      expect(schedule.minutes, [0, 2, 4, 6, 8]);
    },
  );

  test(
    'Given a valid 5-field cron expression with mixed field types, '
    'when parsing, '
    'then all fields are parsed correctly',
    () {
      final schedule = Cron.parse('0-8/4 13 */2 3-6 1,2');
      expect(schedule.seconds, isNull);
      expect(schedule.minutes, [0, 4]);
      expect(schedule.hours, [13]);
      expect(schedule.days, [
        2,
        4,
        6,
        8,
        10,
        12,
        14,
        16,
        18,
        20,
        22,
        24,
        26,
        28,
        30,
      ]);
      expect(schedule.months, [3, 4, 5, 6]);
      expect(schedule.weekdays, [1, 2]);
    },
  );

  test(
    'Given a valid 6-field cron expression with single value fields, '
    'when parsing, '
    'then all fields are parsed correctly',
    () {
      final schedule = Cron.parse('30 1 13 3 3 6');
      expect(schedule.seconds, [30]);
      expect(schedule.minutes, [1]);
      expect(schedule.hours, [13]);
      expect(schedule.days, [3]);
      expect(schedule.months, [3]);
      expect(schedule.weekdays, [6]);
    },
  );

  test(
    'Given a valid 6-field cron expression with wildcard fields, '
    'when parsing, '
    'then all fields are parsed correctly',
    () {
      final schedule = Cron.parse('* * * * * *');
      expect(schedule.seconds, List.generate(60, (i) => i));
      expect(schedule.minutes, List.generate(60, (i) => i));
      expect(schedule.hours, List.generate(24, (i) => i));
      expect(schedule.days, List.generate(31, (i) => i + 1));
      expect(schedule.months, List.generate(12, (i) => i + 1));
      expect(schedule.weekdays, [7, 1, 2, 3, 4, 5, 6]);
    },
  );

  test(
    'Given a valid 6-field cron expression with a field containing comma-separated values, '
    'when parsing, '
    'then the field is parsed correctly',
    () {
      final schedule = Cron.parse('0,15,30,45 * * * * *');
      expect(schedule.seconds, [0, 15, 30, 45]);
    },
  );

  test(
    'Given a valid 6-field cron expression with a field containing an n-th interval, '
    'when parsing, '
    'then the field is parsed correctly',
    () {
      final schedule = Cron.parse('*/15 * * * * *');
      expect(schedule.seconds, [0, 15, 30, 45]);
    },
  );

  test(
    'Given a valid 6-field cron expression with a field containing a range, '
    'when parsing, '
    'then the field is parsed correctly',
    () {
      final schedule = Cron.parse('1-5 * * * * *');
      expect(schedule.seconds, [1, 2, 3, 4, 5]);
    },
  );

  test(
    'Given a valid 6-field cron expression with a field containing a range interval with increment, '
    'when parsing, '
    'then the field is parsed correctly',
    () {
      final schedule = Cron.parse('0-10/2 * * * * *');
      expect(schedule.seconds, [0, 2, 4, 6, 8]);
    },
  );

  test(
    'Given a valid 6-field cron expression with mixed field types, '
    'when parsing, '
    'then all fields are parsed correctly',
    () {
      final schedule = Cron.parse('1,30-31 1 13 */3 3-6 2,4');
      expect(schedule.seconds, [1, 30, 31]);
      expect(schedule.minutes, [1]);
      expect(schedule.hours, [13]);
      expect(schedule.days, [
        3,
        6,
        9,
        12,
        15,
        18,
        21,
        24,
        27,
        30,
      ]);
      expect(schedule.months, [3, 4, 5, 6]);
      expect(schedule.weekdays, [2, 4]);
    },
  );

  test(
    'Given a cron expression with less than 5 fields, '
    'when parsing, '
    'then a CronFormatException is thrown',
    () {
      const expression = '* * *';
      expect(
        () => Cron.parse(expression),
        throwsA(
          isA<CronFormatException>().having(
            (e) => e.toString(),
            'message',
            contains(
              'Invalid cron expression: $expression. Only 5-field and 6-field formats are supported.',
            ),
          ),
        ),
      );
    },
  );

  test(
    'Given a cron expression with more than 6 fields, '
    'when parsing, '
    'then a CronFormatException is thrown',
    () {
      const expression = '* * * * * * *';
      expect(
        () => Cron.parse(expression),
        throwsA(
          isA<CronFormatException>().having(
            (e) => e.toString(),
            'message',
            contains(
              'Invalid cron expression: $expression. Only 5-field and 6-field formats are supported.',
            ),
          ),
        ),
      );
    },
  );

  test(
    'Given a cron expression with an invalid interval, '
    'when parsing, '
    'then a CronFormatException is thrown',
    () {
      expect(
        () => Cron.parse('*/* * * * *'),
        throwsA(
          isA<CronFormatException>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid interval value: * (at character 3)'),
          ),
        ),
      );
    },
  );

  test(
    'Given a cron expression with an interval value less than 1, '
    'when parsing, '
    'then a CronFormatException is thrown',
    () {
      expect(
        () => Cron.parse('* * * * */0 *'),
        throwsA(
          isA<CronFormatException>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid interval value: 0 (at character 11)'),
          ),
        ),
      );
    },
  );

  test(
    'Given a cron expression with an interval containing multiple `/`, '
    'when parsing, '
    'then a CronFormatException is thrown',
    () {
      expect(
        () => Cron.parse('* */2/3 * * *'),
        throwsA(
          isA<CronFormatException>().having(
            (e) => e.toString(),
            'message',
            contains('More than one `/` for an interval (at character 6)'),
          ),
        ),
      );
    },
  );

  test(
    'Given an invalid cron expression, '
    'when parsing, '
    'then a CronFormatException is thrown',
    () {
      const expression = 'invalidExpression';
      expect(
        () => Cron.parse(expression),
        throwsA(
          isA<CronFormatException>().having(
            (e) => e.toString(),
            'message',
            contains(
              'Invalid cron expression: $expression. Only 5-field and 6-field formats are supported.',
            ),
          ),
        ),
      );
    },
  );
}
