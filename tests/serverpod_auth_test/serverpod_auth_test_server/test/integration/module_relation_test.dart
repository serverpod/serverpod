import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';
import 'package:serverpod_auth_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given UserData model with relation to AuthUser from the auth core module',
    (final sessionBuilder, final endpoints) {
      test(
        'when creating a UserData with AuthUser relation '
        'then the relation is correctly established',
        () async {
          final session = sessionBuilder.build();

          final authUser = AuthUser(
            scopeNames: {'user'},
            blocked: false,
          );
          final insertedAuthUser = await AuthUser.db.insertRow(
            session,
            authUser,
          );

          final userData = UserData(
            authUserId: insertedAuthUser.id!,
            displayName: 'Test User',
            bio: 'A test user bio',
          );
          final insertedData = await UserData.db.insertRow(
            session,
            userData,
          );

          expect(insertedData.id, isNotNull);
          expect(insertedData.authUserId, equals(insertedAuthUser.id));
          expect(insertedData.displayName, equals('Test User'));
          expect(insertedData.bio, equals('A test user bio'));
        },
      );

      test(
        'when fetching UserData with include then AuthUser is loaded',
        () async {
          final session = sessionBuilder.build();

          final authUser = AuthUser(
            scopeNames: {'admin'},
            blocked: false,
          );
          final insertedAuthUser = await AuthUser.db.insertRow(
            session,
            authUser,
          );

          final userData = UserData(
            authUserId: insertedAuthUser.id!,
            displayName: 'Admin User',
            bio: null,
          );
          await UserData.db.insertRow(session, userData);

          final fetchedData = await UserData.db.find(
            session,
            include: UserData.include(
              authUser: AuthUser.include(),
            ),
          );

          expect(fetchedData.length, equals(1));
          expect(fetchedData.first.authUser, isNotNull);
          expect(
            fetchedData.first.authUser!.scopeNames,
            equals({'admin'}),
          );
          expect(fetchedData.first.authUser!.blocked, isFalse);
        },
      );

      test(
        'when AuthUser is deleted with cascade then UserData is also deleted',
        () async {
          final session = sessionBuilder.build();

          final authUser = AuthUser(
            scopeNames: {'user'},
            blocked: false,
          );
          final insertedAuthUser = await AuthUser.db.insertRow(
            session,
            authUser,
          );

          final userData = UserData(
            authUserId: insertedAuthUser.id!,
            displayName: 'Cascade Test User',
            bio: 'Will be deleted',
          );
          await UserData.db.insertRow(session, userData);

          await AuthUser.db.deleteRow(session, insertedAuthUser);

          final remainingData = await UserData.db.find(session);
          expect(remainingData.length, equals(0));
        },
      );
    },
  );

  withServerpod(
    'Given ChallengeTracker model with relation to SecretChallenge from the IDP module',
    (final sessionBuilder, final endpoints) {
      test(
        'when creating a ChallengeTracker with SecretChallenge relation '
        'then the relation is correctly established',
        () async {
          final session = sessionBuilder.build();

          final secretChallenge = SecretChallenge(
            challengeCodeHash: 'test-hash-value',
          );
          final insertedChallenge = await SecretChallenge.db.insertRow(
            session,
            secretChallenge,
          );

          final challengeTracker = ChallengeTracker(
            secretChallengeId: insertedChallenge.id!,
            notes: 'Test challenge tracker',
          );
          final insertedTracker = await ChallengeTracker.db.insertRow(
            session,
            challengeTracker,
          );

          expect(insertedTracker.id, isNotNull);
          expect(
            insertedTracker.secretChallengeId,
            equals(insertedChallenge.id),
          );
          expect(insertedTracker.notes, equals('Test challenge tracker'));
          expect(insertedTracker.trackedAt, isNotNull);
        },
      );

      test(
        'when fetching ChallengeTracker with include '
        'then SecretChallenge is loaded',
        () async {
          final session = sessionBuilder.build();

          final secretChallenge = SecretChallenge(
            challengeCodeHash: 'another-test-hash',
          );
          final insertedChallenge = await SecretChallenge.db.insertRow(
            session,
            secretChallenge,
          );

          final challengeTracker = ChallengeTracker(
            secretChallengeId: insertedChallenge.id!,
            notes: 'Tracked challenge',
          );
          await ChallengeTracker.db.insertRow(session, challengeTracker);

          final fetchedTrackers = await ChallengeTracker.db.find(
            session,
            include: ChallengeTracker.include(
              secretChallenge: SecretChallenge.include(),
            ),
          );

          expect(fetchedTrackers.length, equals(1));
          expect(fetchedTrackers.first.secretChallenge, isNotNull);
          expect(
            fetchedTrackers.first.secretChallenge!.challengeCodeHash,
            equals('another-test-hash'),
          );
        },
      );

      test(
        'when SecretChallenge is deleted with cascade '
        'then ChallengeTracker is also deleted',
        () async {
          final session = sessionBuilder.build();

          final secretChallenge = SecretChallenge(
            challengeCodeHash: 'cascade-test-hash',
          );
          final insertedChallenge = await SecretChallenge.db.insertRow(
            session,
            secretChallenge,
          );

          final challengeTracker = ChallengeTracker(
            secretChallengeId: insertedChallenge.id!,
            notes: 'Will be cascaded',
          );
          await ChallengeTracker.db.insertRow(session, challengeTracker);

          await SecretChallenge.db.deleteRow(session, insertedChallenge);

          final remainingTrackers = await ChallengeTracker.db.find(session);
          expect(remainingTrackers.length, equals(0));
        },
      );
    },
  );
}
