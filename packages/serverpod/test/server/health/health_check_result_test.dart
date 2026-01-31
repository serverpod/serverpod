import 'package:serverpod/src/server/health/health_indicator.dart';
import 'package:test/test.dart';

/// A minimal health indicator for testing result creation.
class _TestIndicator extends HealthIndicator<double> {
  @override
  String get name => 'test:indicator';

  @override
  String get componentType => HealthComponentType.datastore.name;

  @override
  String get observedUnit => 'ms';

  @override
  Future<HealthCheckResult> check() async => pass();
}

void main() {
  group('Given a HealthCheckResult created with pass()', () {
    late _TestIndicator indicator;
    late HealthCheckResult result;

    setUp(() {
      indicator = _TestIndicator();
      result = indicator.pass();
    });

    test('then status is HealthStatus.pass', () {
      expect(result.status, HealthStatus.pass);
    });

    test('then isHealthy is true', () {
      expect(result.isHealthy, isTrue);
    });

    test('then name is set from indicator', () {
      expect(result.name, 'test:indicator');
    });

    test('then componentType is set from indicator', () {
      expect(result.componentType, HealthComponentType.datastore.name);
    });

    test('then observedUnit is set from indicator', () {
      expect(result.observedUnit, 'ms');
    });

    test('then time is set to current UTC time', () {
      final now = DateTime.now().toUtc();
      expect(result.time.difference(now).inSeconds.abs(), lessThan(2));
    });
  });

  group('Given a HealthCheckResult created with pass() and observedValue', () {
    late HealthCheckResult result;

    setUp(() {
      final indicator = _TestIndicator();
      result = indicator.pass(observedValue: 42.5);
    });

    test('then observedValue is included', () {
      expect(result.observedValue, 42.5);
    });

    test('when toJson is called then observedValue is included', () {
      expect(result.toJson()['observedValue'], 42.5);
    });
  });

  group('Given a HealthCheckResult created with pass() and explicit time', () {
    late HealthCheckResult result;
    final explicitTime = DateTime.utc(2024, 1, 15, 10, 30, 0);

    setUp(() {
      final indicator = _TestIndicator();
      result = indicator.pass(time: explicitTime);
    });

    test('then that time is used', () {
      expect(result.time, explicitTime);
    });

    test('when toJson is called then time is ISO8601 formatted', () {
      expect(result.toJson()['time'], '2024-01-15T10:30:00.000Z');
    });
  });

  group('Given a HealthCheckResult created with fail()', () {
    late _TestIndicator indicator;
    late HealthCheckResult result;

    setUp(() {
      indicator = _TestIndicator();
      result = indicator.fail();
    });

    test('then status is HealthStatus.fail', () {
      expect(result.status, HealthStatus.fail);
    });

    test('then isHealthy is false', () {
      expect(result.isHealthy, isFalse);
    });

    test('then name is set from indicator', () {
      expect(result.name, 'test:indicator');
    });

    test('then componentType is set from indicator', () {
      expect(result.componentType, HealthComponentType.datastore.name);
    });
  });

  group('Given a HealthCheckResult created with fail() and output', () {
    late HealthCheckResult result;

    setUp(() {
      final indicator = _TestIndicator();
      result = indicator.fail(output: 'Connection refused');
    });

    test('then output is included', () {
      expect(result.output, 'Connection refused');
    });

    test('when toJson is called then output is included', () {
      expect(result.toJson()['output'], 'Connection refused');
    });
  });

  group('Given a HealthCheckResult toJson()', () {
    test('when status is pass then serialized status is "pass"', () {
      final indicator = _TestIndicator();
      final result = indicator.pass();

      expect(result.toJson()['status'], 'pass');
    });

    test('when status is fail then serialized status is "fail"', () {
      final indicator = _TestIndicator();
      final result = indicator.fail();

      expect(result.toJson()['status'], 'fail');
    });

    test('when optional fields are null then they are omitted', () {
      final result = HealthCheckResultInternal.create(
        name: 'test:indicator',
        status: HealthStatus.pass,
        time: DateTime.now().toUtc(),
      );
      final json = result.toJson();

      expect(json.containsKey('componentId'), isFalse);
      expect(json.containsKey('componentType'), isFalse);
      expect(json.containsKey('observedValue'), isFalse);
      expect(json.containsKey('observedUnit'), isFalse);
      expect(json.containsKey('output'), isFalse);
    });

    test('when observedValue is DateTime then it is serialized to ISO8601', () {
      final dateValue = DateTime.utc(2024, 6, 15, 12, 0, 0);
      final result = HealthCheckResultInternal.create(
        name: 'test:indicator',
        status: HealthStatus.pass,
        observedValue: dateValue,
        time: DateTime.now().toUtc(),
      );
      final json = result.toJson();

      expect(json['observedValue'], '2024-06-15T12:00:00.000Z');
    });

    test('when all fields are set then all are included', () {
      final explicitTime = DateTime.utc(2024, 1, 15, 10, 30, 0);
      final result = HealthCheckResultInternal.create(
        name: 'database:connection',
        status: HealthStatus.fail,
        componentId: 'primary-db',
        componentType: HealthComponentType.datastore.name,
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
