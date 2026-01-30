import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given SessionLogConfig with retention settings', () {
    test(
      'when buildDefault is called then retention settings should have default values.',
      () {
        final config = SessionLogConfig.buildDefault(
          databaseEnabled: true,
          runMode: 'development',
        );

        expect(config.cleanupInterval, equals(const Duration(hours: 24)));
        expect(config.retentionPeriod, equals(const Duration(days: 90)));
        expect(config.retentionCount, equals(100_000));
      },
    );

    test(
      'when custom retention settings are provided then they should be preserved.',
      () {
        final config = SessionLogConfig(
          persistentEnabled: true,
          consoleEnabled: true,
          cleanupInterval: const Duration(hours: 6),
          retentionPeriod: const Duration(days: 30),
          retentionCount: 5000,
        );

        expect(config.cleanupInterval, equals(const Duration(hours: 6)));
        expect(config.retentionPeriod, equals(const Duration(days: 30)));
        expect(config.retentionCount, equals(5000));
      },
    );

    test(
      'when retention settings are null then they should remain null.',
      () {
        final config = SessionLogConfig(
          persistentEnabled: true,
          consoleEnabled: true,
          cleanupInterval: null,
          retentionPeriod: null,
          retentionCount: null,
        );

        expect(config.cleanupInterval, isNull);
        expect(config.retentionPeriod, isNull);
        expect(config.retentionCount, isNull);
      },
    );
  });
}
