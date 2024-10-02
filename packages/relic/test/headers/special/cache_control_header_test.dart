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

  group('CacheControlHeader Class Tests', () {
    test('CacheControlHeader should parse valid header values correctly', () {
      var headerValue = 'no-cache, no-store, max-age=3600';
      var cacheControlHeader =
          CacheControlHeader.fromHeaderValue([headerValue]);

      expect(cacheControlHeader.noCache, isTrue);
      expect(cacheControlHeader.noStore, isTrue);
      expect(cacheControlHeader.maxAge, equals(3600));
      expect(cacheControlHeader.staleWhileRevalidate, isNull);
    });

    test(
        'CacheControlHeader should handle max-age and stale-while-revalidate values',
        () {
      var headerValue = 'max-age=600, stale-while-revalidate=120';
      var cacheControlHeader =
          CacheControlHeader.fromHeaderValue([headerValue]);

      expect(cacheControlHeader.maxAge, equals(600));
      expect(cacheControlHeader.staleWhileRevalidate, equals(120));
      expect(cacheControlHeader.noCache, isFalse);
      expect(cacheControlHeader.noStore, isFalse);
    });

    test(
        'CacheControlHeader should parse public and private caching directives',
        () {
      var headerValue = 'public, private';
      var cacheControlHeader =
          CacheControlHeader.fromHeaderValue([headerValue]);

      expect(cacheControlHeader.publicCache, isTrue);
      expect(cacheControlHeader.privateCache, isTrue);
      expect(cacheControlHeader.noCache, isFalse);
      expect(cacheControlHeader.noStore, isFalse);
    });

    test(
        'CacheControlHeader should return null when trying to parse a null value',
        () {
      var cacheControlHeader = CacheControlHeader.tryParse(null);
      expect(cacheControlHeader, isNull);
    });

    test('CacheControlHeader should handle an empty string as input', () {
      var cacheControlHeader = CacheControlHeader.fromHeaderValue(['']);
      expect(cacheControlHeader.noCache, isFalse);
      expect(cacheControlHeader.noStore, isFalse);
      expect(cacheControlHeader.maxAge, isNull);
      expect(cacheControlHeader.staleWhileRevalidate, isNull);
    });

    test(
        'CacheControlHeader should return valid string representation of the header',
        () {
      var cacheControlHeader = CacheControlHeader(
        noCache: true,
        noStore: true,
        maxAge: 3600,
        staleWhileRevalidate: 120,
      );
      var result = cacheControlHeader.toString();

      expect(
          result,
          equals(
              'no-cache, no-store, max-age=3600, stale-while-revalidate=120'));
    });
  });

  group('CacheControlHeader HttpRequest Tests', () {
    test(
        'Given headers with no-cache and max-age, it should handle them correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Cache-Control': 'no-cache, max-age=3600'},
      );
      var cacheControlHeader = headers.cacheControl;

      expect(cacheControlHeader!.noCache, isTrue);
      expect(cacheControlHeader.maxAge, equals(3600));
    });

    test(
        'Given headers with no-store and stale-while-revalidate, it should handle them correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Cache-Control': 'no-store, stale-while-revalidate=120'},
      );
      var cacheControlHeader = headers.cacheControl;

      expect(cacheControlHeader!.noStore, isTrue);
      expect(cacheControlHeader.staleWhileRevalidate, equals(120));
    });

    test(
        'Given headers with public and private cache control, it should handle both correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Cache-Control': 'public, private'},
      );
      var cacheControlHeader = headers.cacheControl;

      expect(cacheControlHeader!.publicCache, isTrue);
      expect(cacheControlHeader.privateCache, isTrue);
    });

    test(
        'Given an empty Cache-Control header, it should return a null CacheControlHeader',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Cache-Control': ''},
      );
      var cacheControlHeader = headers.cacheControl;

      expect(cacheControlHeader, isNull);
    });
  });
}
