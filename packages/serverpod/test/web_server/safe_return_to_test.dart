import 'package:serverpod/src/web_server/safe_return_to.dart';
import 'package:test/test.dart';

void main() {
  group('Given a safeReturnTo candidate', () {
    test('when it is a same-origin path then it is returned.', () {
      expect(safeReturnTo('/account'), '/account');
      expect(safeReturnTo('/account?tab=1'), '/account?tab=1');
    });

    test('when it is null or empty then the fallback is returned.', () {
      expect(safeReturnTo(null), '/');
      expect(safeReturnTo(''), '/');
      expect(safeReturnTo(null, fallback: '/home'), '/home');
    });

    test('when it is an absolute URL then it is rejected.', () {
      expect(safeReturnTo('https://evil.example'), '/');
    });

    test('when it is a protocol-relative URL then it is rejected.', () {
      expect(safeReturnTo('//evil'), '/');
      expect(safeReturnTo('//evil.example/phish'), '/');
    });

    test('when it contains parent-directory segments then it is rejected.', () {
      expect(safeReturnTo('/foo/..//evil.com'), '/');
      expect(safeReturnTo('/foo/../../evil'), '/');
    });

    test('when it contains CR LF then it is rejected.', () {
      expect(safeReturnTo('/ok%0d%0aSet-Cookie:x=1'), '/');
      expect(safeReturnTo('/ok\r\nSet-Cookie:x=1'), '/');
    });

    test('when it contains a backslash then it is rejected.', () {
      expect(safeReturnTo('/ok\\evil'), '/');
      expect(safeReturnTo('/ok%5cevil'), '/');
    });

    test('when it is double-encoded as a protocol-relative URL '
        'then it is rejected.', () {
      expect(safeReturnTo('%252F%252Fevil.example'), '/');
    });

    test('when it exceeds the length limit then it is rejected.', () {
      expect(safeReturnTo('/${'a' * 512}'), '/');
    });

    test('when it has a trailing slash then it is kept.', () {
      expect(safeReturnTo('/account/'), '/account/');
    });

    test('when it has a fragment then the fragment is stripped.', () {
      expect(safeReturnTo('/account#secret'), '/account');
    });

    test('when it has empty middle segments then it is rejected.', () {
      expect(safeReturnTo('/foo//bar'), '/');
    });
  });

  group('Given withReturnToQuery', () {
    test('when the path has no query then it uses ?.', () {
      expect(
        withReturnToQuery('/auth/login', '/account'),
        '/auth/login?return_to=${Uri.encodeQueryComponent('/account')}',
      );
    });

    test('when the path already has a query then it uses &.', () {
      expect(
        withReturnToQuery('/auth/login?from=nav', '/account'),
        '/auth/login?from=nav&return_to=${Uri.encodeQueryComponent('/account')}',
      );
    });
  });

  group('Given trySafeReturnTo', () {
    test('when the candidate is unsafe then it returns null.', () {
      expect(trySafeReturnTo('//evil'), isNull);
      expect(trySafeReturnTo('/foo/..//evil.com'), isNull);
    });

    test('when the candidate is safe then it returns the path.', () {
      expect(trySafeReturnTo('/account'), '/account');
    });
  });
}
