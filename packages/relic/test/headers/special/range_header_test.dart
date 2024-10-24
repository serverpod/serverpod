import 'dart:io';

import 'package:relic/src/headers.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';

import '../../static/test_util.dart';

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

  group('RangeHeader Class Tests', () {
    test('RangeHeader should parse valid range with start and end', () {
      var headerValue = 'bytes=0-499';
      var rangeHeader = RangeHeader.fromHeaderValue(headerValue);

      expect(rangeHeader.start, equals(0));
      expect(rangeHeader.end, equals(499));
    });

    test('RangeHeader should parse valid range with only start', () {
      var headerValue = 'bytes=500-';
      var rangeHeader = RangeHeader.fromHeaderValue(headerValue);

      expect(rangeHeader.start, equals(500));
      expect(rangeHeader.end, isNull);
    });

    test('RangeHeader should parse valid range with only end', () {
      var headerValue = 'bytes=-500';
      var rangeHeader = RangeHeader.fromHeaderValue(headerValue);

      expect(rangeHeader.start, isNull);
      expect(rangeHeader.end, equals(500));
    });

    test('RangeHeader should throw FormatException for invalid range', () {
      var headerValue = 'invalid-range';

      expect(
        () => RangeHeader.fromHeaderValue(headerValue),
        throwsFormatException,
      );
    });

    test('RangeHeader should return null when parsing a null value', () {
      var rangeHeader = RangeHeader.tryParse(null);
      expect(rangeHeader, isNull);
    });

    test(
        'RangeHeader should return valid string representation for start and end',
        () {
      var rangeHeader = RangeHeader(start: 0, end: 499);
      var result = rangeHeader.toString();

      expect(result, equals('bytes=0-499'));
    });

    test('RangeHeader should return valid string representation for only start',
        () {
      var rangeHeader = RangeHeader(start: 500);
      var result = rangeHeader.toString();

      expect(result, equals('bytes=500-'));
    });

    test('RangeHeader should return valid string representation for only end',
        () {
      var rangeHeader = RangeHeader(end: 500);
      var result = rangeHeader.toString();

      expect(result, equals('bytes=-500'));
    });
  });

  group('RangeHeader HttpRequest Tests', () {
    test('Given a valid Range header, it should parse correctly', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Range': 'bytes=0-499'},
      );
      var rangeHeader = headers.range;

      expect(rangeHeader!.start, equals(0));
      expect(rangeHeader.end, equals(499));
    });

    test('Given a Range header with only start, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Range': 'bytes=500-'},
      );
      var rangeHeader = headers.range;

      expect(rangeHeader!.start, equals(500));
      expect(rangeHeader.end, isNull);
    });

    test('Given a Range header with only end, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Range': 'bytes=-500'},
      );
      var rangeHeader = headers.range;

      expect(rangeHeader!.start, isNull);
      expect(rangeHeader.end, equals(500));
    });

    test('Given an invalid Range header, it should throw FormatException',
        () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Range': 'invalid-range'},
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
