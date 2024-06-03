import 'package:serverpod/src/authentication/scope.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    authenticationKeyManager: TestAuthKeyManager(),
  );

  setUp(() {});

  group('Setup', () {
    test('Remove accounts', () async {
      await client.authentication.removeAllUsers();
      var userCount = await client.authentication.countUsers();
      expect(userCount, equals(0));
    });
  });

  group('Basic authentication', () {
    test('Not authenticated', () async {
      var signedIn = await client.modules.auth.status.isSignedIn();
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

      expect(statusCode, equals(401));
    });

    test('Authenticate with incorrect credentials', () async {
      var response = await client.authentication
          .authenticate('test@foo.bar', 'incorrect password');
      expect(response.success, equals(false));
    });

    test('Not authenticated after failed sign in', () async {
      var signedIn = await client.modules.auth.status.isSignedIn();
      expect(signedIn, equals(false));
    });

    test('Authenticate with correct credentials', () async {
      var response =
          await client.authentication.authenticate('test@foo.bar', 'password');
      if (response.success) {
        await client.authenticationKeyManager!
            .put('${response.keyId}:${response.key}');
      }
      expect(response.success, equals(true));
      expect(response.userInfo, isNotNull);
    });

    test('Authenticated', () async {
      var signedIn = await client.modules.auth.status.isSignedIn();
      expect(signedIn, equals(true));
    });

    test('Access endpoint with required signin', () async {
      var result = await client.signInRequired.testMethod();
      expect(result, equals(true));
    });

    test('Sign out user', () async {
      await client.authentication.signOut();

      int? statusCode;
      try {
        await client.signInRequired.testMethod();
      } catch (e) {
        if (e is ServerpodClientException) {
          statusCode = e.statusCode;
        }
      }

      expect(statusCode, equals(401));
    });
  });

  group('User creation', () {
    test('Create user with ok domain', () async {
      // Only accounts with emails ending with .bar are allowed
      var oldUserCount = await client.authentication.countUsers();
      await client.authentication.createUser('legit@foo.bar', 'password');
      var newUserCount = await client.authentication.countUsers();

      // We should have added one user
      expect(newUserCount - oldUserCount, equals(1));
    });

    test('Create user with invalid domain', () async {
      // Only accounts with emails ending with .bar are allowed
      var oldUserCount = await client.authentication.countUsers();
      await client.authentication.createUser('nonlegit@foo.fail', 'password');
      var newUserCount = await client.authentication.countUsers();

      // We should not have added any new users
      expect(newUserCount - oldUserCount, equals(0));
    });
  });

  group('Given signed in user without "admin" scope', () {
    setUp(() async {
      var response = await client.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      assert(response.success, 'Failed to authenticate user');
      await client.authenticationKeyManager
          ?.put('${response.keyId}:${response.key}');
      assert(
          await client.modules.auth.status.isSignedIn(), 'Failed to sign in');
    });

    tearDown(() async {
      await client.authenticationKeyManager?.remove();
      await client.authentication.removeAllUsers();
      await client.authentication.signOut();
      assert(
        await client.modules.auth.status.isSignedIn() == false,
        'Still signed in after teardown',
      );
    });
    test(
        'when accessing endpoint that requires "admin" scope then 403 is returned.',
        () async {
      expectLater(
          client.adminScopeRequired.testMethod(),
          throwsA(isA<ServerpodClientException>()
              .having((e) => e.statusCode, 'statusCode', 403)));
    });
  });

  group('Given signed in user with "admin" scope', () {
    setUp(() async {
      var response = await client.authentication.authenticate(
        'test@foo.bar',
        'password',
        [Scope.admin.name!],
      );
      assert(response.success, 'Failed to authenticate user');
      await client.authenticationKeyManager
          ?.put('${response.keyId}:${response.key}');
      assert(
          await client.modules.auth.status.isSignedIn(), 'Failed to sign in');
    });

    tearDown(() async {
      await client.authenticationKeyManager?.remove();
      await client.authentication.removeAllUsers();
      await client.authentication.signOut();
      assert(
        await client.modules.auth.status.isSignedIn() == false,
        'Still signed in after teardown',
      );
    });
    test(
        'when accessing endpoint that requires "admin" scope then request is successful.',
        () async {
      var result = await client.adminScopeRequired.testMethod();
      expect(result, equals(true));
    });
  });
}
