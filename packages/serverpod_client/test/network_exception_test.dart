import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import 'test_utils/test_serverpod_client.dart';

/// An [http.Client] that fails every request with [error].
class _FailingHttpClient extends http.BaseClient {
  final Object error;

  _FailingHttpClient(this.error);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    throw error;
  }
}

void main() {
  group('Given a client whose requests fail with a ClientException', () {
    late TestServerpodClient client;

    setUp(() {
      client = TestServerpodClient(
        host: Uri.http('localhost:8080'),
        httpClientOverride: _FailingHttpClient(
          http.ClientException('Connection failed'),
        ),
      );
    });

    tearDown(() => client.close());

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

    test(
      'when calling an endpoint, '
      'then the thrown exception retains the original error message',
      () async {
        await expectLater(
          client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
          throwsA(
            isA<ServerpodClientNetworkException>().having(
              (e) => e.message,
              'message',
              contains('Connection failed'),
            ),
          ),
        );
      },
    );
  });

  group('Given a client whose requests fail with a TimeoutException', () {
    late TestServerpodClient client;

    setUp(() {
      client = TestServerpodClient(
        host: Uri.http('localhost:8080'),
        httpClientOverride: _FailingHttpClient(TimeoutException('Too slow')),
      );
    });

    tearDown(() => client.close());

    test(
      'when calling an endpoint, '
      'then a ServerpodClientNetworkException is thrown',
      () async {
        await expectLater(
          client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
          throwsA(
            isA<ServerpodClientNetworkException>().having(
              (e) => e.message,
              'message',
              contains('Request timed out'),
            ),
          ),
        );
      },
    );
  });
}
