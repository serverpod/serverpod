import 'package:serverpod/src/server/request_origin.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Origin header value', () {
    test(
      'when it is mixed case with a trailing slash '
      'then it is lowercased and the slash is dropped.',
      () {
        expect(
          normalizeOriginValue('HTTPS://App.Example.com/'),
          'https://app.example.com',
        );
      },
    );

    test('when it is the literal null then it is preserved.', () {
      expect(normalizeOriginValue('null'), 'null');
    });

    test('when it is blank then it is treated as absent.', () {
      expect(normalizeOriginValue('  '), isNull);
      expect(normalizeOriginValue(null), isNull);
    });
  });
}
