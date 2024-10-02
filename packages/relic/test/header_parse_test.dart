import 'dart:io';
import 'package:relic/src/headers.dart';
import 'package:relic/src/headers/exception/invalid_header_value_exception.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';
import 'static/test_util.dart';

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

  group('Date Header Tests', () {
    test('Given a valid Date header, it should parse correctly', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Date': 'Wed, 21 Oct 2015 07:28:00 GMT'},
      );

      expect(headers.date, isNotNull);
      expect(
        headers.date!.toUtc().toIso8601String(),
        equals('2015-10-21T07:28:00.000Z'),
      );
    });

    test('Given an invalid Date header, it should throw InvalidHeaderValueException in strict mode', () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Date': 'Invalid Date'},
          strictHeaders: true,
        ),
        throwsA(isA<InvalidHeaderValueException>()),
      );
    });

    test('Given a missing Date header, it should return null in non-strict mode', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.date, isNull);
    });
  });

  group('Content-Range Header Tests', () {
    test('Given a valid Content-Range header, it should parse correctly', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Range': 'bytes 0-499/1234'},
      );

      expect(headers.contentRange!.start, equals(0));
      expect(headers.contentRange!.end, equals(499));
      expect(headers.contentRange!.totalSize, equals(1234));
    });

    test('Given an invalid Content-Range header, it should throw InvalidHeaderValueException in strict mode', () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Content-Range': 'invalid-range'},
          strictHeaders: true,
        ),
        throwsA(isA<InvalidHeaderValueException>()),
      );
    });

    test('Given an empty Content-Range header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Range': ''},
      );

      expect(headers.contentRange, isNull);
    });
  });

  group('Content-Disposition Header Tests', () {
    test('Given a valid Content-Disposition header with filename, it should parse correctly', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Disposition': 'attachment; filename="file.txt"'},
      );

      expect(headers.contentDisposition!.filename, equals('file.txt'));
    });

    test('Given an invalid Content-Disposition header, it should throw InvalidHeaderValueException in strict mode', () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Content-Disposition': 'invalid-content-disposition'},
          strictHeaders: true,
        ),
        throwsA(isA<InvalidHeaderValueException>()),
      );
    });

    test('Given an empty Content-Disposition header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Disposition': ''},
      );

      expect(headers.contentDisposition, isNull);
    });
  });

  group('Accept-Encoding Header Tests', () {
    test('Given a valid Accept-Encoding header, it should parse multiple values', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Accept-Encoding': 'gzip, deflate, br'},
      );

      expect(headers.acceptEncoding, equals(['gzip', 'deflate', 'br']));
    });

    test('Given an invalid Accept-Encoding header, it should throw InvalidHeaderValueException in strict mode', () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Accept-Encoding': 'invalid-value'},
          strictHeaders: true,
        ),
        throwsA(isA<InvalidHeaderValueException>()),
      );
    });

    test('Given an empty Accept-Encoding header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Accept-Encoding': ''},
      );

      expect(headers.acceptEncoding, isNull);
    });
  });

  group('Referer Header Tests', () {
    test('Given a valid Referer header, it should parse as URI correctly', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Referer': 'https://example.com'},
      );

      expect(headers.referer!.toString(), equals('https://example.com'));
    });

    test('Given an invalid Referer header, it should throw InvalidHeaderValueException in strict mode', () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Referer': 'invalid-uri'},
          strictHeaders: true,
        ),
        throwsA(isA<InvalidHeaderValueException>()),
      );
    });

    test('Given an empty Referer header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Referer': ''},
      );

      expect(headers.referer, isNull);
    });
  });
}
