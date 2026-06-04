import 'package:relic/relic.dart';
import 'package:serverpod/src/server/response_output.dart';
import 'package:test/test.dart';

void main() {
  group('Given nothing queued', () {
    test('when applying response output then the response is unchanged.', () {
      var response = Response.ok();
      var result = applyResponseOutput(
        response,
        headers: const {},
        cookies: const [],
      );
      expect(identical(result, response), isTrue);
    });
  });

  group('Given a queued cookie', () {
    test('when applying response output then a Set-Cookie is set.', () {
      var result = applyResponseOutput(
        Response.ok(),
        headers: const {},
        cookies: [
          SetCookieHeader(
            name: 'session',
            value: 'abc123',
            httpOnly: true,
            secure: true,
            sameSite: SameSite.lax,
          ),
        ],
      );

      var setCookie = result.headers[Headers.setCookieHeader]!;
      expect(setCookie, hasLength(1));
      expect(setCookie.single, contains('session=abc123'));
      expect(setCookie.single, contains('HttpOnly'));
      expect(setCookie.single, contains('Secure'));
      expect(setCookie.single, contains('SameSite=Lax'));
    });
  });

  group('Given multiple queued cookies', () {
    test(
      'when applying response output then each gets its own Set-Cookie.',
      () {
        var result = applyResponseOutput(
          Response.ok(),
          headers: const {},
          cookies: [
            SetCookieHeader(name: 'a', value: '1'),
            SetCookieHeader(name: 'b', value: '2'),
          ],
        );

        var setCookie = result.headers[Headers.setCookieHeader]!.toList();
        expect(setCookie, hasLength(2));
        expect(setCookie[0], contains('a=1'));
        expect(setCookie[1], contains('b=2'));
      },
    );
  });

  group('Given a queued header', () {
    test('when applying response output then the header is set.', () {
      var result = applyResponseOutput(
        Response.ok(),
        headers: const {'cache-control': 'no-store'},
        cookies: const [],
      );

      expect(result.headers['cache-control'], ['no-store']);
    });
  });
}
