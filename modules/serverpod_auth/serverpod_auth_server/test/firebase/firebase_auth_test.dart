import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';
import 'package:test/test.dart';

import 'firebase_auth_mock.dart';

void main() {
  group(
    'FirebaseAdmin',
    () {
      Auth auth = Auth();
      setUp(() async {
        await auth.init(
          testAccountServiceJson,
          authBaseClient: MockAuthBaseClient(
            uuid: 'abcdefghijklmnopqrstuvwxyz',
            userJson: tempUser,
          ),
          openIdClient: MockTokenClient(
            projectId: testAccountServiceJson['project_id'],
            issuer: getTestIssuer(),
          ),
        );
      });

      test(
        'verifyIdToken throws exception if not initialized',
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
      // Add more tests as needed
    },
  );
}

Map<String, dynamic> tempUser = {
  'kind': 'identitytoolkit#GetAccountInfoResponse',
  'users': [
    {
      'localId': 'abcdefghijklmnopqrstuvwxyz',
      'email': 'user@gmail.com',
      'emailVerified': true,
      'displayName': 'John Doe',
      'phoneNumber': '+11234567890',
      'providerUserInfo': [
        {
          'providerId': 'google.com',
          'displayName': 'John Doe',
          'photoUrl': 'https://lh3.googleusercontent.com/1234567890/photo.jpg',
          'federatedId': '1234567890',
          'email': 'user@gmail.com',
          'rawId': '1234567890',
        },
        {
          'providerId': 'facebook.com',
          'displayName': 'John Smith',
          'photoUrl': 'https://facebook.com/0987654321/photo.jpg',
          'federatedId': '0987654321',
          'email': 'user@facebook.com',
          'rawId': '0987654321',
        },
        {
          'providerId': 'phone',
          'phoneNumber': '+11234567890',
          'rawId': '+11234567890',
        },
      ],
      'photoUrl': 'https://lh3.googleusercontent.com/1234567890/photo.jpg',
      'validSince': '1476136676',
      'lastLoginAt': '1476235905000',
      'createdAt': '1476136676000',
    }
  ],
};
