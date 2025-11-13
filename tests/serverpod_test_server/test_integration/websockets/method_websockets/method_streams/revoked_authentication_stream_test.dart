import 'dart:async';

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
  var authenticatedUserId = '1';
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
          outStream = client.authenticatedMethodStreaming.intEchoStream(
            inStream.stream,
          );
          valueReceivedCompleter = Completer<int>();
          outStream.listen(
            (event) {
              if (valueReceivedCompleter.isCompleted) {
                return;
              }
              valueReceivedCompleter.complete(event);
            },
            onError: (e) {
              streamClosedCompleter.complete(e);
            },
          );

          inStream.add(1);
          // Validate that the stream works
          await valueReceivedCompleter.future;
          assert(valueReceivedCompleter.isCompleted);
        }
      });

      test(
        'when the authenticated user is revoked then the stream is closed with an error.',
        () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationUser(),
            ),
            completion(true),
          );

          await expectLater(streamClosedCompleter.future, completes);
          var exception = await streamClosedCompleter.future;
          expect(exception, isA<ConnectionClosedException>());
        },
      );

      test(
        'when the authentication id is revoked then the stream is closed with an error.',
        () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationAuthId(authId: 'token-$tokenCounter'),
            ),
            completion(true),
          );

          await expectLater(streamClosedCompleter.future, completes);
          var exception = await streamClosedCompleter.future;
          expect(exception, isA<ConnectionClosedException>());
        },
      );

      test(
        'when an unrelated authentication id is revoked then the stream can still be used.',
        () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationAuthId(
                authId: 'token-${tokenCounter + 100}',
              ),
            ),
            completion(true),
          );

          valueReceivedCompleter = Completer<int>();
          inStream.add(2);
          await expectLater(
            valueReceivedCompleter.future,
            completion(2),
          );
        },
      );

      test(
        'when the required scope for an endpoint is revoked then the stream is closed with an error.',
        () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationScope(scopes: [Scope.admin.name!]),
            ),
            completion(true),
          );

          await expectLater(streamClosedCompleter.future, completes);
          var exception = await streamClosedCompleter.future;
          expect(exception, isA<c.ConnectionClosedException>());
        },
      );

      test(
        'when a scope not required for an endpoint is revoked then the stream can still be used.',
        () async {
          await expectLater(
            session.messages.authenticationRevoked(
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
        },
      );
    });

    group('connected to two authenticated streaming methods', () {
      late Completer<dynamic> streamClosedCompleter1;
      late Completer<int> valueReceivedCompleter1;
      late StreamController<int> inStream1;

      late Completer<dynamic> streamClosedCompleter2;
      late Completer<int> valueReceivedCompleter2;
      late StreamController<int> inStream2;

      setUp(() async {
        streamClosedCompleter1 = Completer<dynamic>();
        inStream1 = StreamController<int>();
        Stream<int> outStream;
        {
          outStream = client.authenticatedMethodStreaming.intEchoStream(
            inStream1.stream,
          );
          valueReceivedCompleter1 = Completer<int>();
          outStream.listen(
            (event) {
              if (valueReceivedCompleter1.isCompleted) {
                return;
              }
              valueReceivedCompleter1.complete(event);
            },
            onError: (e) {
              streamClosedCompleter1.complete(e);
            },
          );

          inStream1.add(1);
          // Validate that the stream works
          await valueReceivedCompleter1.future;
          assert(valueReceivedCompleter1.isCompleted);
        }

        streamClosedCompleter2 = Completer<dynamic>();
        inStream2 = StreamController<int>();
        Stream<int> outStream2;
        {
          outStream2 = client.authenticatedMethodStreaming.intEchoStream(
            inStream2.stream,
          );
          valueReceivedCompleter2 = Completer<int>();
          outStream2.listen(
            (event) {
              if (valueReceivedCompleter2.isCompleted) {
                return;
              }
              valueReceivedCompleter2.complete(event);
            },
            onError: (e) {
              streamClosedCompleter2.complete(e);
            },
          );

          inStream2.add(1);
          // Validate that the stream works
          await valueReceivedCompleter2.future;
          assert(valueReceivedCompleter2.isCompleted);
        }
      });

      test(
        'when the authenticated user is revoked then streams are closed with errors.',
        () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationUser(),
            ),
            completion(true),
          );

          await expectLater(streamClosedCompleter1.future, completes);
          var exception = await streamClosedCompleter1.future;
          expect(exception, isA<ConnectionClosedException>());

          await expectLater(streamClosedCompleter2.future, completes);
          exception = await streamClosedCompleter2.future;
          expect(exception, isA<ConnectionClosedException>());
        },
      );

      test(
        'when the required scope for an endpoint is revoked then streams are closed with an error.',
        () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationScope(scopes: [Scope.admin.name!]),
            ),
            completion(true),
          );

          await expectLater(streamClosedCompleter1.future, completes);
          var exception = await streamClosedCompleter1.future;
          expect(exception, isA<c.ConnectionClosedException>());

          await expectLater(streamClosedCompleter2.future, completes);
          exception = await streamClosedCompleter2.future;
          expect(exception, isA<c.ConnectionClosedException>());
        },
      );
    });

    group(
      'connected to both an authenticated and an unauthenticated streaming method',
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
            authenticatedOutStream.listen(
              (event) {
                if (valueReceivedCompleter.isCompleted) {
                  return;
                }
                valueReceivedCompleter.complete(event);
              },
              onError: (e) {
                authenticatedStreamClosedCompleter.complete(e);
              },
            );

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
              session.messages.authenticationRevoked(
                authenticatedUserId,
                RevokedAuthenticationUser(),
              ),
              completion(true),
            );

            await expectLater(
              authenticatedStreamClosedCompleter.future,
              completes,
            );
          },
        );

        test(
          'when the authenticated user is revoked then the unauthenticated stream can still be used',
          () async {
            await expectLater(
              session.messages.authenticationRevoked(
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
          },
        );
      },
    );
  });
}
