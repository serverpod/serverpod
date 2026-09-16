import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given a started Serverpod with a DatabaseCloudStorage, '
      'when the server is re-injected into a router as on hot reload, ', () {
    late Serverpod pod;

    setUp(() async {
      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
      );
      pod.addCloudStorage(DatabaseCloudStorage('public'));
      await pod.start(runInGuardedZone: false);

      pod.server.injectIn(RelicRouter());
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('then the cloud storage endpoint is still registered.', () {
      expect(pod.endpoints.connectors, contains('serverpod_cloud_storage'));
    });

    test('then a cloud storage request is not answered with 404.', () async {
      final response = await http.get(
        Uri.parse(
          'http://localhost:${pod.server.port}/serverpod_cloud_storage?method=file',
        ),
      );

      expect(response.statusCode, isNot(HttpStatus.notFound));
    });
  });

  group('Given a started Serverpod without a DatabaseCloudStorage, '
      'when the server is re-injected into a router as on hot reload, ', () {
    late Serverpod pod;

    setUp(() async {
      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
      );
      await pod.start(runInGuardedZone: false);

      pod.server.injectIn(RelicRouter());
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('then no cloud storage endpoint is registered.', () {
      expect(
        pod.endpoints.connectors,
        isNot(contains('serverpod_cloud_storage')),
      );
    });
  });
}
