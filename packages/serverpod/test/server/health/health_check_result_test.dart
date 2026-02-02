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
  group('Given a HealthIndicator when pass() is called', () {
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

  group('Given a HealthIndicator when pass() is called with observedValue', () {
    late HealthCheckResult result;

    setUp(() {
      final indicator = _TestIndicator();
      result = indicator.pass(observedValue: 42.5);
    });

    test('then observedValue is included', () {
      expect(result.observedValue, 42.5);
    });

    test('then toJson includes observedValue', () {
      expect(result.toJson()['observedValue'], 42.5);
    });
  });

  group('Given a HealthIndicator when pass() is called with explicit time', () {
    late HealthCheckResult result;
    final explicitTime = DateTime.utc(2024, 1, 15, 10, 30, 0);

    setUp(() {
      final indicator = _TestIndicator();
      result = indicator.pass(time: explicitTime);
    });

    test('then that time is used', () {
      expect(result.time, explicitTime);
    });

    test('then toJson formats time as ISO8601', () {
      expect(result.toJson()['time'], '2024-01-15T10:30:00.000Z');
    });
  });

  group('Given a HealthIndicator when fail() is called', () {
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

  group('Given a HealthIndicator when fail() is called with output', () {
    late HealthCheckResult result;

    setUp(() {
      final indicator = _TestIndicator();
      result = indicator.fail(output: 'Connection refused');
    });

    test('then output is included', () {
      expect(result.output, 'Connection refused');
    });

    test('then toJson includes output', () {
      expect(result.toJson()['output'], 'Connection refused');
    });
  });

  group('Given a HealthCheckResult when toJson() is called', () {
    test('then pass status is serialized as "pass"', () {
      final indicator = _TestIndicator();
      final result = indicator.pass();

      expect(result.toJson()['status'], 'pass');
    });

    test('then fail status is serialized as "fail"', () {
      final indicator = _TestIndicator();
      final result = indicator.fail();

      expect(result.toJson()['status'], 'fail');
    });

    test('then null optional fields are omitted', () {
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

    test('then DateTime observedValue is serialized to ISO8601', () {
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

    test('then all set fields are included', () {
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
}
