import 'package:serverpod/src/server/health/health_indicator.dart';
import 'package:serverpod/src/server/health/health_response.dart';
import 'package:test/test.dart';

/// Helper to create passing health check results for testing.
HealthCheckResult _pass({
  required String name,
  String? componentId,
}) {
  return HealthCheckResultInternal.create(
    name: name,
    status: HealthStatus.pass,
    componentId: componentId,
    time: DateTime.now().toUtc(),
  );
}

/// Helper to create failing health check results for testing.
HealthCheckResult _fail({
  required String name,
  String? output,
}) {
  return HealthCheckResultInternal.create(
    name: name,
    status: HealthStatus.fail,
    output: output,
    time: DateTime.now().toUtc(),
  );
}

void main() {
  group('Given HealthResponse.alive()', () {
    test('when created then status is pass', () {
      final response = HealthResponse.alive();

      expect(response.status, HealthStatus.pass);
    });

    test('when created then checks is empty', () {
      final response = HealthResponse.alive();

      expect(response.checks, isEmpty);
    });

    test('when created then httpStatusCode is 200', () {
      final response = HealthResponse.alive();

      expect(response.httpStatusCode, 200);
    });

    test('when created then isHealthy is true', () {
      final response = HealthResponse.alive();

      expect(response.isHealthy, isTrue);
    });

    test('when toJson is called then format matches RFC', () {
      final response = HealthResponse.alive();
      final json = response.toJson();

      expect(json['status'], 'pass');
      expect(json['time'], isA<String>());
      expect(() => DateTime.parse(json['time'] as String), returnsNormally);
      expect(json.containsKey('checks'), isFalse);
      expect(json.containsKey('notes'), isFalse);
      expect(json.containsKey('output'), isFalse);
    });
  });

  group('Given HealthResponse.fromResults with all passing results', () {
    late List<HealthCheckResult> results;
    late HealthResponse response;

    setUp(() {
      results = [
        _pass(name: 'database:connection'),
        _pass(name: 'redis:connection'),
      ];
      response = HealthResponse.fromResults(results);
    });

    test('when created then status is pass', () {
      expect(response.status, HealthStatus.pass);
    });

    test('when created then httpStatusCode is 200', () {
      expect(response.httpStatusCode, 200);
    });

    test('when created then checks contains all results grouped by name', () {
      expect(response.checks, hasLength(2));
      expect(response.checks['database:connection'], hasLength(1));
      expect(response.checks['redis:connection'], hasLength(1));
    });

    test('when created then notes is null', () {
      expect(response.notes, isNull);
    });

    test('when created then output is null', () {
      expect(response.output, isNull);
    });

    test('when toJson is called then checks are included', () {
      final json = response.toJson();

      expect(json['checks'], isA<Map>());
      final checks = json['checks'] as Map;
      expect(checks['database:connection'], isA<List>());
      expect(checks['redis:connection'], isA<List>());
    });
  });

  group('Given HealthResponse.fromResults with one failing result', () {
    late List<HealthCheckResult> results;
    late HealthResponse response;

    setUp(() {
      results = [
        _pass(name: 'redis:connection'),
        _fail(
          name: 'database:connection',
          output: 'Connection refused',
        ),
      ];
      response = HealthResponse.fromResults(results);
    });

    test('when created then status is fail', () {
      expect(response.status, HealthStatus.fail);
    });

    test('when created then httpStatusCode is 503', () {
      expect(response.httpStatusCode, 503);
    });

    test('when created then notes lists failed check names', () {
      expect(response.notes, contains('database:connection'));
    });

    test('when created then output contains failure messages', () {
      expect(response.output, contains('Connection refused'));
      expect(response.output, contains('database:connection'));
    });
  });

  group('Given HealthResponse.fromResults with multiple failing results', () {
    late HealthResponse response;

    setUp(() {
      final results = [
        _fail(
          name: 'database:connection',
          output: 'Database timeout',
        ),
        _fail(
          name: 'redis:connection',
          output: 'Redis unavailable',
        ),
      ];
      response = HealthResponse.fromResults(results);
    });

    test('when created then notes lists all failed check names', () {
      expect(response.notes, contains('database:connection'));
      expect(response.notes, contains('redis:connection'));
    });

    test('when created then output contains all failure messages', () {
      expect(response.output, contains('Database timeout'));
      expect(response.output, contains('Redis unavailable'));
    });
  });

  group('Given HealthResponse.fromResults with empty results', () {
    test('when created then status is pass', () {
      final response = HealthResponse.fromResults([]);

      expect(response.status, HealthStatus.pass);
    });

    test('when created then checks is empty', () {
      final response = HealthResponse.fromResults([]);

      expect(response.checks, isEmpty);
    });
  });

  group('Given HealthResponse.fromResults with multiple results same name', () {
    test('when created then results are grouped in same list', () {
      final results = [
        _pass(
          name: 'database:connection',
          componentId: 'primary',
        ),
        _pass(
          name: 'database:connection',
          componentId: 'replica',
        ),
      ];
      final response = HealthResponse.fromResults(results);

      expect(response.checks, hasLength(1));
      expect(response.checks['database:connection'], hasLength(2));
    });
  });

  group(
    'Given HealthResponse.fromResults with failing result without output',
    () {
      test('when created then output is null', () {
        final results = [
          _fail(name: 'test:indicator'),
        ];
        final response = HealthResponse.fromResults(results);

        expect(response.output, isNull);
      });
    },
  );
}
