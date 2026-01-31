import 'package:serverpod/src/server/health/health_config.dart';
import 'package:serverpod/src/server/health/health_indicator.dart';
import 'package:test/test.dart';

/// A minimal health indicator implementation for testing config.
class _TestIndicator extends HealthIndicator<double> {
  final String _name;

  _TestIndicator(this._name);

  @override
  String get name => _name;

  @override
  Future<HealthCheckResult> check() async {
    return pass();
  }
}

void main() {
  group('Given default HealthConfig', () {
    late HealthConfig config;

    setUp(() {
      config = const HealthConfig();
    });

    test('when created then cacheTtl is 1 second', () {
      expect(config.cacheTtl, const Duration(seconds: 1));
    });

    test('when created then additionalReadinessIndicators is empty', () {
      expect(config.additionalReadinessIndicators, isEmpty);
    });

    test('when created then additionalStartupIndicators is empty', () {
      expect(config.additionalStartupIndicators, isEmpty);
    });
  });

  group('Given custom HealthConfig', () {
    test('when created with custom cacheTtl then it is preserved', () {
      const config = HealthConfig(
        cacheTtl: Duration(seconds: 5),
      );

      expect(config.cacheTtl, const Duration(seconds: 5));
    });

    test(
      'when created with additionalReadinessIndicators then they are preserved',
      () {
        final indicators = [
          _TestIndicator('test:one'),
          _TestIndicator('test:two'),
        ];
        final config = HealthConfig(
          additionalReadinessIndicators: indicators,
        );

        expect(config.additionalReadinessIndicators, hasLength(2));
        expect(config.additionalReadinessIndicators[0].name, 'test:one');
        expect(config.additionalReadinessIndicators[1].name, 'test:two');
      },
    );

    test(
      'when created with additionalStartupIndicators then they are preserved',
      () {
        final indicators = [
          _TestIndicator('startup:warmup'),
        ];
        final config = HealthConfig(
          additionalStartupIndicators: indicators,
        );

        expect(config.additionalStartupIndicators, hasLength(1));
        expect(config.additionalStartupIndicators[0].name, 'startup:warmup');
      },
    );

    test('when created with all options then all are preserved', () {
      final additionalReadinessIndicators = [_TestIndicator('readiness:test')];
      final additionalStartupIndicators = [_TestIndicator('startup:test')];
      final config = HealthConfig(
        cacheTtl: const Duration(milliseconds: 500),
        additionalReadinessIndicators: additionalReadinessIndicators,
        additionalStartupIndicators: additionalStartupIndicators,
      );

      expect(config.cacheTtl, const Duration(milliseconds: 500));
      expect(
        config.additionalReadinessIndicators,
        same(additionalReadinessIndicators),
      );
      expect(
        config.additionalStartupIndicators,
        same(additionalStartupIndicators),
      );
    });
  });
}
