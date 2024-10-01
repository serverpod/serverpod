import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('TE Header Tests', () {
    test('Given a valid TE header with one value, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()..headers.add('te', 'gzip');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.te, equals(['gzip']));
    });

    test(
        'Given a valid TE header with multiple values, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()..headers.add('te', 'gzip, deflate');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.te, equals(['gzip', 'deflate']));
    });

    test('Given multiple TE headers, it should combine and parse all values',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('te', 'gzip')
        ..headers.add('te', 'deflate');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.te, equals(['gzip', 'deflate']));
    });

    test('Given no TE header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'te' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.te, isNull);
    });

    test('Given an empty TE header, it should return an empty list', () {
      var httpRequest = HttpRequestMock()..headers.add('te', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.te, isEmpty);
    });

    test(
        'Given a TE header with multiple values as a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()..headers.add('te', 'gzip, chunked');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.te, equals(['gzip', 'chunked']));
    });
  });
}
