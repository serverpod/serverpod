import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given requireLogin with an unsafe redirectTo '
    'when constructed '
    'then it throws.',
    () {
      expect(
        () => requireLogin(redirectTo: '//evil'),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given requireLogin with a safe redirectTo '
    'when constructed '
    'then it succeeds.',
    () {
      expect(() => requireLogin(redirectTo: '/auth/login'), returnsNormally);
      expect(() => requireLogin(), returnsNormally);
    },
  );
}
