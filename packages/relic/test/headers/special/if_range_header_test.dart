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

  group('IfRangeHeader Class Tests', () {
    test('If-Range should parse a valid date header correctly', () {
      var headerValue = 'Wed, 21 Oct 2015 07:28:00 GMT';
      var ifRangeHeader = IfRangeHeader.fromHeaderValue(headerValue);

      expect(
        ifRangeHeader.date.toUtc().toIso8601String(),
        equals('2015-10-21T07:28:00.000Z'),
      );
    });

    test('If-Range should return null when trying to parse a null value', () {
      var ifRangeHeader = IfRangeHeader.tryParse(null);
      expect(ifRangeHeader, isNull);
    });

    test('If-Range should return a valid string representation of a date', () {
      var headerValue = 'Wed, 21 Oct 2015 07:28:00 GMT';
      var ifRangeHeader = IfRangeHeader.fromHeaderValue(headerValue);
      var result = ifRangeHeader.toString();

      expect(
        result,
        equals('Wed, 21 Oct 2015 07:28:00 GMT'),
      );
    });
  });

  group('IfRangeHeader HttpRequest Tests', () {
    test('Given a valid date in the If-Range header, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'If-Range': 'Wed, 21 Oct 2015 07:28:00 GMT'},
      );
      var ifRangeHeader = headers.ifRange;

      expect(
        ifRangeHeader!.date.toUtc().toIso8601String(),
        equals('2015-10-21T07:28:00.000Z'),
      );
    });

    test('Given no If-Range header, it should return null', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.ifRange, isNull);
    });
  });
}
