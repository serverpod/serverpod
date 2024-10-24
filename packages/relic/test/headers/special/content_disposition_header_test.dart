import 'dart:io';
import 'package:relic/src/headers.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';

import '../../test_util.dart';

void main() {
  late RelicServer server;

  setUp(() async {
    try {
      server = await RelicServer.bind(InternetAddress.loopbackIPv6, 0);
    } on SocketException catch (_) {
      server = await RelicServer.bind(InternetAddress.loopbackIPv4, 0);
    }
  });

  tearDown(() => server.close());

  group('ContentDispositionHeader Class Tests', () {
    test(
        'ContentDispositionHeader should parse valid Content-Disposition header with inline type',
        () {
      var headerValue = 'inline';
      var contentDispositionHeader =
          ContentDispositionHeader.fromHeaderValue([headerValue]);

      expect(contentDispositionHeader.type, equals('inline'));
      expect(contentDispositionHeader.filename, isNull);
    });

    test(
        'ContentDispositionHeader should parse valid Content-Disposition header with attachment type and filename',
        () {
      var headerValue = 'attachment; filename="file.txt"';
      var contentDispositionHeader =
          ContentDispositionHeader.fromHeaderValue([headerValue]);

      expect(contentDispositionHeader.type, equals('attachment'));
      expect(contentDispositionHeader.filename, equals('file.txt'));
    });

    test(
        'ContentDispositionHeader should handle filename with spaces and quotes',
        () {
      var headerValue = 'attachment; filename="my file with spaces.txt"';
      var contentDispositionHeader =
          ContentDispositionHeader.fromHeaderValue([headerValue]);

      expect(contentDispositionHeader.type, equals('attachment'));
      expect(
          contentDispositionHeader.filename, equals('my file with spaces.txt'));
    });

    test(
        'ContentDispositionHeader should return null when trying to parse a null value',
        () {
      var contentDispositionHeader = ContentDispositionHeader.tryParse(null);
      expect(contentDispositionHeader, isNull);
    });

    test(
        'ContentDispositionHeader should return valid string representation of the header without filename',
        () {
      var contentDispositionHeader = ContentDispositionHeader(type: 'inline');
      var result = contentDispositionHeader.toString();

      expect(result, equals('inline'));
    });

    test(
        'ContentDispositionHeader should return valid string representation of the header with filename',
        () {
      var contentDispositionHeader =
          ContentDispositionHeader(type: 'attachment', filename: 'file.txt');
      var result = contentDispositionHeader.toString();

      expect(result, equals('attachment; filename="file.txt"'));
    });
  });

  group('ContentDispositionHeader HttpRequest Tests', () {
    test(
        'Given a valid Content-Disposition header with attachment and filename, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Disposition': 'attachment; filename="file.txt"'},
      );
      var contentDispositionHeader = headers.contentDisposition;

      expect(contentDispositionHeader!.type, equals('attachment'));
      expect(contentDispositionHeader.filename, equals('file.txt'));
    });

    test(
        'Given a Content-Disposition header with inline type and no filename, it should handle it correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Disposition': 'inline'},
      );
      var contentDispositionHeader = headers.contentDisposition;

      expect(contentDispositionHeader!.type, equals('inline'));
      expect(contentDispositionHeader.filename, isNull);
    });

    test('Given an empty Content-Disposition header, it should return null',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Disposition': ''},
      );
      var contentDispositionHeader = headers.contentDisposition;

      expect(contentDispositionHeader, isNull);
    });
  });
}
