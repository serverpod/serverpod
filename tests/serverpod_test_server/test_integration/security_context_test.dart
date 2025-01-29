import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/web/routes/root.dart';

import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  const certificatePath = 'test_integration/ssl/test_certificate.pem';
  const keyPath = 'test_integration/ssl/test_key.pem';

  group('Given a api server', () {
    group('with a security context', () {
      late Serverpod serverpod;

      setUpAll(() async {
        serverpod = IntegrationTestServer.create(
          apiServerSecurityContext: SecurityContext()
            ..useCertificateChain(certificatePath)
            ..usePrivateKey(keyPath),
        );

        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server is running over https', () {
        expect(serverpod.server.securityContext, isNotNull);
      });

      test('then server can be accessed over https', () async {
        var client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;

        HttpClientRequest request = await client.getUrl(
          Uri.parse('https://localhost:8080'),
        );
        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over http', () async {
        var client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;

        HttpClientRequest request = await client.getUrl(
          Uri.parse('http://localhost:8080'),
        );

        expect(
          () async => await request.close(),
          //Since the server simply drops HTTP connections instead of negotiating SSL,
          //HttpException is the correct error and not HandshakeException.
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('without a security context', () {
      late Serverpod serverpod;

      setUpAll(() async {
        serverpod = IntegrationTestServer.create();

        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server is running over http', () {
        expect(serverpod.server.securityContext, isNull);
      });

      test('then server can be accessed over http', () async {
        var client = HttpClient();

        HttpClientRequest request = await client.getUrl(
          Uri.parse('http://localhost:8080'),
        );

        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over https', () async {
        var client = HttpClient();

        expect(
          () async => await await client.getUrl(
            Uri.parse('https://localhost:8080'),
          ),
          throwsA(isA<HandshakeException>()),
        );
      });
    });
  });

  group('Given a insights server', () {
    group('with a security context', () {
      late Serverpod serverpod;

      setUpAll(() async {
        serverpod = IntegrationTestServer.create(
          insightsServerSecurityContext: SecurityContext()
            ..useCertificateChain(certificatePath)
            ..usePrivateKey(keyPath),
        );

        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server is running over https', () {
        expect(serverpod.serviceServer.securityContext, isNotNull);
      });

      test('then server can be accessed over https', () async {
        var client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;

        HttpClientRequest request = await client.getUrl(
          Uri.parse('https://localhost:8081'),
        );
        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over http', () async {
        var client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;

        HttpClientRequest request = await client.getUrl(
          Uri.parse('http://localhost:8081'),
        );

        expect(
          () async => await request.close(),
          //Since the server simply drops HTTP connections instead of negotiating SSL,
          //HttpException is the correct error and not HandshakeException.
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('without a security context', () {
      late Serverpod serverpod;

      setUpAll(() async {
        serverpod = IntegrationTestServer.create();

        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server is running over http', () {
        expect(serverpod.serviceServer.securityContext, isNull);
      });

      test('then server can be accessed over http', () async {
        var client = HttpClient();

        HttpClientRequest request = await client.getUrl(
          Uri.parse('http://localhost:8081'),
        );

        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over https', () async {
        var client = HttpClient();

        expect(
          () async => await await client.getUrl(
            Uri.parse('https://localhost:8081'),
          ),
          throwsA(isA<HandshakeException>()),
        );
      });
    });
  });

  group('Given a web server', () {
    group('with a security context', () {
      late Serverpod serverpod;

      setUpAll(() async {
        serverpod = IntegrationTestServer.create(
          webServerSecurityContext: SecurityContext()
            ..useCertificateChain(certificatePath)
            ..usePrivateKey(keyPath),
        );
        serverpod.webServer.addRoute(RouteRoot(), '/');
        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server is running over https', () {
        expect(serverpod.webServer.securityContext, isNotNull);
      });

      test('then server can be accessed over https', () async {
        var client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;

        HttpClientRequest request = await client.getUrl(
          Uri.parse('https://localhost:8082'),
        );
        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over http', () async {
        var client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;

        HttpClientRequest request = await client.getUrl(
          Uri.parse('http://localhost:8082'),
        );

        expect(
          () async => await request.close(),
          //Since the server simply drops HTTP connections instead of negotiating SSL,
          //HttpException is the correct error and not HandshakeException.
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('without a security context', () {
      late Serverpod serverpod;

      setUpAll(() async {
        serverpod = IntegrationTestServer.create();

        serverpod.webServer.addRoute(RouteRoot(), '/');
        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server is running over http', () {
        expect(serverpod.server.securityContext, isNull);
      });

      test('then server can be accessed over http', () async {
        var client = HttpClient();

        HttpClientRequest request = await client.getUrl(
          Uri.parse('http://localhost:8082'),
        );

        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over https', () async {
        var client = HttpClient();

        expect(
          () async => await await client.getUrl(
            Uri.parse('https://localhost:8082'),
          ),
          throwsA(isA<HandshakeException>()),
        );
      });
    });
  });
}
