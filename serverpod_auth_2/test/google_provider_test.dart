import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/providers/google/google.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';

void main() {
  test('Google based registration', () {
    final serverpod = Serverpod();
    // registers itself with serverpod
    final googleProvider = GoogleAccountProvider(
      serverpod: serverpod,
    );

    googleProvider.getSignInEntryUri();

    final session = googleProvider.createSessionFromToken('goog:user_1234');

    expect(session, isA<ActiveUserSession>());

    expect(serverpod.userInfoRepository.users, hasLength(1));
    expect(serverpod.userSessionRepository.activeSessions, hasLength(1));
    expect(serverpod.userSessionRepository.pendingSessions, isEmpty);
  });

  test('Gogle based registration and another login', () {
    final serverpod = Serverpod();
    // registers itself with serverpod
    final googleProvider = GoogleAccountProvider(
      serverpod: serverpod,
    );

    var googleUserIdToken = 'goog:user_1234';

    // initial registration
    {
      googleProvider.getSignInEntryUri();

      final session = googleProvider.createSessionFromToken(googleUserIdToken);

      expect(session, isA<ActiveUserSession>());

      expect(serverpod.userInfoRepository.users, hasLength(1));
      expect(serverpod.userSessionRepository.activeSessions, hasLength(1));
      expect(serverpod.userSessionRepository.pendingSessions, isEmpty);
    }

    // another login (same user, new session created)
    {
      googleProvider.getSignInEntryUri();

      final session = googleProvider.createSessionFromToken(googleUserIdToken);

      expect(session, isA<ActiveUserSession>());

      expect(serverpod.userInfoRepository.users, hasLength(1));
      expect(serverpod.userSessionRepository.activeSessions, hasLength(2));
      expect(serverpod.userSessionRepository.pendingSessions, isEmpty);
    }
  });
}
