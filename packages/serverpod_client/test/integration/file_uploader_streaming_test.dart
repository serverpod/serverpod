@OnPlatform({
  'browser': Skip('HTTP server tests are not supported in browser'),
})
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod_client/src/file_uploader.dart';
import 'package:test/test.dart';

/// Large enough to pass through dart:io's request output buffer.
const _firstChunkSize = 256 * 1024;

final _firstChunk = Uint8List(_firstChunkSize)
  ..fillRange(0, _firstChunkSize, 7);
final _lastChunk = utf8.encode('last-chunk');
final _fileLength = _firstChunk.length + _lastChunk.length;

void main() {
  late _RecordingServer server;

  setUp(() async => server = await _RecordingServer.start());
  tearDown(() async => await server.close());

  test(
    'Given a binary upload description,'
    'when uploading a stream with a length,'
    'then the body is streamed with a Content-Length.',
    () async {
      server.statusCode = 200;
      final uploader = FileUploader(_binaryDescription(server.url));

      final uploaded = await _uploadStreamed(
        server,
        (stream) => uploader.upload(stream, _fileLength),
      );

      expect(uploaded, isTrue);
      expect(server.contentLength, _fileLength);
      expect(server.chunked, isFalse);
      expect(server.body, [..._firstChunk, ..._lastChunk]);
    },
  );

  test(
    'Given a binary upload description with a Content-Length header,'
    'when uploading a stream without a length,'
    'then the body is streamed with that Content-Length.',
    () async {
      server.statusCode = 200;
      final uploader = FileUploader(
        _binaryDescription(
          server.url,
          headers: {'Content-Length': '$_fileLength'},
        ),
      );

      final uploaded = await _uploadStreamed(server, uploader.upload);

      expect(uploaded, isTrue);
      expect(server.contentLength, _fileLength);
      expect(server.chunked, isFalse);
      expect(server.body, [..._firstChunk, ..._lastChunk]);
    },
  );

  test(
    'Given a binary upload description without a Content-Length header,'
    'when uploading a stream without a length,'
    'then the body is streamed using chunked encoding.',
    () async {
      server.statusCode = 200;
      final uploader = FileUploader(_binaryDescription(server.url));

      final uploaded = await _uploadStreamed(server, uploader.upload);

      expect(uploaded, isTrue);
      expect(server.chunked, isTrue);
      expect(server.body, [..._firstChunk, ..._lastChunk]);
    },
  );

  test(
    'Given a multipart upload description,'
    'when uploading a stream with a length,'
    'then the body is streamed with a Content-Length.',
    () async {
      server.statusCode = 204;
      final uploader = FileUploader(_multipartDescription(server.url));

      final uploaded = await _uploadStreamed(
        server,
        (stream) => uploader.upload(stream, _fileLength),
      );

      expect(uploaded, isTrue);
      expect(server.chunked, isFalse);
      expect(server.contentLength, server.body.length);
    },
  );

  test(
    'Given a multipart upload description with a policy pinning the file size,'
    'when uploading a stream without a length,'
    'then the body is streamed with a Content-Length.',
    () async {
      server.statusCode = 204;
      final uploader = FileUploader(
        _multipartDescription(
          server.url,
          minFileSize: _fileLength,
          maxFileSize: _fileLength,
        ),
      );

      final uploaded = await _uploadStreamed(server, uploader.upload);

      expect(uploaded, isTrue);
      expect(server.chunked, isFalse);
      expect(server.contentLength, server.body.length);
    },
  );

  test(
    'Given a multipart upload description with a policy allowing a range of file sizes,'
    'when uploading a stream without a length,'
    'then the buffered body is sent with a Content-Length.',
    () async {
      server.statusCode = 204;
      final uploader = FileUploader(_multipartDescription(server.url));

      final uploaded = await uploader.upload(
        Stream.fromIterable([_firstChunk, _lastChunk]),
      );

      expect(uploaded, isTrue);
      expect(server.chunked, isFalse);
      expect(server.contentLength, server.body.length);
    },
  );

  test(
    'Given a multipart upload description with a malformed policy,'
    'when uploading a stream without a length '
    'then the buffered body is sent with a Content-Length.',
    () async {
      server.statusCode = 204;
      final uploader = FileUploader(
        _multipartDescription(server.url, policy: 'not-a-policy'),
      );

      final uploaded = await uploader.upload(
        Stream.fromIterable([_firstChunk, _lastChunk]),
      );

      expect(uploaded, isTrue);
      expect(server.chunked, isFalse);
      expect(server.contentLength, server.body.length);
    },
  );

  test(
    'Given a multipart upload description,'
    'when the upload completes,'
    'then the response is drained and the connection is released.',
    () async {
      server.statusCode = 204;
      final uploader = FileUploader(_multipartDescription(server.url));

      await uploader.upload(Stream.fromIterable([_lastChunk]));

      await server.awaitNoOpenConnections();
    },
  );
}

/// Uploads the test file through [upload] and fails unless the server
/// receives the first chunk before the source stream is closed.
Future<bool> _uploadStreamed(
  _RecordingServer server,
  Future<bool> Function(Stream<List<int>> stream) upload,
) async {
  final source = StreamController<List<int>>();
  final uploaded = upload(source.stream);

  source.add(_firstChunk);
  await server.receivedBytes(_firstChunkSize ~/ 2);

  source.add(_lastChunk);
  await source.close();
  return uploaded;
}

String _binaryDescription(Uri url, {Map<String, String>? headers}) =>
    jsonEncode({
      'url': url.toString(),
      'type': 'binary',
      'method': 'PUT',
      'file-name': 'file.bin',
      'headers': ?headers,
    });

String _multipartDescription(
  Uri url, {
  int minFileSize = 1,
  int maxFileSize = 10 * 1024 * 1024,
  String? policy,
}) {
  policy ??= base64.encode(
    utf8.encode(
      jsonEncode({
        'expiration': '2030-01-01T00:00:00.000Z',
        'conditions': [
          ['content-length-range', minFileSize, maxFileSize],
        ],
      }),
    ),
  );
  return jsonEncode({
    'url': url.toString(),
    'type': 'multipart',
    'field': 'file',
    'file-name': 'file.bin',
    'request-fields': {'key': 'file.bin', 'Policy': policy},
  });
}

class _RecordingServer {
  final HttpServer _server;
  final _body = BytesBuilder();
  final _waiters = <(int, Completer<void>)>[];

  int statusCode = 200;
  int? contentLength;
  bool? chunked;

  _RecordingServer._(this._server) {
    _server.listen(_handle);
  }

  static Future<_RecordingServer> start() async => _RecordingServer._(
    await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
  );

  Uri get url => Uri.http('${_server.address.host}:${_server.port}', '/');

  List<int> get body => _body.toBytes();

  /// Completes once the client has closed its connection, which `http` only
  /// does once the response stream has been drained.
  Future<void> awaitNoOpenConnections() async {
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (_server.connectionsInfo().total > 0) {
      if (DateTime.now().isAfter(deadline)) {
        fail('Connection was not released after the upload completed.');
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  /// Completes once at least [count] body bytes have been received.
  Future<void> receivedBytes(int count) {
    if (_body.length >= count) return Future.value();
    final completer = Completer<void>();
    _waiters.add((count, completer));
    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => fail('Body was not streamed before the source closed.'),
    );
  }

  Future<void> _handle(HttpRequest request) async {
    contentLength = request.headers.contentLength;
    chunked = request.headers.chunkedTransferEncoding;
    await for (final chunk in request) {
      _body.add(chunk);
      _waiters.removeWhere((waiter) {
        final (count, completer) = waiter;
        if (_body.length < count) return false;
        completer.complete();
        return true;
      });
    }
    request.response.statusCode = statusCode;
    await request.response.close();
  }

  Future<void> close() => _server.close(force: true);
}
