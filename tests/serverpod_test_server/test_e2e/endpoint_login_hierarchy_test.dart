// ignore_for_file: deprecated_member_use

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

  setUp(() async {
    await client.authentication.removeAllUsers();
    var userCount = await client.authentication.countUsers();
    expect(userCount, equals(0));
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

  group(
    'Given an endpoint which subclasses a base class which requires login, ',
    () {
      test(
        'when calling `echo` as an unauthenticated user, then the request errs with "Unauthorized"',
        () async {
          await expectLater(
            () async => await client.myLoggedIn.echo('hello'),
            throwsA(
              isA<ServerpodClientException>()
                  .having(
                    (e) => e.message,
                    'statusCode',
                    contains('Unauthorized'),
                  )
                  .having((e) => e.statusCode, 'statusCode', 401),
            ),
          );
        },
      );

      test(
        'when calling `echo` as a logged-in user, then the request returns the expected value',
        () async {
          var loginResponse = await client.authentication.authenticate(
            'test@foo.bar',
            'password',
          );
          await client.authenticationKeyManager!.put(
            '${loginResponse.keyId}:${loginResponse.key}',
          );

          final response = await client.myLoggedIn.echo('hello');

          expect(response, 'hello');
        },
      );
    },
  );

  group(
    'Given an endpoint which subclasses a base class which requires login and admin scope, ',
    () {
      test(
        'when calling `echo` as a guest user, then the request errs with "Unauthorized"',
        () async {
          await expectLater(
            () async => await client.myAdmin.echo('hello'),
            throwsA(
              isA<ServerpodClientException>()
                  .having(
                    (e) => e.message,
                    'statusCode',
                    contains('Unauthorized'),
                  )
                  .having((e) => e.statusCode, 'statusCode', 401),
            ),
          );
        },
      );

      test(
        'when calling `echo` as a logged-in user, then the request errs with "Forbidden" due to the missing scope',
        () async {
          var loginResponse = await client.authentication.authenticate(
            'test@foo.bar',
            'password',
          );
          await client.authenticationKeyManager!.put(
            '${loginResponse.keyId}:${loginResponse.key}',
          );

          await expectLater(
            () async => await client.myAdmin.echo('hello'),
            throwsA(
              isA<ServerpodClientException>()
                  .having((e) => e.message, 'statusCode', contains('Forbidden'))
                  .having((e) => e.statusCode, 'statusCode', 403),
            ),
          );
        },
      );

      test(
        'when calling `echo` as an admin user, then the request returns the expected value',
        () async {
          var loginResponse = await client.authentication.authenticate(
            'test@foo.bar',
            'password',
            [Scope.admin.name!],
          );
          await client.authenticationKeyManager!.put(
            '${loginResponse.keyId}:${loginResponse.key}',
          );

          final response = await client.myAdmin.echo('hello');

          expect(response, 'hello');
        },
      );
    },
  );

  group(
    'Given an endpoint which subclasses an abstract base class which requires login and admin scope, ',
    () {
      test(
        'when calling `echo` as a guest user, then the request errs with "Unauthorized"',
        () async {
          await expectLater(
            () async => await client.myConcreteAdmin.echo('hello'),
            throwsA(
              isA<ServerpodClientException>()
                  .having(
                    (e) => e.message,
                    'statusCode',
                    contains('Unauthorized'),
                  )
                  .having((e) => e.statusCode, 'statusCode', 401),
            ),
          );
        },
      );

      test(
        'when calling `echo` as a logged-in user, then the request errs with "Forbidden" due to the missing scope',
        () async {
          var loginResponse = await client.authentication.authenticate(
            'test@foo.bar',
            'password',
          );
          await client.authenticationKeyManager!.put(
            '${loginResponse.keyId}:${loginResponse.key}',
          );

          await expectLater(
            () async => await client.myConcreteAdmin.echo('hello'),
            throwsA(
              isA<ServerpodClientException>()
                  .having((e) => e.message, 'statusCode', contains('Forbidden'))
                  .having((e) => e.statusCode, 'statusCode', 403),
            ),
          );
        },
      );

      test(
        'when calling `echo` as an admin user, then the request returns the expected value',
        () async {
          var loginResponse = await client.authentication.authenticate(
            'test@foo.bar',
            'password',
            [Scope.admin.name!],
          );
          await client.authenticationKeyManager!.put(
            '${loginResponse.keyId}:${loginResponse.key}',
          );

          final response = await client.myConcreteAdmin.echo('hello');

          expect(response, 'hello');
        },
      );
    },
  );
}
