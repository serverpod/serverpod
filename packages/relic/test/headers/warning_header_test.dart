import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Warning Header Tests', () {
    test('Given a valid Warning header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('warning', '199 example.com "Miscellaneous warning"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(
          headers.warning, equals(['199 example.com "Miscellaneous warning"']));
    });

    test('Given multiple Warning headers, it should parse all values as a list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('warning', '199 example.com "Miscellaneous warning"')
        ..headers.add('warning', '214 proxy "Transformation applied"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(
          headers.warning,
          equals([
            '199 example.com "Miscellaneous warning"',
            '214 proxy "Transformation applied"'
          ]));
    });

    test('Given no Warning header, it should return null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.warning, isNull);
    });

    test('Given an empty Warning header, it should return an empty list', () {
      var httpRequest = HttpRequestMock()..headers.add('warning', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.warning?.isEmpty, isTrue);
    });

    test(
        'Given a Warning header with a complex structure, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('warning', '199 example.com "Miscellaneous warning"')
        ..headers.add(
          'warning',
          '214 proxy "Transformation applied" "Wed, 21 Oct 2015 07:28:00 GMT"',
        );

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(
        headers.warning,
        equals([
          '199 example.com "Miscellaneous warning"',
          '214 proxy "Transformation applied" "Wed, 21 Oct 2015 07:28:00 GMT"'
        ]),
      );
    });
  });
}
