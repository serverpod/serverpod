@OnPlatform({
  'browser': Skip('HTTP server tests are not supported in browser'),
})
library;

import 'dart:convert';

import 'package:relic/relic.dart';
import 'package:serverpod_client/src/file_uploader.dart';
import 'package:test/test.dart';

import '../test_utils/test_http_server.dart';

Stream<int> _streamBytes(int count) async* {
  for (var i = 0; i < count; i++) {
    yield i % 256;
  }
}

extension on Stream<int> {
  Stream<List<int>> inChunksOf(int chunkSize) async* {
    var chunk = <int>[];
    await for (final e in this) {
      chunk.add(e);
      if (chunk.length >= chunkSize) {
        yield chunk;
        chunk = <int>[];
      }
    }
    if (chunk.isNotEmpty) yield chunk;
  }
}

void main() {
  group('Given a binary upload endpoint', () {
    late Uri httpHost;
    late Future<void> Function() closeServer;
    late List<int> receivedBytes;

    setUp(() async {
      receivedBytes = [];

      closeServer = await TestHttpServer.startServer(
        httpRequestHandler: (request) async {
          await for (final chunk in request.read()) {
            receivedBytes.addAll(chunk);
          }
          return Response.ok();
        },
        onConnected: (host) => httpHost = host,
      );
    });

    tearDown(() => closeServer());

    test(
      'when uploading a stream without length then the full body is received',
      () async {
        final description = jsonEncode({
          'url': httpHost.toString(),
          'type': 'binary',
        });

        final uploader = FileUploader(description);
        final result = await uploader.upload(
          _streamBytes(512).inChunksOf(64),
        );

        expect(result, isTrue);
        expect(receivedBytes.length, 512);
        for (var i = 0; i < 512; i++) {
          expect(receivedBytes[i], i % 256);
        }
      },
    );

    test(
      'when uploading a stream with length then the full body is received',
      () async {
        final description = jsonEncode({
          'url': httpHost.toString(),
          'type': 'binary',
        });

        final uploader = FileUploader(description);
        final result = await uploader.upload(
          _streamBytes(256).inChunksOf(32),
          256,
        );

        expect(result, isTrue);
        expect(receivedBytes.length, 256);
      },
    );
  });
}
