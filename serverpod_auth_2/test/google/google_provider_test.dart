import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/providers/google/google_account_repository.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';

void main() {
  test('Google based registration', () {
    final serverpod = Serverpod();
    // registers itself with serverpod
    final googleProvider = GoogleAccountRepository(
      serverpod: serverpod,
    );

    googleProvider.getSignInEntryUri();

    final sessionKey = googleProvider.createSessionFromToken('goog:user_1234');

    expect(
      serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
      isNotNull,
    );
    expect(serverpod.userInfoRepository.users, hasLength(1));
  });

  test('Gogle based registration and another login', () {
    final serverpod = Serverpod();
    // registers itself with serverpod
    final googleProvider = GoogleAccountRepository(
      serverpod: serverpod,
    );

    var googleUserIdToken = 'goog:user_1234';

    // initial registration
    {
      googleProvider.getSignInEntryUri();

      final sessionKey =
          googleProvider.createSessionFromToken(googleUserIdToken);

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );

      expect(serverpod.userInfoRepository.users, hasLength(1));
    }

    // another login (same user, new session created)
    {
      googleProvider.getSignInEntryUri();

      final sessionKey = googleProvider.createSessionFromToken(
        googleUserIdToken,
      );

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );

      expect(serverpod.userInfoRepository.users, hasLength(1));
    }
  });

  // TODO: Create example with account merging
}
