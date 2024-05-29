import 'dart:convert';
import 'dart:io';
import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';
import 'package:test/test.dart';

import 'firebase_auth_mock.dart';

void main() {
  Auth auth = Auth.instance;
  File? jsonFile;

  setUp(() async {
    jsonFile = File('test-service-account-key.json');
    await jsonFile?.writeAsString(json.encode(testAccountServiceJson));

    await auth.init(
      'test-service-account-key.json',
      authBaseClient: MockAuthBaseClient(),
      openIdClient: MockTokenClient(
        projectId: testAccountServiceJson['project_id'],
        issuer: getTestIssuer(),
      ),
    );
  });

  tearDown(() {
    jsonFile?.deleteSync();
  });

  group(
    'FirebaseAdmin',
    () {
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
