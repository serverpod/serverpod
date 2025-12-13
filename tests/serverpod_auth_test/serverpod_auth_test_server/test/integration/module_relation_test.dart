import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';
import 'package:serverpod_auth_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../util/test_tags.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given UserData model with relation to AuthUser',
    (sessionBuilder, endpoints) {
      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when creating a UserData with AuthUser relation then the relation is correctly established',
        () async {
          final session = await sessionBuilder.build();

          // Create an AuthUser
          final authUser = AuthUser(
            scopeNames: {'user'},
            blocked: false,
          );
          final insertedAuthUser = await AuthUser.db.insertRow(
            session,
            authUser,
          );

          // Create a UserData linked to the AuthUser
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
          final session = await sessionBuilder.build();

          // Create an AuthUser
          final authUser = AuthUser(
            scopeNames: {'admin'},
            blocked: false,
          );
          final insertedAuthUser = await AuthUser.db.insertRow(
            session,
            authUser,
          );

          // Create a UserData linked to the AuthUser
          final userData = UserData(
            authUserId: insertedAuthUser.id!,
            displayName: 'Admin User',
            bio: null,
          );
          await UserData.db.insertRow(session, userData);

          // Fetch with include
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
          final session = await sessionBuilder.build();

          // Create an AuthUser
          final authUser = AuthUser(
            scopeNames: {'user'},
            blocked: false,
          );
          final insertedAuthUser = await AuthUser.db.insertRow(
            session,
            authUser,
          );

          // Create a UserData linked to the AuthUser
          final userData = UserData(
            authUserId: insertedAuthUser.id!,
            displayName: 'Cascade Test User',
            bio: 'Will be deleted',
          );
          await UserData.db.insertRow(session, userData);

          // Delete the AuthUser (should cascade to UserData)
          await AuthUser.db.deleteRow(session, insertedAuthUser);

          // Verify UserData was deleted
          final remainingData = await UserData.db.find(session);
          expect(remainingData.length, equals(0));
        },
      );
    },
  );

  withServerpod(
    'Given ChallengeTracker model with relation to SecretChallenge',
    (sessionBuilder, endpoints) {
      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when creating a ChallengeTracker with SecretChallenge relation then the relation is correctly established',
        () async {
          final session = await sessionBuilder.build();

          // Create a SecretChallenge
          final secretChallenge = SecretChallenge(
            challengeCodeHash: 'test-hash-value',
          );
          final insertedChallenge = await SecretChallenge.db.insertRow(
            session,
            secretChallenge,
          );

          // Create a ChallengeTracker linked to the SecretChallenge
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
        'when fetching ChallengeTracker with include then SecretChallenge is loaded',
        () async {
          final session = await sessionBuilder.build();

          // Create a SecretChallenge
          final secretChallenge = SecretChallenge(
            challengeCodeHash: 'another-test-hash',
          );
          final insertedChallenge = await SecretChallenge.db.insertRow(
            session,
            secretChallenge,
          );

          // Create a ChallengeTracker linked to the SecretChallenge
          final challengeTracker = ChallengeTracker(
            secretChallengeId: insertedChallenge.id!,
            notes: 'Tracked challenge',
          );
          await ChallengeTracker.db.insertRow(session, challengeTracker);

          // Fetch with include
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
        'when SecretChallenge is deleted with cascade then ChallengeTracker is also deleted',
        () async {
          final session = await sessionBuilder.build();

          // Create a SecretChallenge
          final secretChallenge = SecretChallenge(
            challengeCodeHash: 'cascade-test-hash',
          );
          final insertedChallenge = await SecretChallenge.db.insertRow(
            session,
            secretChallenge,
          );

          // Create a ChallengeTracker linked to the SecretChallenge
          final challengeTracker = ChallengeTracker(
            secretChallengeId: insertedChallenge.id!,
            notes: 'Will be cascaded',
          );
          await ChallengeTracker.db.insertRow(session, challengeTracker);

          // Delete the SecretChallenge (should cascade to ChallengeTracker)
          await SecretChallenge.db.deleteRow(session, insertedChallenge);

          // Verify ChallengeTracker was deleted
          final remainingTrackers = await ChallengeTracker.db.find(session);
          expect(remainingTrackers.length, equals(0));
        },
      );
    },
  );
}

Future<void> _cleanUpDatabase(Session session) async {
  // Clean up in reverse order of dependencies
  await ChallengeTracker.db.deleteWhere(session, where: (_) => Constant.bool(true));
  await UserData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  await SecretChallenge.db.deleteWhere(session, where: (_) => Constant.bool(true));
  await AuthUser.db.deleteWhere(session, where: (_) => Constant.bool(true));
}
