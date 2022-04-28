import 'package:serverpod_auth_client/src/protocol/authentication_response.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  Client client = Client(
    'http://serverpod_test_server:8080/',
    authenticationKeyManager: TestAuthKeyManager(),
  );

  setUp(() {});

  group('Setup', () {
    test('Remove accounts', () async {
      await client.authentication.removeAllUsers();
      int userCount = await client.authentication.countUsers();
      expect(userCount, equals(0));
    });
  });

  group('Basic authentication', () {
    test('Not authenticated', () async {
      bool signedIn = await client.modules.auth.status.isSignedIn();
      expect(signedIn, equals(false));
    });

    test('Access endpoint with required signin without authentication',
        () async {
      int? statusCode;
      try {
        await client.signInRequired.testMethod();
      } catch (e) {
        if (e is ServerpodClientException) {
          statusCode = e.statusCode;
        }
      }

      // Only perform the check for dart:io. On web -1 will be returned as
      // failing status codes cannot be detected.
      if (!identical(0, 0.0)) {
        expect(statusCode, equals(403));
      }
    });

    test('Authenticate with incorrect credentials', () async {
      AuthenticationResponse response = await client.authentication
          .authenticate('test@foo.bar', 'incorrect password');
      expect(response.success, equals(false));
    });

    test('Not authenticated after failed sign in', () async {
      bool signedIn = await client.modules.auth.status.isSignedIn();
      expect(signedIn, equals(false));
    });

    test('Authenticate with correct credentials', () async {
      AuthenticationResponse response =
          await client.authentication.authenticate('test@foo.bar', 'password');
      if (response.success) {
        await client.authenticationKeyManager!
            .put('${response.keyId}:${response.key}');
      }
      expect(response.success, equals(true));
      expect(response.userInfo, isNotNull);
    });

    test('Authenticated', () async {
      bool signedIn = await client.modules.auth.status.isSignedIn();
      expect(signedIn, equals(true));
    });

    test('Access endpoint with required signin', () async {
      bool result = await client.signInRequired.testMethod();
      expect(result, equals(true));
    });
  });

  group('User creation', () {
    test('Create user with ok domain', () async {
      // Only accounts with emails ending with .bar are allowed
      int oldUserCount = await client.authentication.countUsers();
      await client.authentication.createUser('legit@foo.bar', 'password');
      int newUserCount = await client.authentication.countUsers();

      // We should have added one user
      expect(newUserCount - oldUserCount, equals(1));
    });

    test('Create user with invalid domain', () async {
      // Only accounts with emails ending with .bar are allowed
      int oldUserCount = await client.authentication.countUsers();
      await client.authentication.createUser('nonlegit@foo.fail', 'password');
      int newUserCount = await client.authentication.countUsers();

      // We should not have added any new users
      expect(newUserCount - oldUserCount, equals(0));
    });
  });
}

class TestAuthKeyManager extends AuthenticationKeyManager {
  String? _key;

  @override
  Future<String?> get() async => _key;

  @override
  Future<void> put(String key) async {
    _key = key;
  }

  @override
  Future<void> remove() async {
    _key = null;
  }
}
