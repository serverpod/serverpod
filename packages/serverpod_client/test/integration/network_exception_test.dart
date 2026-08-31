// The failing connections are set up with real sockets, which requires
// `dart:io`. The platform independent translation of network failures into
// [ServerpodClientNetworkException] is covered by
// `test/network_exception_test.dart`.
@TestOn('vm')
library;

import 'dart:io';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import '../test_utils/test_serverpod_client.dart';

void main() {
  late TestServerpodClient client;

  group('Given a client pointed at a closed port', () {
    setUp(() async {
      var socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      var port = socket.port;
      await socket.close();

      client = TestServerpodClient(
        host: Uri.http('${InternetAddress.loopbackIPv4.host}:$port'),
      );
    });

    test(
      'when calling an endpoint, '
      'then a ServerpodClientNetworkException is thrown',
      () async {
        await expectLater(
          client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
          throwsA(isA<ServerpodClientNetworkException>()),
        );
      },
    );
  });

  group('Given a server that closes the connection before responding', () {
    late ServerSocket serverSocket;

    setUp(() async {
      serverSocket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      serverSocket.listen((socket) => socket.destroy());

      client = TestServerpodClient(
        host: Uri.http(
          '${InternetAddress.loopbackIPv4.host}:${serverSocket.port}',
        ),
      );
    });

    tearDown(() async => await serverSocket.close());

    test(
      'when calling an endpoint, '
      'then a ServerpodClientNetworkException is thrown',
      () async {
        await expectLater(
          client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
          throwsA(isA<ServerpodClientNetworkException>()),
        );
      },
    );
  });
}
