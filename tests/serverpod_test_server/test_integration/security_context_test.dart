import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/web/routes/root.dart';

import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'ssl/ssl_cert.dart';

void main() {
  group('Given an api server', () {
    group('with a security context', () {
      late SecurityContext securityContext;
      late Serverpod serverpod;

      setUpAll(() async {
        securityContext = _createSecurityContext();
        serverpod = IntegrationTestServer.create(
          securityContextConfig: SecurityContextConfig(
            apiServer: securityContext,
          ),
        );

        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server can be accessed over https', () async {
        HttpClientRequest request =
            await HttpClient(context: securityContext).getUrl(
          Uri.https('localhost:${serverpod.server.port}'),
        );
        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over http', () async {
        HttpClientRequest request = await HttpClient().getUrl(
          Uri.http('localhost:${serverpod.server.port}'),
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

      test('then server can be accessed over http', () async {
        HttpClientRequest request = await HttpClient().getUrl(
          Uri.http('localhost:${serverpod.server.port}'),
        );

        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over https', () async {
        var client = HttpClient();

        expect(
          () async => await await client.getUrl(
            Uri.https('localhost:${serverpod.server.port}'),
          ),
          throwsA(isA<HandshakeException>()),
        );
      });
    });
  });

  group('Given a insights server', () {
    group('with a security context', () {
      late SecurityContext securityContext;
      late Serverpod serverpod;

      setUpAll(() async {
        securityContext = _createSecurityContext();
        serverpod = IntegrationTestServer.create(
          securityContextConfig: SecurityContextConfig(
            insightsServer: securityContext,
          ),
        );

        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server can be accessed over https', () async {
        HttpClientRequest request =
            await HttpClient(context: securityContext).getUrl(
          Uri.https('localhost:${serverpod.serviceServer.httpServer.port}'),
        );
        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over http', () async {
        HttpClientRequest request = await HttpClient().getUrl(
          Uri.http('localhost:${serverpod.serviceServer.httpServer.port}'),
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

      test('then server can be accessed over http', () async {
        HttpClientRequest request = await HttpClient().getUrl(
          Uri.http('localhost:${serverpod.serviceServer.httpServer.port}'),
        );

        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over https', () async {
        expect(
          () async => await HttpClient().getUrl(
            Uri.https('localhost:${serverpod.serviceServer.httpServer.port}'),
          ),
          throwsA(isA<HandshakeException>()),
        );
      });
    });
  });

  group('Given a web server', () {
    group('with a security context', () {
      late SecurityContext securityContext;
      late Serverpod serverpod;

      setUpAll(() async {
        securityContext = _createSecurityContext();
        serverpod = IntegrationTestServer.create(
          securityContextConfig: SecurityContextConfig(
            webServer: securityContext,
          ),
        );
        serverpod.webServer.addRoute(RootRoute(), '/');
        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server can be accessed over https', () async {
        HttpClientRequest request =
            await HttpClient(context: securityContext).getUrl(
          Uri.https('localhost:${serverpod.webServer.httpServer.port}'),
        );
        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over http', () async {
        HttpClientRequest request = await HttpClient().getUrl(
          Uri.http('localhost:${serverpod.webServer.httpServer.port}'),
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
      late SecurityContext securityContext;
      late Serverpod serverpod;

      setUpAll(() async {
        securityContext = _createSecurityContext();
        serverpod = IntegrationTestServer.create();

        serverpod.webServer.addRoute(RootRoute(), '/');
        await serverpod.start();
      });

      tearDownAll(() async {
        await serverpod.shutdown(exitProcess: false);
      });

      test('then server can be accessed over http', () async {
        HttpClientRequest request = await HttpClient().getUrl(
          Uri.http('localhost:${serverpod.webServer.httpServer.port}'),
        );

        var response = await request.close();

        expect(response.statusCode, 200);
      });

      test('then server cannot be accessed over https', () async {
        expect(
          () async => await HttpClient(context: securityContext).getUrl(
            Uri.https('localhost:${serverpod.webServer.httpServer.port}'),
          ),
          throwsA(isA<HandshakeException>()),
        );
      });
    });
  });
}

SecurityContext _createSecurityContext() {
  SecurityContext context = SecurityContext(withTrustedRoots: false);
  context.setTrustedCertificatesBytes(Certificate.certChainBytes);
  context.useCertificateChainBytes(Certificate.certChainBytes);
  context.usePrivateKeyBytes(Certificate.certKeyBytes, password: 'dartdart');
  return context;
}
