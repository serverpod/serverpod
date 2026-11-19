@OnPlatform({
  'browser': Skip('WebSocket tests are not supported in browser'),
})
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import '../test_utils/test_serverpod_client.dart';

/// A self-signed certificate for `localhost` that is valid until 2126.
const _certificate = '''
-----BEGIN CERTIFICATE-----
MIIBejCCASCgAwIBAgIUIPZJuiVgsJr4sNHQv66ifgfbCw4wCgYIKoZIzj0EAwIw
FDESMBAGA1UEAwwJbG9jYWxob3N0MCAXDTI2MTEwNzA2MTMzNFoYDzIxMjYxMDE0
MDYxMzM0WjAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwWTATBgcqhkjOPQIBBggqhkjO
PQMBBwNCAATKBfe1ih3pmTXKhYe7x3WNQIdMUr5J+fzxxJNSdQ86NTVMi3Ao5qq4
LX8y/cISJRcTcttyrAKiXEGwbIVAFm+To04wTDAdBgNVHQ4EFgQUPRsPoZsWhUPr
+XDxDftkI5q+rhEwDwYDVR0TAQH/BAUwAwEB/zAaBgNVHREEEzARgglsb2NhbGhv
c3SHBH8AAAEwCgYIKoZIzj0EAwIDSAAwRQIhAL3pMm/htCnr4sL7Kogrb280HUNp
heMNqAcfiyADbAedAiBvYPLe6FhYlFAke2R+Ls4uvt0vphVKPZxkVCIUfqgrPg==
-----END CERTIFICATE-----
''';

const _privateKey = '''
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgQ4+3hp3u0GsTbm4G
22rro4IRCUY7z4O4l0pN6kyDizuhRANCAATKBfe1ih3pmTXKhYe7x3WNQIdMUr5J
+fzxxJNSdQ86NTVMi3Ao5qq4LX8y/cISJRcTcttyrAKiXEGwbIVAFm+T
-----END PRIVATE KEY-----
''';

void main() {
  group('Given a WebSocket server with a self-signed certificate', () {
    late _SecureWebSocketServer server;

    setUp(() async => server = await _SecureWebSocketServer.start());
    tearDown(() async => await server.close());

    test(
      'when a client with a security context trusting it opens a method stream '
      'then the stream is opened on the server.',
      () async {
        final client = _createClient(
          server,
          securityContext: _trustingSecurityContext(),
        );
        addTearDown(client.close);

        final openedMethodStream = server.openedMethodStreams.first;

        unawaited(_openMethodStream(client).drain<void>().catchError((_) {}));

        await expectLater(
          openedMethodStream,
          completion(isA<OpenMethodStreamCommand>()),
        );
      },
    );

    test(
      'when a client with a security context trusting it reconnects after '
      'closing its method streams '
      'then the stream is opened on the server again.',
      () async {
        final client = _createClient(
          server,
          securityContext: _trustingSecurityContext(),
        );
        addTearDown(client.close);
        final openedMethodStreams = server.openedMethodStreams.take(2).toList();

        unawaited(_openMethodStream(client).drain<void>().catchError((_) {}));
        await server.openedMethodStreams.first;
        await client.closeStreamingMethodConnections();

        unawaited(_openMethodStream(client).drain<void>().catchError((_) {}));

        await expectLater(openedMethodStreams, completion(hasLength(2)));
      },
    );

    test(
      'when a client with a security context trusting it is closed '
      'then it no longer opens method streams.',
      () async {
        final client = _createClient(
          server,
          securityContext: _trustingSecurityContext(),
        );

        client.close();

        await expectLater(
          _openMethodStream(client),
          emitsError(isStateError),
        );
        expect(server.upgradedConnections, 0);
      },
    );

    test(
      'when a client without a security context opens a method stream '
      'then the connection is rejected.',
      () async {
        final client = _createClient(server);
        addTearDown(client.close);

        await expectLater(
          _openMethodStream(client),
          emitsError(isA<WebSocketConnectException>()),
        );
        expect(server.upgradedConnections, 0);
      },
    );
  });
}

TestServerpodClient _createClient(
  _SecureWebSocketServer server, {
  SecurityContext? securityContext,
}) => TestServerpodClient(
  host: Uri.https('localhost:${server.port}'),
  securityContext: securityContext,
);

Stream<int> _openMethodStream(TestServerpodClient client) =>
    client.callStreamingServerEndpoint<Stream<int>, int>(
      'endpoint',
      'method',
      {},
      {},
      authenticated: false,
    );

SecurityContext _trustingSecurityContext() =>
    SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(utf8.encode(_certificate));

class _SecureWebSocketServer {
  final HttpServer _server;
  final _openedMethodStreams =
      StreamController<OpenMethodStreamCommand>.broadcast();

  int upgradedConnections = 0;

  _SecureWebSocketServer._(this._server) {
    _server.listen(_handleRequest);
  }

  static Future<_SecureWebSocketServer> start() async {
    final context = SecurityContext(withTrustedRoots: false)
      ..useCertificateChainBytes(utf8.encode(_certificate))
      ..usePrivateKeyBytes(utf8.encode(_privateKey));

    return _SecureWebSocketServer._(
      await HttpServer.bindSecure(InternetAddress.loopbackIPv4, 0, context),
    );
  }

  int get port => _server.port;

  Stream<OpenMethodStreamCommand> get openedMethodStreams =>
      _openedMethodStreams.stream;

  Future<void> close() async {
    await _server.close(force: true);
    await _openedMethodStreams.close();
  }

  Future<void> _handleRequest(HttpRequest request) async {
    final webSocket = await WebSocketTransformer.upgrade(request);
    upgradedConnections++;

    await for (final event in webSocket) {
      final message = WebSocketMessage.fromJsonString(
        event as String,
        TestSerializationManager(),
      );
      if (message is PingCommand) {
        webSocket.add(PongCommand.buildMessage());
      } else if (message is OpenMethodStreamCommand) {
        _openedMethodStreams.add(message);
        webSocket.add(
          OpenMethodStreamResponse.buildMessage(
            connectionId: message.connectionId,
            endpoint: message.endpoint,
            method: message.method,
            responseType: OpenMethodStreamResponseType.success,
          ),
        );
      }
    }
  }
}
