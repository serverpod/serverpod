@OnPlatform({
  'browser': Skip('HTTP server tests are not supported in browser'),
})
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod_client/src/file_uploader.dart';
import 'package:test/test.dart';

const _reason = 'File is larger than the allowed size.';

void main() {
  late _TestServer server;

  setUp(() async => server = await _TestServer.start());
  tearDown(() async => await server.close());

  final file = utf8.encode('file content');

  test(
    'Given a binary upload description and a server accepting the upload '
    'when uploading a stream with a result '
    'then a successful result with the status code is returned.',
    () async {
      server.statusCode = 200;
      server.responseBody = utf8.encode('Stored.');
      final uploader = FileUploader(_binaryDescription(server.url));

      final result = await uploader.uploadWithResult(
        Stream.value(file),
        file.length,
      );

      expect(result.success, isTrue);
      expect(result.statusCode, 200);
      expect(result.reason, isNull);
      expect(result.error, isNull);
    },
  );

  test(
    'Given a binary upload description and a server rejecting the upload '
    'when uploading a stream with a result '
    'then a failed result with the status code and reason is returned.',
    () async {
      server.statusCode = HttpStatus.requestEntityTooLarge;
      server.responseBody = utf8.encode(_reason);
      final uploader = FileUploader(_binaryDescription(server.url));

      final result = await uploader.uploadWithResult(
        Stream.value(file),
        file.length,
      );

      expect(result.success, isFalse);
      expect(result.statusCode, HttpStatus.requestEntityTooLarge);
      expect(result.reason, _reason);
      expect(result.error, isNull);
    },
  );

  test(
    'Given a binary upload description and a server rejecting the upload '
    'when uploading byte data with a result '
    'then a failed result with the status code and reason is returned.',
    () async {
      server.statusCode = HttpStatus.forbidden;
      server.responseBody = utf8.encode(_reason);
      final uploader = FileUploader(_binaryDescription(server.url));

      final result = await uploader.uploadByteDataWithResult(
        ByteData.sublistView(file),
      );

      expect(result.success, isFalse);
      expect(result.statusCode, HttpStatus.forbidden);
      expect(result.reason, _reason);
    },
  );

  test(
    'Given a multipart upload description and a server accepting the upload '
    'when uploading a stream with a result '
    'then a successful result with the status code is returned.',
    () async {
      server.statusCode = HttpStatus.noContent;
      final uploader = FileUploader(_multipartDescription(server.url));

      final result = await uploader.uploadWithResult(
        Stream.value(file),
        file.length,
      );

      expect(result.success, isTrue);
      expect(result.statusCode, HttpStatus.noContent);
    },
  );

  test(
    'Given a multipart upload description and a server rejecting the upload '
    'when uploading a stream with a result '
    'then a failed result with the status code and reason is returned.',
    () async {
      server.statusCode = HttpStatus.badRequest;
      server.responseBody = utf8.encode('<Error>EntityTooLarge</Error>');
      final uploader = FileUploader(_multipartDescription(server.url));

      final result = await uploader.uploadWithResult(
        Stream.value(file),
        file.length,
      );

      expect(result.success, isFalse);
      expect(result.statusCode, HttpStatus.badRequest);
      expect(result.reason, '<Error>EntityTooLarge</Error>');
      expect(result.error, isNull);
    },
  );

  test(
    'Given a server rejecting the upload without a response body '
    'when uploading with a result '
    'then the reason is null.',
    () async {
      server.statusCode = HttpStatus.forbidden;
      final uploader = FileUploader(_binaryDescription(server.url));

      final result = await uploader.uploadWithResult(Stream.value(file));

      expect(result.statusCode, HttpStatus.forbidden);
      expect(result.reason, isNull);
    },
  );

  test(
    'Given a server rejecting the upload with a body that is not valid UTF-8 '
    'when uploading with a result '
    'then the reason is decoded leniently.',
    () async {
      server.statusCode = HttpStatus.forbidden;
      server.responseBody = const [0x6e, 0x6f, 0xff];
      final uploader = FileUploader(_binaryDescription(server.url));

      final result = await uploader.uploadWithResult(Stream.value(file));

      expect(result.statusCode, HttpStatus.forbidden);
      expect(result.reason, 'no\uFFFD');
      expect(result.error, isNull);
    },
  );

  test(
    'Given a server whose rejection cannot be read '
    'when uploading with a result '
    'then a failed result with the status code and error is returned.',
    () async {
      server.statusCode = HttpStatus.forbidden;
      server.failResponseStream = true;
      final uploader = FileUploader(_binaryDescription(server.url));

      final result = await uploader.uploadWithResult(Stream.value(file));

      expect(result.success, isFalse);
      expect(result.statusCode, HttpStatus.forbidden);
      expect(result.error, isNotNull);
    },
  );

  test(
    'Given a server whose acceptance cannot be read '
    'when uploading with a result '
    'then a failed result with the status code and error is returned.',
    () async {
      server.statusCode = 200;
      server.failResponseStream = true;
      final uploader = FileUploader(_binaryDescription(server.url));

      final result = await uploader.uploadWithResult(Stream.value(file));

      expect(result.success, isFalse);
      expect(result.statusCode, 200);
      expect(result.error, isNotNull);
    },
  );

  test(
    'Given an unreachable server '
    'when uploading with a result '
    'then a failed result with the client error is returned.',
    () async {
      final url = server.url;
      await server.close();
      final uploader = FileUploader(_binaryDescription(url));

      final result = await uploader.uploadWithResult(
        Stream.value(file),
        file.length,
      );

      expect(result.success, isFalse);
      expect(result.statusCode, isNull);
      expect(result.reason, isNull);
      expect(result.error, isA<http.ClientException>());
    },
  );

  test(
    'Given a source stream that fails '
    'when uploading with a result '
    'then a failed result with the error of the stream is returned.',
    () async {
      final sourceError = StateError('Could not read the file.');
      final uploader = FileUploader(_binaryDescription(server.url));

      final result = await uploader.uploadWithResult(
        Stream<List<int>>.error(sourceError),
        file.length,
      );

      expect(result.success, isFalse);
      expect(result.statusCode, isNull);
      expect(result.error, same(sourceError));
    },
  );

  test(
    'Given a FileUploader that has already uploaded '
    'when uploading with a result again '
    'then an exception is thrown.',
    () async {
      final uploader = FileUploader(_binaryDescription(server.url));
      await uploader.uploadWithResult(Stream.value(file));

      await expectLater(
        uploader.uploadWithResult(Stream.value(file)),
        throwsA(isA<Exception>()),
      );
    },
  );

  test(
    'Given a server rejecting the upload '
    'when uploading without a result '
    'then false is returned.',
    () async {
      server.statusCode = HttpStatus.forbidden;
      server.responseBody = utf8.encode(_reason);
      final uploader = FileUploader(_binaryDescription(server.url));

      expect(await uploader.upload(Stream.value(file)), isFalse);
    },
  );

  test(
    'Given a server accepting the upload '
    'when uploading byte data without a result '
    'then true is returned.',
    () async {
      server.statusCode = 200;
      final uploader = FileUploader(_binaryDescription(server.url));

      expect(
        await uploader.uploadByteData(ByteData.sublistView(file)),
        isTrue,
      );
    },
  );
}

String _binaryDescription(Uri url) => jsonEncode({
  'url': url.toString(),
  'type': 'binary',
});

String _multipartDescription(Uri url) => jsonEncode({
  'url': url.toString(),
  'type': 'multipart',
  'field': 'file',
  'file-name': 'test.txt',
  'request-fields': {'key': 'uploads/test.txt'},
});

class _TestServer {
  final HttpServer _server;

  int statusCode = 200;
  List<int>? responseBody;

  /// When true, the response is sent with a `Content-Encoding: gzip` header
  /// and a body that is not valid gzip, so the client's response stream
  /// emits an error while decoding it.
  bool failResponseStream = false;

  _TestServer._(this._server) {
    _server.listen(_handle);
  }

  static Future<_TestServer> start() async =>
      _TestServer._(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));

  Uri get url => Uri.http('${_server.address.host}:${_server.port}', '/');

  Future<void> close() => _server.close(force: true);

  Future<void> _handle(HttpRequest request) async {
    await request.drain<void>();
    request.response.statusCode = statusCode;
    if (failResponseStream) {
      request.response.headers.set(HttpHeaders.contentEncodingHeader, 'gzip');
      request.response.add(const [0, 1, 2, 3]);
    } else if (responseBody case final responseBody?) {
      request.response.add(responseBody);
    }
    await request.response.close();
  }
}
