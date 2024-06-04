import 'package:http/testing.dart';
import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';
import 'package:test/test.dart';

import 'firebase_auth_mock.dart';

void main() {
  var uid = 'abcdefghijklmnopqrstuvwxyz';
  group(
    'Given a Firebase Auth class with a valid UserRecord, ',
    () {
      late FirebaseAuthManager auth;

      setUp(() async {
        auth = FirebaseAuthManager(
          testAccountServiceJson,
          authClient: MockClient(
            FirebaseAuthBackendMock(
              userJson: crateUserRecord(
                uuid: uid,
                validSince: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ).onHttpCall,
          ),
          openIdClient: MockClient(
            FirebaseOpenIdBackendMock().onHttpCall,
          ),
        );
      });

      test(
        'when calling verifyIdToken with an valid idToken, then the returned idToken matches the valid idToken',
        () async {
          var idToken = generateMockIdToken(
            uid: uid,
          );

          var verifiedToken = await auth.verifyIdToken(idToken);

          expect(
            idToken,
            verifiedToken.toCompactSerialization(),
          );
        },
      );

      test(
        'when calling verifyIdToken with an invalid idToken uid, then a FirebaseInvalidUIIDException is thrown',
        () async {
          var idToken = generateMockIdToken(
            uid: '${uid}testttt',
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
        'when calling verifyIdToken with an invalid idToken format, then a FirebaseJWTFormatException is thrown',
        () async {
          var idToken = 'blablabla.test.test';

          await expectLater(
            () async => await auth.verifyIdToken(idToken),
            throwsA(isA<FirebaseJWTFormatException>()),
          );
        },
      );

      test(
        'when calling verifyIdToken with an malformated idToken, then a FirebaseJWTFormatException is thrown',
        () async {
          var idToken = 'blablabla';

          await expectLater(
            () async => await auth.verifyIdToken(idToken),
            throwsA(isA<FirebaseJWTFormatException>()),
          );
        },
      );
    },
  );

  test(
    'When initializing FirebaseAuthManager with an invalid service JSON, then a FirebaseInitException is thrown',
    () async {
      expect(
        () => FirebaseAuthManager({}),
        throwsA(isA<FirebaseInitException>()),
        reason: 'Invalid Firebase Account Service Json',
      );
    },
  );

  test(
    'When initializing FirebaseAuthManager with an invalid "project_id", then a FirebaseInitException is thrown',
    () async {
      expect(
        () => FirebaseAuthManager({'project_id': ''}),
        throwsA(isA<FirebaseInitException>()),
        reason: 'Invalid Firebase Project ID',
      );
    },
  );

  test(
    'When initializing FirebaseAuthManager with an valid "project_id" but missing account JSON data, then a FirebaseInitException is thrown',
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
          authClient: MockClient(
            FirebaseAuthBackendMock(
              userJson: crateUserRecord(
                uuid: 'abcdefghijklmnopqrstuvwxyz',
                validSince: DateTime.now(),
              ),
            ).onHttpCall,
          ),
          openIdClient: MockClient(
            FirebaseOpenIdBackendMock().onHttpCall,
          ),
        );
      });

      test(
        'when calling verifyIdToken with an ID token that was signed before the user\'s "validSince" time, then a FirebaseJWTException is thrown',
        () async {
          var idToken = generateMockIdToken(
            uid: uid,
            overrides: {
              'auth_time': DateTime.now()
                      .subtract(const Duration(days: 1))
                      .millisecondsSinceEpoch ~/
                  1000,
            },
          );

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
