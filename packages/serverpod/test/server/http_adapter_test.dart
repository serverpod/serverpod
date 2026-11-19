import 'dart:convert';
import 'dart:io';

import 'package:relic_native/relic_native.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/http_adapter.dart';
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';
import 'test_helpers/test_certificate.dart';

final _certificate = PemCertificate(
  certificateChain: utf8.encode(testCertificateChainPem),
  privateKey: utf8.encode(testPrivateKeyPem),
);

final _encryptedCertificate = PemCertificate(
  certificateChain: utf8.encode(testCertificateChainPem),
  privateKey: utf8.encode(testEncryptedPrivateKeyPem),
  password: testPrivateKeyPassword,
);

HttpClient _trustingClient() =>
    HttpClient()
      ..badCertificateCallback = (certificate, _, _) =>
          certificate.pem.trim() == testCertificateChainPem.trim();

Future<int> _get(Uri uri, {HttpClient? client}) async {
  client ??= HttpClient();
  try {
    final response = await (await client.getUrl(uri)).close();
    await response.drain<void>();
    return response.statusCode;
  } finally {
    client.close(force: true);
  }
}

void main() {
  Future<Adapter> bind(
    ServerpodHttpAdapter kind, {
    InternetAddress? address,
    SecurityContext? securityContext,
    PemCertificate? certificate,
  }) => bindHttpAdapter(
    kind: kind,
    serverName: 'Test',
    address: address ?? InternetAddress.loopbackIPv4,
    port: 0,
    securityContext: securityContext,
    certificate: certificate,
  );

  Future<RelicApp> serve(Adapter adapter) async {
    final app = RelicApp()..get('/', (_) => Response.ok());
    await app.run(() => adapter);
    addTearDown(app.close);
    return app;
  }

  group('Given the native HTTP adapter kind,', () {
    test('when binding without TLS, then a NativeAdapter is bound.', () async {
      final adapter = await bind(ServerpodHttpAdapter.native);
      await serve(adapter);

      expect(adapter, isA<NativeAdapter>());
    });

    test(
      'when binding with a PemCertificate, '
      'then a NativeAdapter serves HTTPS.',
      () async {
        final adapter = await bind(
          ServerpodHttpAdapter.native,
          securityContext: SecurityContextConfig.pem(
            apiServer: _certificate,
          ).apiServer,
          certificate: _certificate,
        );
        await serve(adapter);
        final port = adapter.listeners.single.port;

        expect(adapter, isA<NativeAdapter>());
        expect(
          await _get(
            Uri.https('localhost:$port'),
            client: _trustingClient(),
          ),
          200,
        );
      },
    );

    test(
      'when binding with a SecurityContext alone, '
      'then an IOAdapter is bound.',
      () async {
        final adapter = await bind(
          ServerpodHttpAdapter.native,
          securityContext: SecurityContextConfig.pem(
            apiServer: _certificate,
          ).apiServer,
        );
        await serve(adapter);

        expect(adapter, isA<IOAdapter>());
      },
    );
  });

  group('Given the io HTTP adapter kind,', () {
    test('when binding without TLS, then an IOAdapter is bound.', () async {
      final adapter = await bind(ServerpodHttpAdapter.io);
      await serve(adapter);

      expect(adapter, isA<IOAdapter>());
    });

    test(
      'when binding with a PemCertificate, '
      'then an IOAdapter serves HTTPS from the derived SecurityContext.',
      () async {
        final config = SecurityContextConfig.pem(apiServer: _certificate);
        final adapter = await bind(
          ServerpodHttpAdapter.io,
          securityContext: config.apiServer,
          certificate: config.apiServerCertificate,
        );
        await serve(adapter);
        final port = adapter.listeners.single.port;

        expect(adapter, isA<IOAdapter>());
        expect(
          await _get(
            Uri.https('localhost:$port'),
            client: _trustingClient(),
          ),
          200,
        );
      },
    );
  });

  for (final kind in ServerpodHttpAdapter.values) {
    group(
      'Given the ${kind.name} HTTP adapter bound on the IPv6 any address,',
      () {
        test('when an IPv4 client connects, then it is served.', () async {
          final adapter = await bind(kind, address: InternetAddress.anyIPv6);
          await serve(adapter);
          final port = adapter.listeners.single.port;

          expect(await _get(Uri.http('127.0.0.1:$port')), 200);
        });
      },
    );
  }

  group('Given a SecurityContextConfig.pem for the API server,', () {
    test(
      'when read, then it holds the certificate and a SecurityContext.',
      () {
        final config = SecurityContextConfig.pem(apiServer: _certificate);

        expect(config.apiServer, isNotNull);
        expect(config.apiServerCertificate, same(_certificate));
        expect(config.webServer, isNull);
        expect(config.webServerCertificate, isNull);
      },
    );

    test('when the key holds no PEM key, then an ArgumentError is thrown.', () {
      expect(
        () => SecurityContextConfig.pem(
          apiServer: PemCertificate(
            certificateChain: _certificate.certificateChain,
            privateKey: utf8.encode('not a key'),
          ),
        ),
        throwsArgumentError,
      );
    });
  });

  group('Given a pod configured with SecurityContextConfig.pem,', () {
    Future<Serverpod> startPod(
      ServerpodHttpAdapter kind, {
      PemCertificate? certificate,
    }) async {
      final pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: ServerConfig(
            port: 0,
            publicScheme: 'https',
            publicHost: 'localhost',
            publicPort: 0,
          ),
          httpAdapter: kind,
        ),
        securityContextConfig: SecurityContextConfig.pem(
          apiServer: certificate ?? _certificate,
        ),
      );
      await pod.start();
      addTearDown(() => pod.shutdown(exitProcess: false));
      return pod;
    }

    for (final kind in ServerpodHttpAdapter.values) {
      test(
        'when it runs on the ${kind.name} HTTP adapter, '
        'then the API server answers over HTTPS.',
        () async {
          final pod = await startPod(kind);

          expect(
            await _get(
              Uri.https('localhost:${pod.server.port}', '/'),
              client: _trustingClient(),
            ),
            isNot(0),
          );
        },
      );

      test(
        'when it runs on the ${kind.name} HTTP adapter with an encrypted key, '
        'then the API server answers over HTTPS.',
        () async {
          final pod = await startPod(kind, certificate: _encryptedCertificate);

          expect(
            await _get(
              Uri.https('localhost:${pod.server.port}', '/'),
              client: _trustingClient(),
            ),
            isNot(0),
          );
        },
      );
    }

    test(
      'when it runs on the native HTTP adapter, '
      'then plain HTTP to the API server gets the native 400.',
      () async {
        final pod = await startPod(ServerpodHttpAdapter.native);

        expect(await _get(Uri.http('localhost:${pod.server.port}', '/')), 400);
      },
    );
  });
}
