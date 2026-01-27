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

        expect(config.retentionPeriodDays, equals(90));
        expect(config.retentionCount, equals(10000));
        expect(config.cleanupIntervalHours, isNull);
      },
    );

    test(
      'when custom retention settings are provided then they should be preserved.',
      () {
        final config = SessionLogConfig(
          persistentEnabled: true,
          consoleEnabled: true,
          retentionPeriodDays: 30,
          retentionCount: 5000,
          cleanupIntervalHours: 6,
        );

        expect(config.retentionPeriodDays, equals(30));
        expect(config.retentionCount, equals(5000));
        expect(config.cleanupIntervalHours, equals(6));
      },
    );

    test(
      'when retention settings are null then they should remain null.',
      () {
        final config = SessionLogConfig(
          persistentEnabled: true,
          consoleEnabled: true,
          retentionPeriodDays: null,
          retentionCount: null,
          cleanupIntervalHours: null,
        );

        expect(config.retentionPeriodDays, isNull);
        expect(config.retentionCount, isNull);
        expect(config.cleanupIntervalHours, isNull);
      },
    );
  });
}
