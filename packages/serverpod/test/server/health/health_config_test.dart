import 'package:serverpod/src/server/health/health_config.dart';
import 'package:serverpod/src/server/health/health_indicator.dart';
import 'package:test/test.dart';

/// A minimal health indicator implementation for testing config.
class _TestIndicator extends HealthIndicator {
  final String _name;

  _TestIndicator(this._name);

  @override
  String get name => _name;

  @override
  Future<HealthCheckResult> check() async {
    return HealthCheckResult.pass(name: name);
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

    test('when created then readinessIndicators is empty', () {
      expect(config.readinessIndicators, isEmpty);
    });

    test('when created then startupIndicators is empty', () {
      expect(config.startupIndicators, isEmpty);
    });
  });

  group('Given custom HealthConfig', () {
    test('when created with custom cacheTtl then it is preserved', () {
      const config = HealthConfig(
        cacheTtl: Duration(seconds: 5),
      );

      expect(config.cacheTtl, const Duration(seconds: 5));
    });

    test('when created with readinessIndicators then they are preserved', () {
      final indicators = [
        _TestIndicator('test:one'),
        _TestIndicator('test:two'),
      ];
      final config = HealthConfig(
        readinessIndicators: indicators,
      );

      expect(config.readinessIndicators, hasLength(2));
      expect(config.readinessIndicators[0].name, 'test:one');
      expect(config.readinessIndicators[1].name, 'test:two');
    });

    test('when created with startupIndicators then they are preserved', () {
      final indicators = [
        _TestIndicator('startup:warmup'),
      ];
      final config = HealthConfig(
        startupIndicators: indicators,
      );

      expect(config.startupIndicators, hasLength(1));
      expect(config.startupIndicators[0].name, 'startup:warmup');
    });

    test('when created with all options then all are preserved', () {
      final readinessIndicators = [_TestIndicator('readiness:test')];
      final startupIndicators = [_TestIndicator('startup:test')];
      final config = HealthConfig(
        cacheTtl: const Duration(milliseconds: 500),
        readinessIndicators: readinessIndicators,
        startupIndicators: startupIndicators,
      );

      expect(config.cacheTtl, const Duration(milliseconds: 500));
      expect(config.readinessIndicators, same(readinessIndicators));
      expect(config.startupIndicators, same(startupIndicators));
    });
  });
}
