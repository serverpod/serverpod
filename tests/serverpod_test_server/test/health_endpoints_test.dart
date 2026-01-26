import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/fake_health_indicator.dart';
import 'package:test/test.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given /livez endpoint', () {
    late Serverpod pod;
    late int port;
    late http.Client httpClient;

    setUp(() async {
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
        authenticationHandler: (session, token) => Future.value(
          token == 'valid'
              ? AuthenticationInfo('test-user', {}, authId: 'valid')
              : null,
        ),
      );
      await pod.start();
      port = pod.server.port!;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test('when GET request is made then returns 200', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/livez'),
      );

      expect(response.statusCode, 200);
    });

    test('when request has no auth then response has no body', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/livez'),
      );

      expect(response.body, isEmpty);
    });

    test(
      'when request has valid auth then response is JSON with status pass',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/livez'),
          headers: {'Authorization': 'Bearer valid'},
        );

        expect(response.statusCode, 200);
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        expect(json['status'], 'pass');
        expect(json['time'], isA<String>());
      },
    );
  });

  group('Given /readyz endpoint with no database configured', () {
    late Serverpod pod;
    late int port;
    late http.Client httpClient;

    setUp(() async {
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
        authenticationHandler: (session, token) => Future.value(
          token == 'valid'
              ? AuthenticationInfo('test-user', {}, authId: 'valid')
              : null,
        ),
      );
      await pod.start();
      port = pod.server.port!;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test('when GET request is made then returns 200', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/readyz'),
      );

      expect(response.statusCode, 200);
    });

    test('when request has no auth then response has no body', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/readyz'),
      );

      expect(response.body, isEmpty);
    });

    test('when request has valid auth then response is JSON', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/readyz'),
        headers: {'Authorization': 'Bearer valid'},
      );

      expect(response.statusCode, 200);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      expect(json['status'], 'pass');
    });
  });

  group('Given /startupz endpoint after server has started', () {
    late Serverpod pod;
    late int port;
    late http.Client httpClient;

    setUp(() async {
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
        authenticationHandler: (session, token) => Future.value(
          token == 'valid'
              ? AuthenticationInfo('test-user', {}, authId: 'valid')
              : null,
        ),
      );
      await pod.start();
      port = pod.server.port!;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test('when GET request is made then returns 200', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/startupz'),
      );

      expect(response.statusCode, 200);
    });

    test(
      'when request has valid auth then response includes startup indicator',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/startupz'),
          headers: {'Authorization': 'Bearer valid'},
        );

        expect(response.statusCode, 200);
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        expect(json['status'], 'pass');
        expect(json['checks'], isA<Map>());
        final checks = json['checks'] as Map<String, dynamic>;
        expect(checks['serverpod:startup'], isA<List>());
      },
    );
  });

  group('Given server with custom startup indicator that fails', () {
    late Serverpod pod;
    late int port;
    late http.Client httpClient;

    setUp(() async {
      final failingIndicator = FakeHealthIndicator(
        name: 'test:warmup',
        isHealthy: false,
        failureMessage: 'Cache not warmed up',
      );
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
        authenticationHandler: (session, token) => Future.value(
          token == 'valid'
              ? AuthenticationInfo('test-user', {}, authId: 'valid')
              : null,
        ),
        healthConfig: HealthConfig(
          startupIndicators: [failingIndicator],
        ),
      );
      await pod.start();
      port = pod.server.port!;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test('when GET /startupz is made then returns 503', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/startupz'),
      );

      expect(response.statusCode, 503);
    });

    test(
      'when request has valid auth then response includes failure details',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/startupz'),
          headers: {'Authorization': 'Bearer valid'},
        );

        final json = jsonDecode(response.body) as Map<String, dynamic>;
        expect(json['status'], 'fail');
        expect(json['notes'], contains('test:warmup'));
        expect(json['output'], contains('Cache not warmed up'));
      },
    );
  });

  group('Given server with custom readiness indicator that passes', () {
    late Serverpod pod;
    late int port;
    late http.Client httpClient;
    late FakeHealthIndicator indicator;

    setUp(() async {
      indicator = FakeHealthIndicator(
        name: 'test:service',
        isHealthy: true,
      );
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
        authenticationHandler: (session, token) => Future.value(
          token == 'valid'
              ? AuthenticationInfo('test-user', {}, authId: 'valid')
              : null,
        ),
        healthConfig: HealthConfig(
          readinessIndicators: [indicator],
        ),
      );
      await pod.start();
      port = pod.server.port!;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test('when GET /readyz is made then returns 200', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/readyz'),
      );

      expect(response.statusCode, 200);
    });

    test(
      'when request has valid auth then response includes indicator result',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
          headers: {'Authorization': 'Bearer valid'},
        );

        final json = jsonDecode(response.body) as Map<String, dynamic>;
        expect(json['status'], 'pass');
        expect(json['checks'], isA<Map>());
        final checks = json['checks'] as Map<String, dynamic>;
        expect(checks['test:service'], isA<List>());
      },
    );
  });

  group('Given server with custom readiness indicator that fails', () {
    late Serverpod pod;
    late int port;
    late http.Client httpClient;
    late FakeHealthIndicator indicator;

    setUp(() async {
      indicator = FakeHealthIndicator(
        name: 'test:service',
        isHealthy: false,
        failureMessage: 'Service unavailable',
      );
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
        authenticationHandler: (session, token) => Future.value(
          token == 'valid'
              ? AuthenticationInfo('test-user', {}, authId: 'valid')
              : null,
        ),
        healthConfig: HealthConfig(
          readinessIndicators: [indicator],
        ),
      );
      await pod.start();
      port = pod.server.port!;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test('when GET /readyz is made then returns 503', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/readyz'),
      );

      expect(response.statusCode, 503);
    });

    test(
      'when request has valid auth then response includes failure details',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
          headers: {'Authorization': 'Bearer valid'},
        );

        final json = jsonDecode(response.body) as Map<String, dynamic>;
        expect(json['status'], 'fail');
        expect(json['notes'], contains('test:service'));
        expect(json['output'], contains('Service unavailable'));
      },
    );
  });

  group('Given server with slow indicator exceeding timeout', () {
    late Serverpod pod;
    late int port;
    late http.Client httpClient;

    setUp(() async {
      final slowIndicator = FakeHealthIndicator(
        name: 'test:slow',
        isHealthy: true,
        delay: const Duration(seconds: 2),
        timeout: const Duration(milliseconds: 100),
      );
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
        authenticationHandler: (session, token) => Future.value(
          token == 'valid'
              ? AuthenticationInfo('test-user', {}, authId: 'valid')
              : null,
        ),
        healthConfig: HealthConfig(
          readinessIndicators: [slowIndicator],
        ),
      );
      await pod.start();
      port = pod.server.port!;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test('when GET /readyz is made then indicator times out', () async {
      final response = await httpClient.get(
        Uri.http('localhost:$port', '/readyz'),
      );

      expect(response.statusCode, 503);
    });

    test(
      'when request has valid auth then response indicates timeout failure',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
          headers: {'Authorization': 'Bearer valid'},
        );

        final json = jsonDecode(response.body) as Map<String, dynamic>;
        expect(json['status'], 'fail');
        expect(json['output'], contains('timed out'));
      },
    );
  });
}
