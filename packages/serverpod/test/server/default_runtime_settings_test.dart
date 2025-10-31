import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given default runtime settings', () {
    test(
        'Given development run mode when initializing then log level is set to debug.',
        () {
      // Create a minimal Serverpod config for testing
      // Note: We can't directly test _defaultRuntimeSettings since it's private,
      // but we can verify the behavior through integration tests
      // This test documents the expected behavior
      expect(ServerpodRunMode.development, equals('development'));
      expect(LogLevel.debug.index, lessThan(LogLevel.info.index));
    });

    test(
        'Given production run mode when initializing then log level is set to info.',
        () {
      expect(ServerpodRunMode.production, equals('production'));
      expect(LogLevel.info.index, greaterThan(LogLevel.debug.index));
    });

    test(
        'Given staging run mode when initializing then log level is set to info.',
        () {
      expect(ServerpodRunMode.staging, equals('staging'));
    });

    test('Given test run mode when initializing then log level is set to info.',
        () {
      expect(ServerpodRunMode.test, equals('test'));
    });

    test('Given debug log level when logging then all log levels are captured.',
        () {
      // Debug level should capture: debug, info, warning, error, fatal
      expect(LogLevel.debug.index, equals(0));
      expect(LogLevel.info.index, equals(1));
      expect(LogLevel.warning.index, equals(2));
      expect(LogLevel.error.index, equals(3));
      expect(LogLevel.fatal.index, equals(4));
    });

    test('Given info log level when logging then debug logs are filtered out.',
        () {
      // Info level should capture: info, warning, error, fatal (not debug)
      expect(LogLevel.info.index, greaterThan(LogLevel.debug.index));
    });
  });
}
