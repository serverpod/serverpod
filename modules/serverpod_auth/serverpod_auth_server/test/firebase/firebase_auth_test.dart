import 'dart:convert';
import 'dart:io';
import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';
import 'package:test/test.dart';

import 'firebase_auth_mock.dart';

void main() {
  Auth auth = Auth.instance;
  File? jsonFile;

  setUp(() async {
    var jsonMap = {
      'project_id': 'test-project',
      'private_key': 'test-key',
      'client_email': 'test-email',
    };
    var jsonString = json.encode(jsonMap);
    jsonFile = File('test-service-account-key.json');
    await jsonFile?.writeAsString(jsonString);

    await auth.init(
      'test-service-account-key.json',
      authClient: MockAuthClient(),
      tokenClient: MockTokenClient(),
    );
  });

  tearDown(() {
    jsonFile?.deleteSync();
  });

  group('FirebaseAdmin', () {
    test('verifyIdToken throws exception if not initialized', () async {
      expect(
        () => auth.verifyIdToken('test-id-token'),
        throwsA(isA<Exception>()),
      );
    });
    // Add more tests as needed
  });
}
