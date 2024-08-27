import 'dart:async';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart' as c;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  late Serverpod server;
  late Session session;
  late c.Client client;
  late TestAuthKeyManager authKeyManager;
  var authenticatedUserId = 1;
  var tokenCounter = 0;

  setUp(() async {
    // This creates a server with an authentication handler that always returns
    // a user with Admin scope.
    var tokenCounter = 0;
    server = IntegrationTestServer.create(
      authenticationHandler: (session, token) async => AuthenticationInfo(
        authenticatedUserId,
        {Scope.admin},
        authId: 'token-${tokenCounter++}',
      ),
    );
    await server.start();
    session = await server.createSession();

    authKeyManager = TestAuthKeyManager();
    client = c.Client(
      serverUrl,
      authenticationKeyManager: authKeyManager,
    );
  });

  tearDown(() async {
    await session.close();
    client.closeStreamingMethodConnections(exception: null);
    await server.shutdown(exitProcess: false);
    client.close();
  });

  group('Given an authenticated user', () {
    late String authToken;
    setUp(() async {
      authToken = const Uuid().v4();
      authKeyManager.put(authToken);
    });
    group('connected to an authenticated streaming method', () {
      late Completer<dynamic> streamClosedCompleter;
      late Completer<int> valueReceivedCompleter;
      late StreamController<int> inStream;

      setUp(() async {
        streamClosedCompleter = Completer<dynamic>();
        inStream = StreamController<int>();
        Stream<int> outStream;
        {
          outStream = client.authenticatedMethodStreaming
              .intEchoStream(inStream.stream);
          valueReceivedCompleter = Completer<int>();
          outStream.listen((event) {
            if (valueReceivedCompleter.isCompleted) {
              return;
            }
            valueReceivedCompleter.complete(event);
          }, onError: (e) {
            streamClosedCompleter.complete(e);
          });

          inStream.add(1);
          // Validate that the stream works
          await valueReceivedCompleter.future;
          assert(valueReceivedCompleter.isCompleted);
        }
      });

      test(
          'when the authenticated user is revoked then the stream is closed with error.',
          () async {
        await expectLater(
          session.messages.revokedAuthentication(
            authenticatedUserId,
            RevokedAuthenticationUser(),
          ),
          completion(true),
        );

        await expectLater(streamClosedCompleter.future, completes);
        var exception = await streamClosedCompleter.future;
        expect(exception, isA<ServerpodClientException>());
      });

      test(
          'when the authentication id is revoked then the stream is closed with error.',
          () async {
        await expectLater(
          session.messages.revokedAuthentication(
            authenticatedUserId,
            RevokedAuthenticationAuthId(authId: 'token-$tokenCounter'),
          ),
          completion(true),
        );

        await expectLater(streamClosedCompleter.future, completes);
        var exception = await streamClosedCompleter.future;
        expect(exception, isA<ServerpodClientException>());
      });

      test(
          'when an unrelated authentication id is revoked then the stream can still be used.',
          () async {
        await expectLater(
          session.messages.revokedAuthentication(
            authenticatedUserId,
            RevokedAuthenticationAuthId(authId: 'token-${tokenCounter + 100}'),
          ),
          completion(true),
        );

        valueReceivedCompleter = Completer<int>();
        inStream.add(2);
        await expectLater(
          valueReceivedCompleter.future,
          completion(2),
        );
      });

      test(
          'when the required scope for endpoint is revoked the stream is closed with error.',
          () async {
        await expectLater(
          session.messages.revokedAuthentication(
            authenticatedUserId,
            RevokedAuthenticationScope(scopes: [Scope.admin.name!]),
          ),
          completion(true),
        );

        await expectLater(streamClosedCompleter.future, completes);
        var exception = await streamClosedCompleter.future;
        expect(exception, isA<ServerpodClientException>());
      });

      test(
          'when a scope not required for the endpoint is revoked then the stream can still be used.',
          () async {
        await expectLater(
          session.messages.revokedAuthentication(
            authenticatedUserId,
            RevokedAuthenticationScope(scopes: ['unrelated-scope']),
          ),
          completion(true),
        );

        valueReceivedCompleter = Completer<int>();
        inStream.add(2);
        await expectLater(
          valueReceivedCompleter.future,
          completion(2),
        );
      });
    });

    group(
        'connected to both an authenticated an unauthenticated streaming method',
        () {
      late Completer authenticatedStreamClosedCompleter;
      late Completer<int> unauthenticatedValueReceivedCompleter;
      late StreamController<int> unauthenticatedInStream;

      setUp(() async {
        authenticatedStreamClosedCompleter = Completer<dynamic>();
        var authenticatedInStream = StreamController<int>();
        Stream<int> authenticatedOutStream;
        {
          authenticatedOutStream = client.authenticatedMethodStreaming
              .intEchoStream(authenticatedInStream.stream);
          var valueReceivedCompleter = Completer<int>();
          authenticatedOutStream.listen((event) {
            if (valueReceivedCompleter.isCompleted) {
              return;
            }
            valueReceivedCompleter.complete(event);
          }, onError: (e) {
            authenticatedStreamClosedCompleter.complete(e);
          });

          authenticatedInStream.add(1);
          // Validate that the stream works
          await valueReceivedCompleter.future;
          assert(valueReceivedCompleter.isCompleted);
        }

        unauthenticatedInStream = StreamController<int>();
        Stream<int> unauthenticatedOutStream;
        unauthenticatedValueReceivedCompleter = Completer<int>();
        {
          unauthenticatedOutStream = client.methodStreaming.intEchoStream(
            unauthenticatedInStream.stream,
          );
          unauthenticatedOutStream.listen((event) {
            if (unauthenticatedValueReceivedCompleter.isCompleted) {
              return;
            }
            unauthenticatedValueReceivedCompleter.complete(event);
          });

          unauthenticatedInStream.add(1);
          // Validate that the stream works
          await unauthenticatedValueReceivedCompleter.future;
          assert(unauthenticatedValueReceivedCompleter.isCompleted);
        }
      });

      test(
          'when the authenticated user is revoked then the authenticated stream is closed',
          () async {
        await expectLater(
          session.messages.revokedAuthentication(
            authenticatedUserId,
            RevokedAuthenticationUser(),
          ),
          completion(true),
        );

        await expectLater(authenticatedStreamClosedCompleter.future, completes);
      });

      test(
          'when the authenticated user is revoked then the unauthenticated stream can still be used',
          () async {
        await expectLater(
          session.messages.revokedAuthentication(
            authenticatedUserId,
            RevokedAuthenticationUser(),
          ),
          completion(true),
        );

        unauthenticatedValueReceivedCompleter = Completer<int>();
        unauthenticatedInStream.add(2);
        await expectLater(
          unauthenticatedValueReceivedCompleter.future,
          completion(2),
        );
      });
    });
  });
}
