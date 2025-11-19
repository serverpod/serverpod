import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  late Serverpod server;
  late Client client;
  late AuthenticationKeyManager authKeyManager;

  setUpAll(() async {
    server = IntegrationTestServer.create();
    await server.start();

    authKeyManager = TestAuthKeyManager();
    client = Client(
      serverUrl,
      authenticationKeyManager: authKeyManager,
    );

    await client.authentication.removeAllUsers();

    var response = await client.authentication.authenticate(
      'test@foo.bar',
      'password',
      [Scope('user').name!],
    );

    expect(response.success, isTrue, reason: 'Failed to authenticate.');
    await authKeyManager.put('${response.keyId}:${response.key}');

    var authenticated = await client.modules.auth.status.isSignedIn();
    expect(authenticated, isTrue, reason: 'Client should be authenticated');
  });

  tearDownAll(() async {
    await authKeyManager.remove();
    await client.authentication.signOut();
    await server.shutdown(exitProcess: false);
    client.close();
  });

  group('Given a signed in user ', () {
    test(
      'when calling a method endpoint from a class annotated with @unauthenticatedClientCall'
      'then it correctly returns that the call was not authenticated.',
      () async {
        final authenticated = await client.unauthenticated
            .unauthenticatedMethod();

        expect(authenticated, isFalse);
      },
    );

    test(
      'when calling a streaming endpoint annotated with @unauthenticatedClientCall '
      'then it correctly returns that the call was not authenticated.',
      () async {
        final authenticated = await client.unauthenticated
            .unauthenticatedStream()
            .first;

        expect(authenticated, isFalse);
      },
    );

    test(
      'when calling a method endpoint annotated with @unauthenticatedClientCall'
      'then it correctly returns that the call was not authenticated.',
      () async {
        final authenticated = await client.partiallyUnauthenticated
            .unauthenticatedMethod();

        expect(authenticated, isFalse);
      },
    );

    test(
      'when calling a streaming endpoint annotated with @unauthenticatedClientCall '
      'then it correctly returns that the call was not authenticated.',
      () async {
        final authenticated = await client.partiallyUnauthenticated
            .unauthenticatedStream()
            .first;

        expect(authenticated, isFalse);
      },
    );

    test(
      'when calling a method endpoint not annotated with @unauthenticatedClientCall '
      'then it correctly returns that the call was authenticated.',
      () async {
        final authenticated = await client.partiallyUnauthenticated
            .authenticatedMethod();

        expect(authenticated, isTrue);
      },
    );

    test(
      'when calling a streaming endpoint not annotated with @unauthenticatedClientCall '
      'then it correctly returns that the call was authenticated.',
      () async {
        final authenticated = await client.partiallyUnauthenticated
            .authenticatedStream()
            .first;

        expect(authenticated, isTrue);
      },
    );

    test(
      'when calling an endpoint from a class annotated with @unauthenticatedClientCall that also require login '
      'then it throws unauthorized due to client not passing auth header.',
      () async {
        await expectLater(
          () => client.unauthenticatedRequireLogin.unauthenticatedMethod(),
          throwsA(isA<ServerpodClientUnauthorized>()),
        );
      },
    );

    test(
      'when calling a streaming endpoint from a class annotated with @unauthenticatedClientCall that also require login '
      'then it throws unauthorized due to client not passing auth header.',
      () async {
        await expectLater(
          () =>
              client.unauthenticatedRequireLogin.unauthenticatedStream().first,
          throwsA(isA<ServerpodClientUnauthorized>()),
        );
      },
    );

    test(
      'when calling a method endpoint annotated with @unauthenticatedClientCall from a class that requires login '
      'then it throws unauthorized due to client not passing auth header.',
      () async {
        await expectLater(
          () => client.requireLogin.unauthenticatedMethod(),
          throwsA(isA<ServerpodClientUnauthorized>()),
        );
      },
    );

    test(
      'when calling a streaming endpoint annotated with @unauthenticatedClientCall from a class that requires login '
      'then it throws unauthorized due to client not passing auth header.',
      () async {
        await expectLater(
          () => client.requireLogin.unauthenticatedStream().first,
          throwsA(isA<ServerpodClientUnauthorized>()),
        );
      },
    );
  });
}
