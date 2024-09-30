import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
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

  group('ContentDispositionHeader HttpRequestMock Tests', () {
    test(
        'Given a valid Content-Disposition header with attachment and filename, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Content-Disposition', 'attachment; filename="file.txt"');

      var headers = Headers.fromHttpRequest(httpRequest);
      var contentDispositionHeader = headers.contentDisposition;

      expect(contentDispositionHeader!.type, equals('attachment'));
      expect(contentDispositionHeader.filename, equals('file.txt'));
    });

    test(
        'Given a Content-Disposition header with inline type and no filename, it should handle it correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Content-Disposition', 'inline');

      var headers = Headers.fromHttpRequest(httpRequest);
      var contentDispositionHeader = headers.contentDisposition;

      expect(contentDispositionHeader!.type, equals('inline'));
      expect(contentDispositionHeader.filename, isNull);
    });

    test(
        'Given an empty Content-Disposition header, it should throw FormatException',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Content-Disposition', '');

      expect(
        () => Headers.fromHttpRequest(httpRequest).contentDisposition,
        throwsFormatException,
      );
    });
  });
}
