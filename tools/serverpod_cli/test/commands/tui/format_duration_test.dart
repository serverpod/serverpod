import 'package:serverpod_cli/src/commands/tui/format_duration.dart';
import 'package:test/test.dart';

void main() {
  group('Given a duration in microseconds', () {
    test('when 500μs then formats as "500μs"', () {
      expect(formatDuration(const Duration(microseconds: 500)), '500μs');
    });

    test('when 0μs then formats as "0μs"', () {
      expect(formatDuration(Duration.zero), '0μs');
    });
  });

  group('Given a duration in milliseconds', () {
    test('when 42ms then formats as "42ms"', () {
      expect(formatDuration(const Duration(milliseconds: 42)), '42ms');
    });

    test('when 999ms then formats as "999ms"', () {
      expect(formatDuration(const Duration(milliseconds: 999)), '999ms');
    });
  });

  group('Given a duration in seconds', () {
    test('when 1.2s then formats as "1.2s"', () {
      expect(formatDuration(const Duration(milliseconds: 1200)), '1.2s');
    });

    test('when 9.9s then formats as "9.9s"', () {
      expect(formatDuration(const Duration(milliseconds: 9900)), '9.9s');
    });

    test('when 10s then formats as "10s"', () {
      expect(formatDuration(const Duration(seconds: 10)), '10s');
    });

    test('when 59s then formats as "59s"', () {
      expect(formatDuration(const Duration(seconds: 59)), '59s');
    });
  });

  group('Given a duration in minutes', () {
    test('when 1m30s then formats as "1m30s"', () {
      expect(formatDuration(const Duration(minutes: 1, seconds: 30)), '1m30s');
    });

    test('when 2m05s then formats as "2m05s"', () {
      expect(formatDuration(const Duration(minutes: 2, seconds: 5)), '2m05s');
    });

    test('when 10m then formats as "10m"', () {
      expect(formatDuration(const Duration(minutes: 10)), '10m');
    });
  });

  group('Given a duration in hours', () {
    test('when 1h5m then formats as "1h5m"', () {
      expect(formatDuration(const Duration(hours: 1, minutes: 5)), '1h5m');
    });
  });
}
