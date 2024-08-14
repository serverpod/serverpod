// Call a streaming method unauthenticated, with invalid authentication and with valid authentication.

import 'dart:async';

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

  test(
      'Given an unauthenticated user when calling an authenticated streaming method then client exception with forbidden HTTP status code is thrown.',
      () async {
    var errorCompleter = Completer();
    var stream = await client.authenticatedMethodStreaming.simpleStream();
    stream.listen((event) {
      // Do nothing
    }, onError: (error) {
      errorCompleter.complete(error);
    });

    await expectLater(
      await errorCompleter.future,
      isA<ServerpodClientException>()
          .having((e) => e.statusCode, 'statusCode', HttpStatus.unauthorized),
    );
  });

  group('Given an authenticated user with insufficient access', () {
    setUp(() async {
      // Missing required admin scope for endpoint
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
        'when calling an authenticated streaming method then client exception with unauthorized HTTP status code is thrown',
        () async {
      var errorCompleter = Completer();
      var stream = await client.authenticatedMethodStreaming.simpleStream();
      stream.listen((event) {
        // Do nothing
      }, onError: (error) {
        errorCompleter.complete(error);
      });

      await expectLater(
        await errorCompleter.future,
        isA<ServerpodClientException>()
            .having((e) => e.statusCode, 'statusCode', HttpStatus.forbidden),
      );
    });
  });

  group('Given an authenticated user with sufficient access', () {
    setUp(() async {
      // Admin scope required by the endpoint
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
        'when calling an authenticated streaming method then access is granted and the expected integers are received.',
        () async {
      var streamComplete = Completer();
      var stream = await client.methodStreaming.simpleStream();
      var received = <int>[];
      stream.listen((event) {
        received.add(event);
      }, onDone: () {
        streamComplete.complete();
      });

      await streamComplete.future;
      expect(received, List.generate(10, (index) => index++));
    });
  });
}
