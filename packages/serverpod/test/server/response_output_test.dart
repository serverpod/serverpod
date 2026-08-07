import 'package:relic/relic.dart';
import 'package:serverpod/src/server/response_output.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given nothing queued when applying response output '
    'then the response is unchanged.',
    () {
      var response = Response.ok();
      var result = applyResponseOutput(
        response,
        headers: const {},
        cookies: const [],
      );
      expect(identical(result, response), isTrue);
    },
  );

  test(
    'Given a queued cookie when applying response output '
    'then a Set-Cookie is set.',
    () {
      var result = applyResponseOutput(
        Response.ok(),
        headers: const {},
        cookies: [
          SetCookie(
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
    },
  );

  test(
    'Given multiple queued cookies when applying response output '
    'then each gets its own Set-Cookie.',
    () {
      var result = applyResponseOutput(
        Response.ok(),
        headers: const {},
        cookies: [
          SetCookie(name: 'a', value: '1'),
          SetCookie(name: 'b', value: '2'),
        ],
      );

      var setCookie = result.headers[Headers.setCookieHeader]!.toList();
      expect(setCookie, hasLength(2));
      expect(setCookie[0], contains('a=1'));
      expect(setCookie[1], contains('b=2'));
    },
  );

  test(
    'Given a queued header when applying response output '
    'then the header is set.',
    () {
      var result = applyResponseOutput(
        Response.ok(),
        headers: const {'cache-control': 'no-store'},
        cookies: const [],
      );

      expect(result.headers['cache-control'], ['no-store']);
    },
  );
}
