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

  group('CustomHeaders', () {
    test('CustomHeaders should allow adding new headers', () {
      var headers = CustomHeaders.empty();
      var updatedHeaders =
          headers.add('X-Custom-Authorization', ['Bearer token']);

      expect(
        updatedHeaders['x-custom-authorization'],
        equals(['Bearer token']),
      );
    });

    test('CustomHeaders should allow updating existing headers', () {
      var headers = CustomHeaders({
        'X-Custom-Header': ['custom-value'],
      });
      var updatedHeaders = headers.add('X-Custom-Header', ['updated-value']);

      expect(
        updatedHeaders['x-custom-header'],
        equals(['updated-value']),
      );
    });

    test('CustomHeaders should allow removing headers', () {
      var headers = CustomHeaders({
        'X-Custom-Header1': ['custom-value1'],
        'X-Custom-Header2': ['custom-value2'],
      });
      var updatedHeaders = headers.removeKey('X-Custom-Header2');

      expect(updatedHeaders['x-custom-header2'], isNull);
      expect(
        updatedHeaders['x-custom-header1'],
        equals(['custom-value1']),
      );
    });

    test('CustomHeaders copyWith should allow modifying headers', () {
      var headers = CustomHeaders({
        'X-Custom-Header': ['custom-value'],
      });
      var copiedHeaders = headers.copyWith(newHeaders: {
        'X-Custom-Header': ['new-value'],
        'X-Custom-Authorization': ['Bearer token'],
      });

      expect(
        copiedHeaders['x-custom-header'],
        equals(['new-value']),
      );
      expect(
        copiedHeaders['x-custom-authorization'],
        equals(['Bearer token']),
      );
    });

    test('Given headers with multiple values, it should combine them correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'FoO': 'x,y',
          'bAr': 'z',
        },
      );
      var customHeaders = headers.custom;

      expect(
        customHeaders['foo'],
        equals(['x', 'y']),
      );
      expect(
        customHeaders['bar'],
        equals(['z']),
      );
    });

    test(
        'Given headers with empty values, it should ignore the empty values and combine non-empty ones',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'FoO': 'x',
          'bAr': 'z',
        },
      );
      var customHeaders = headers.custom;

      expect(
        customHeaders['foo'],
        equals(['x']),
      );
      expect(
        customHeaders['bar'],
        equals(['z']),
      );
    });

    test(
        'Given headers with multiple managed and custom values, it should correctly separate and handle them',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'X-Custom-Header1': 'value1',
          'bAr': 'z',
        },
      );
      var customHeaders = headers.custom;

      expect(
        customHeaders['x-custom-header1'],
        equals(['value1']),
      );
      expect(
        customHeaders['bar'],
        equals(['z']),
      );
    });

    test(
        'Given headers with a normal format and multiple values, it should handle all custom headers without interference',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'X-Custom-Header1': 'customValue1',
          'X-Custom-Header2': 'customValue2',
        },
      );
      var customHeaders = headers.custom;

      expect(
        customHeaders['x-custom-header1'],
        equals(['customValue1']),
      );
      expect(
        customHeaders['x-custom-header2'],
        equals(['customValue2']),
      );
    });
  });
}
