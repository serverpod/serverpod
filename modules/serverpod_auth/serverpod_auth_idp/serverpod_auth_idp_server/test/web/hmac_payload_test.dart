import 'package:clock/clock.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

void main() {
  const pepper = 'test-pepper';

  test(
    'Given a payload, when encoded and decoded with the same pepper, '
    'then the original fields are returned.',
    () {
      final token = encodeHmacPayload(
        {'state': 'abc', 'return_to': '/account'},
        pepper,
      );
      final decoded = decodeHmacPayload(token, pepper);
      expect(decoded, isNotNull);
      expect(decoded!['state'], 'abc');
      expect(decoded['return_to'], '/account');
      expect(decoded['iat'], isA<int>());
    },
  );

  test(
    'Given a token, when decoded with a different pepper, then null is returned.',
    () {
      final token = encodeHmacPayload({'state': 'abc'}, pepper);
      expect(decodeHmacPayload(token, 'other'), isNull);
    },
  );

  test(
    'Given a token, when the payload is tampered with, then null is returned.',
    () {
      final token = encodeHmacPayload({'return_to': '/ok'}, pepper);
      final parts = token.split('.');
      final tampered = encodeHmacPayload({
        'return_to': 'https://evil',
      }, 'wrong');
      final forged = '${parts[0]}.${tampered.split('.')[1]}';
      expect(decodeHmacPayload(forged, pepper), isNull);
    },
  );

  test(
    'Given a token older than maxAge, when decoded, then null is returned.',
    () {
      late String token;
      withClock(Clock.fixed(DateTime.utc(2020)), () {
        token = encodeHmacPayload({'state': 'abc'}, pepper);
      });
      withClock(Clock.fixed(DateTime.utc(2020, 1, 1, 0, 15)), () {
        expect(
          decodeHmacPayload(
            token,
            pepper,
            maxAge: const Duration(minutes: 10),
          ),
          isNull,
        );
      });
    },
  );

  test(
    'Given unequal strings, when compared with timingSafeEquals, then false.',
    () {
      expect(timingSafeEquals('abc', 'abd'), isFalse);
      expect(timingSafeEquals('abc', 'ab'), isFalse);
      expect(timingSafeEquals('abc', 'abc'), isTrue);
    },
  );
}
