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

  group('Given a running server with configured authentication', () {
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
      port = pod.server.port;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when calling GET /livez '
      'then response status code is 200',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/livez'),
        );

        expect(response.statusCode, 200);
      },
    );

    test(
      'when calling GET /livez with no authentication '
      'then response has no body',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/livez'),
        );

        expect(response.body, isEmpty);
      },
    );

    test(
      'when calling GET /livez with valid authentication '
      'then response is JSON with status pass',
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

  group('Given a running server with no database', () {
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
      port = pod.server.port;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when calling GET /readyz '
      'then response status code is 200',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
        );

        expect(response.statusCode, 200);
      },
    );

    test(
      'when calling GET /readyz with no authentication '
      'then response has no body',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
        );

        expect(response.body, isEmpty);
      },
    );

    test(
      'when calling GET /readyz with valid authentication '
      'then response is JSON with status pass',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
          headers: {'Authorization': 'Bearer valid'},
        );

        expect(response.statusCode, 200);
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        expect(json['status'], 'pass');
      },
    );
  });

  group('Given a started server', () {
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
      port = pod.server.port;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when calling GET /startupz '
      'then response status code is 200',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/startupz'),
        );

        expect(response.statusCode, 200);
      },
    );

    test(
      'when calling GET /startupz with no authentication '
      'then response has no body',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/startupz'),
        );

        expect(response.body, isEmpty);
      },
    );

    test(
      'when calling GET /startupz with valid authentication '
      'then response includes startup indicator',
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

  group('Given a server with failing startup indicator', () {
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
          additionalStartupIndicators: [failingIndicator],
        ),
      );
      await pod.start();
      port = pod.server.port;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when calling GET /startupz '
      'then response status code is 503',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/startupz'),
        );

        expect(response.statusCode, 503);
      },
    );

    test(
      'when calling GET /startupz with valid authentication '
      'then response includes failure details',
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

  group('Given a server with passing readiness indicator', () {
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
          additionalReadinessIndicators: [indicator],
        ),
      );
      await pod.start();
      port = pod.server.port;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when calling GET /readyz '
      'then response status code is 200',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
        );

        expect(response.statusCode, 200);
      },
    );

    test(
      'when calling GET /readyz with valid authentication '
      'then response includes indicator result',
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

  group('Given a server with failing readiness indicator', () {
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
          additionalReadinessIndicators: [indicator],
        ),
      );
      await pod.start();
      port = pod.server.port;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when calling GET /readyz '
      'then response status code is 503',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
        );

        expect(response.statusCode, 503);
      },
    );

    test(
      'when calling GET /readyz with valid authentication '
      'then response includes failure details',
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

  group('Given a server with caching enabled', () {
    late Serverpod pod;
    late int port;
    late http.Client httpClient;
    late FakeHealthIndicator indicator;

    setUp(() async {
      indicator = FakeHealthIndicator(
        name: 'test:cached',
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
          cacheTtl: const Duration(seconds: 2),
          additionalReadinessIndicators: [indicator],
        ),
      );
      await pod.start();
      port = pod.server.port;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when calling GET /readyz multiple times within cache TTL '
      'then indicator is only called once',
      () async {
        // First request triggers the check
        await httpClient.get(Uri.http('localhost:$port', '/readyz'));
        expect(indicator.checkCount, 1);

        // Second request within TTL should use cached result
        await httpClient.get(Uri.http('localhost:$port', '/readyz'));
        expect(indicator.checkCount, 1);

        // Third request within TTL should still use cached result
        await httpClient.get(Uri.http('localhost:$port', '/readyz'));
        expect(indicator.checkCount, 1);
      },
    );

    test(
      'when calling GET /readyz after cache TTL expires '
      'then indicator is called again',
      () async {
        // First request triggers the check
        await httpClient.get(Uri.http('localhost:$port', '/readyz'));
        expect(indicator.checkCount, 1);

        // Wait for cache to expire (TTL is 2 seconds, wait a bit longer)
        await Future.delayed(const Duration(milliseconds: 2100));

        // Request after TTL should trigger new check
        await httpClient.get(Uri.http('localhost:$port', '/readyz'));
        expect(indicator.checkCount, 2);
      },
    );
  });

  group('Given a server with slow indicator exceeding timeout', () {
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
          additionalReadinessIndicators: [slowIndicator],
        ),
      );
      await pod.start();
      port = pod.server.port;
      httpClient = http.Client();
    });

    tearDown(() async {
      httpClient.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when calling GET /readyz '
      'then indicator times out and returns 503',
      () async {
        final response = await httpClient.get(
          Uri.http('localhost:$port', '/readyz'),
        );

        expect(response.statusCode, 503);
      },
    );

    test(
      'when calling GET /readyz with valid authentication '
      'then response indicates timeout failure',
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
