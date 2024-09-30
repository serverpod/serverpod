import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('TransferEncodingHeader Class Tests', () {
    test('TransferEncodingHeader should parse multiple transfer encodings', () {
      var headerValue = 'chunked, gzip';
      var transferEncodingHeader =
          TransferEncodingHeader.fromHeaderValue([headerValue]);

      expect(transferEncodingHeader.encodings.length, equals(2));
      expect(transferEncodingHeader.encodings.contains('chunked'), isTrue);
      expect(transferEncodingHeader.encodings.contains('gzip'), isTrue);
    });

    test('TransferEncodingHeader should parse a single encoding', () {
      var headerValue = 'chunked';
      var transferEncodingHeader =
          TransferEncodingHeader.fromHeaderValue([headerValue]);

      expect(transferEncodingHeader.encodings.length, equals(1));
      expect(transferEncodingHeader.encodings.contains('chunked'), isTrue);
    });

    test('TransferEncodingHeader should handle empty string as input', () {
      var transferEncodingHeader = TransferEncodingHeader.fromHeaderValue(['']);
      expect(transferEncodingHeader.encodings, isEmpty);
    });

    test('TransferEncodingHeader should return null when parsing a null value',
        () {
      var transferEncodingHeader = TransferEncodingHeader.tryParse(null);
      expect(transferEncodingHeader, isNull);
    });

    test('TransferEncodingHeader should contain a specific encoding', () {
      var headerValue = 'chunked, gzip';
      var transferEncodingHeader =
          TransferEncodingHeader.fromHeaderValue([headerValue]);

      expect(transferEncodingHeader.containsEncoding('chunked'), isTrue);
      expect(transferEncodingHeader.containsEncoding('deflate'), isFalse);
    });

    test('TransferEncodingHeader should return valid string representation',
        () {
      var transferEncodingHeader =
          TransferEncodingHeader(encodings: ['chunked', 'gzip']);
      var result = transferEncodingHeader.toString();

      expect(result, equals('chunked, gzip'));
    });
  });

  group('TransferEncodingHeader HttpRequestMock Tests', () {
    test('Given a valid Transfer-Encoding header, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Transfer-Encoding', 'chunked, gzip');

      var headers = Headers.fromHttpRequest(httpRequest);
      var transferEncodingHeader = headers.transferEncoding;

      expect(transferEncodingHeader!.encodings.length, equals(2));
      expect(transferEncodingHeader.encodings.contains('chunked'), isTrue);
      expect(transferEncodingHeader.encodings.contains('gzip'), isTrue);
    });

    test(
        'Given a Transfer-Encoding header with a single encoding, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Transfer-Encoding', 'chunked');

      var headers = Headers.fromHttpRequest(httpRequest);
      var transferEncodingHeader = headers.transferEncoding;

      expect(transferEncodingHeader!.encodings.length, equals(1));
      expect(transferEncodingHeader.encodings.contains('chunked'), isTrue);
    });

    test(
        'Given an empty Transfer-Encoding header, it should return an empty list',
        () {
      var httpRequest = HttpRequestMock()..headers.add('Transfer-Encoding', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      var transferEncodingHeader = headers.transferEncoding;

      expect(transferEncodingHeader!.encodings, isEmpty);
    });
  });
}
