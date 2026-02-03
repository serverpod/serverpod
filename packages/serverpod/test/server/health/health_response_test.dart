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
  group('Given HealthResponse when alive() is called', () {
    late HealthResponse response;

    setUp(() {
      response = HealthResponse.alive();
    });

    test('then status is pass', () {
      expect(response.status, HealthStatus.pass);
    });

    test('then checks is empty', () {
      expect(response.checks, isEmpty);
    });

    test('then httpStatusCode is 200', () {
      expect(response.httpStatusCode, 200);
    });

    test('then isHealthy is true', () {
      expect(response.isHealthy, isTrue);
    });

    test('then toJson format matches RFC', () {
      final json = response.toJson();

      expect(json['status'], 'pass');
      expect(json['time'], isA<String>());
      expect(() => DateTime.parse(json['time'] as String), returnsNormally);
      expect(json.containsKey('checks'), isFalse);
      expect(json.containsKey('notes'), isFalse);
      expect(json.containsKey('output'), isFalse);
    });
  });

  group(
    'Given all passing results when HealthResponse.fromResults is called',
    () {
      late List<HealthCheckResult> results;
      late HealthResponse response;

      setUp(() {
        results = [
          _pass(name: 'database:connection'),
          _pass(name: 'redis:connection'),
        ];
        response = HealthResponse.fromResults(results);
      });

      test('then status is pass', () {
        expect(response.status, HealthStatus.pass);
      });

      test('then httpStatusCode is 200', () {
        expect(response.httpStatusCode, 200);
      });

      test('then checks contains all results grouped by name', () {
        expect(response.checks, hasLength(2));
        expect(response.checks['database:connection'], hasLength(1));
        expect(response.checks['redis:connection'], hasLength(1));
      });

      test('then notes is null', () {
        expect(response.notes, isNull);
      });

      test('then output is null', () {
        expect(response.output, isNull);
      });

      test('then toJson includes checks', () {
        final json = response.toJson();

        expect(json['checks'], isA<Map>());
        final checks = json['checks'] as Map;
        expect(checks['database:connection'], isA<List>());
        expect(checks['redis:connection'], isA<List>());
      });
    },
  );

  group(
    'Given one failing result when HealthResponse.fromResults is called',
    () {
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

      test('then status is fail', () {
        expect(response.status, HealthStatus.fail);
      });

      test('then httpStatusCode is 503', () {
        expect(response.httpStatusCode, 503);
      });

      test('then notes lists failed check names', () {
        expect(response.notes, contains('database:connection'));
      });

      test('then output contains failure messages', () {
        expect(response.output, contains('Connection refused'));
        expect(response.output, contains('database:connection'));
      });
    },
  );

  group(
    'Given multiple failing results when HealthResponse.fromResults is called',
    () {
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

      test('then notes lists all failed check names', () {
        expect(response.notes, contains('database:connection'));
        expect(response.notes, contains('redis:connection'));
      });

      test('then output contains all failure messages', () {
        expect(response.output, contains('Database timeout'));
        expect(response.output, contains('Redis unavailable'));
      });
    },
  );

  group(
    'Given empty results when HealthResponse.fromResults is called',
    () {
      late HealthResponse response;

      setUp(() {
        response = HealthResponse.fromResults([]);
      });

      test('then status is pass', () {
        expect(response.status, HealthStatus.pass);
      });

      test('then checks is empty', () {
        expect(response.checks, isEmpty);
      });
    },
  );

  group(
    'Given multiple results with same name '
    'when HealthResponse.fromResults is called',
    () {
      test('then results are grouped in same list', () {
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
    },
  );

  group(
    'Given failing result without output '
    'when HealthResponse.fromResults is called',
    () {
      test('then output is null', () {
        final results = [
          _fail(name: 'test:indicator'),
        ];
        final response = HealthResponse.fromResults(results);

        expect(response.output, isNull);
      });
    },
  );
}
