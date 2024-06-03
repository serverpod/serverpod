import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';
import 'package:test/test.dart';

import 'firebase_auth_mock.dart';

void main() {
  group(
    'Given a Firebase Auth class with a valid UserRecord, ',
    () {
      late FirebaseAuthManager auth;

      setUp(() async {
        auth = FirebaseAuthManager(
          testAccountServiceJson,
          authClient: MockAuthBaseClient(
            userJson: getUserRecord(
              uuid: 'abcdefghijklmnopqrstuvwxyz',
              validSince: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ),
          openIdClient: MockTokenClient(),
        );
      });

      test(
        'when calling verifyIdToken with a valid idToken, then the returned idToken should match',
        () async {
          var idToken = generateMockIdToken(
            projectId: 'project_id',
            uid: 'abcdefghijklmnopqrstuvwxyz',
          );

          var verifiedToken = await auth.verifyIdToken(idToken);

          expect(
            idToken,
            verifiedToken.toCompactSerialization(),
          );
        },
      );

      test(
        'when calling verifyIdToken with a invalid idToken uid, then an FirebaseInvalidUIIDException should be thrown',
        () async {
          var idToken = generateMockIdToken(
            projectId: 'project_id',
            uid: 'testttt',
          );

          await expectLater(
            () async => await auth.verifyIdToken(idToken),
            throwsA(isA<FirebaseInvalidUIIDException>()),
            reason:
                'There is no user record corresponding to the provided identifier.',
          );
        },
      );

      test(
        'when calling verifyIdToken with a invalid idToken, then an FirebaseJWTException should be thrown',
        () async {
          var idToken = 'blablabla';

          await expectLater(
            () async => await auth.verifyIdToken(idToken),
            throwsA(isA<ArgumentError>()),
          );
        },
      );
    },
  );

  test(
    'When initializing FirebaseAuthManager with an invalid service JSON, a FirebaseInitException should be thrown',
    () async {
      expect(
        () => FirebaseAuthManager({}),
        throwsA(isA<FirebaseInitException>()),
        reason: 'Invalid Firebase Account Service Json',
      );
    },
  );

  test(
    'When initializing FirebaseAuthManager with an invalid "project_id", a FirebaseInitException should be thrown',
    () async {
      expect(
        () => FirebaseAuthManager({'project_id': ''}),
        throwsA(isA<FirebaseInitException>()),
        reason: 'Invalid Firebase Project ID',
      );
    },
  );

  test(
    'When initializing FirebaseAuthManager with an valid "project_id" but missing account JSON data, a FirebaseInitException should be thrown',
    () async {
      expect(
        () => FirebaseAuthManager({'project_id': 'test-test'}),
        throwsA(isA<FirebaseInitException>()),
      );
    },
  );

  group(
    'Given a Firebase Auth class with UserRecord valid since today, ',
    () {
      late FirebaseAuthManager auth;
      setUp(() async {
        auth = FirebaseAuthManager(
          testAccountServiceJson,
          authClient: MockAuthBaseClient(
            userJson: getUserRecord(
              uuid: 'abcdefghijklmnopqrstuvwxyz',
              validSince: DateTime.now(),
            ),
          ),
          openIdClient: MockTokenClient(),
        );
      });

      test(
        'when calling verifyIdToken with a invalid idToken, then an Exception should be thrown',
        () async {
          var idToken = generateMockIdToken(
              projectId: 'project_id',
              uid: 'abcdefghijklmnopqrstuvwxyz',
              overrides: {
                'auth_time': DateTime.now()
                        .subtract(const Duration(days: 1))
                        .millisecondsSinceEpoch ~/
                    1000,
              });

          await expectLater(
            () async => await auth.verifyIdToken(idToken),
            throwsA(isA<FirebaseJWTException>()),
            reason: 'The Firebase ID token has been revoked.',
          );
        },
      );
    },
  );
}
