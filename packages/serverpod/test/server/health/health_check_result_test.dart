import 'package:serverpod/src/server/health/health_indicator.dart';
import 'package:test/test.dart';

void main() {
  group('Given a passing health check result', () {
    test('when created with pass() then status is HealthStatus.pass', () {
      final result = HealthCheckResult.pass(name: 'test:indicator');

      expect(result.status, HealthStatus.pass);
    });

    test('when created with pass() then isHealthy is true', () {
      final result = HealthCheckResult.pass(name: 'test:indicator');

      expect(result.isHealthy, isTrue);
    });

    test('when toJson is called then status is "pass"', () {
      final result = HealthCheckResult.pass(name: 'test:indicator');

      expect(result.toJson()['status'], 'pass');
    });

    test('when toJson is called then time is ISO8601 formatted', () {
      final result = HealthCheckResult.pass(name: 'test:indicator');
      final json = result.toJson();

      expect(json['time'], isA<String>());
      expect(() => DateTime.parse(json['time'] as String), returnsNormally);
    });

    test('when created with observedValue then toJson includes it', () {
      final result = HealthCheckResult.pass(
        name: 'test:indicator',
        observedValue: 42.5,
        observedUnit: 'ms',
      );
      final json = result.toJson();

      expect(json['observedValue'], 42.5);
      expect(json['observedUnit'], 'ms');
    });

    test(
      'when created with componentId and componentType then toJson includes them',
      () {
        final result = HealthCheckResult.pass(
          name: 'test:indicator',
          componentId: 'primary-db',
          componentType: 'datastore',
        );
        final json = result.toJson();

        expect(json['componentId'], 'primary-db');
        expect(json['componentType'], 'datastore');
      },
    );

    test('when created without optional fields then toJson omits them', () {
      final result = HealthCheckResult.pass(name: 'test:indicator');
      final json = result.toJson();

      expect(json.containsKey('componentId'), isFalse);
      expect(json.containsKey('componentType'), isFalse);
      expect(json.containsKey('observedValue'), isFalse);
      expect(json.containsKey('observedUnit'), isFalse);
      expect(json.containsKey('output'), isFalse);
    });

    test('when created with explicit time then that time is used', () {
      final explicitTime = DateTime.utc(2024, 1, 15, 10, 30, 0);
      final result = HealthCheckResult.pass(
        name: 'test:indicator',
        time: explicitTime,
      );

      expect(result.time, explicitTime);
      expect(result.toJson()['time'], '2024-01-15T10:30:00.000Z');
    });
  });

  group('Given a failing health check result', () {
    test('when created with fail() then status is HealthStatus.fail', () {
      final result = HealthCheckResult.fail(name: 'test:indicator');

      expect(result.status, HealthStatus.fail);
    });

    test('when created with fail() then isHealthy is false', () {
      final result = HealthCheckResult.fail(name: 'test:indicator');

      expect(result.isHealthy, isFalse);
    });

    test('when toJson is called then status is "fail"', () {
      final result = HealthCheckResult.fail(name: 'test:indicator');

      expect(result.toJson()['status'], 'fail');
    });

    test('when created with output then toJson includes it', () {
      final result = HealthCheckResult.fail(
        name: 'test:indicator',
        output: 'Connection refused',
      );
      final json = result.toJson();

      expect(json['output'], 'Connection refused');
    });

    test('when created with all fields then toJson includes them', () {
      final explicitTime = DateTime.utc(2024, 1, 15, 10, 30, 0);
      final result = HealthCheckResult.fail(
        name: 'database:connection',
        componentId: 'primary-db',
        componentType: 'datastore',
        observedValue: 5000.0,
        observedUnit: 'ms',
        output: 'Connection timeout after 5000ms',
        time: explicitTime,
      );
      final json = result.toJson();

      expect(json['componentId'], 'primary-db');
      expect(json['componentType'], 'datastore');
      expect(json['observedValue'], 5000.0);
      expect(json['observedUnit'], 'ms');
      expect(json['status'], 'fail');
      expect(json['time'], '2024-01-15T10:30:00.000Z');
      expect(json['output'], 'Connection timeout after 5000ms');
    });
  });

  group('Given HealthStatus enum', () {
    test('when pass.name is called then returns "pass"', () {
      expect(HealthStatus.pass.name, 'pass');
    });

    test('when fail.name is called then returns "fail"', () {
      expect(HealthStatus.fail.name, 'fail');
    });
  });
}
