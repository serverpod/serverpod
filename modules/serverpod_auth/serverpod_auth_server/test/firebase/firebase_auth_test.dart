import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';
import 'package:test/test.dart';

import 'firebase_auth_mock.dart';

void main() {
  group(
    'Given a Firebase Auth class with a valid UserRecord, ',
    () {
      FirebaseAuthManager auth = FirebaseAuthManager();

      setUp(() async {
        await auth.init(
          testAccountServiceJson,
          authClient: MockAuthBaseClient(
            userJson: getUserRecord(
              uuid: 'abcdefghijklmnopqrstuvwxyz',
              validSince: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ),
          openIdClient: MockTokenClient(
              // projectId: testAccountServiceJson['project_id'],
              // issuer: getTestIssuer(),
              ),
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
        'when calling verifyIdToken with a invalid idToken uid, then an Exception should be thrown',
        () async {
          var idToken = generateMockIdToken(
            projectId: 'project_id',
            uid: 'testttt',
          );

          await expectLater(
            () async => await auth.verifyIdToken(idToken),
            throwsA(isA<FirebaseException>()),
            reason:
                'There is no user record corresponding to the provided identifier.',
          );
        },
      );

      test(
        'when calling verifyIdToken with a invalid idToken, then an ArgumentError should be thrown',
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

  group(
    'Given a Firebase Auth class without initialization, ',
    () {
      FirebaseAuthManager auth = FirebaseAuthManager();
      test(
        'when calling verifyIdToken with a valid idToken, then an Exception should be thrown',
        () async {
          var idToken = generateMockIdToken(
            projectId: 'project_id',
            uid: 'abcdefghijklmnopqrstuvwxyz',
          );

          await expectLater(
            () async => await auth.verifyIdToken(idToken),
            throwsA(isA<FirebaseException>()),
            reason: 'FirebaseAdmin not initialized!',
          );
        },
      );
    },
  );

  group(
    'Given a Firebase Auth class with UserRecord valid since today, ',
    () {
      FirebaseAuthManager auth = FirebaseAuthManager();
      setUp(() async {
        await auth.init(
          testAccountServiceJson,
          authClient: MockAuthBaseClient(
            userJson: getUserRecord(
              uuid: 'abcdefghijklmnopqrstuvwxyz',
              validSince: DateTime.now(),
            ),
          ),
          openIdClient: MockTokenClient(
              // projectId: testAccountServiceJson['project_id'],
              // issuer: getTestIssuer(),
              ),
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
            throwsA(isA<FirebaseException>()),
            reason: 'The Firebase ID token has been revoked.',
          );
        },
      );
    },
  );
}
