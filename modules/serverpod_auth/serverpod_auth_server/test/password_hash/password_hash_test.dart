import 'package:serverpod_auth_server/src/business/password_hash.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given invalid password hash when instantiating password hash then argument error is thrown.',
      () {
    var passwordHash = r'$invalid$password$hash';
    expect(
      () => PasswordHash(passwordHash, legacySalt: 'salt'),
      throwsArgumentError,
    );
  });
}
