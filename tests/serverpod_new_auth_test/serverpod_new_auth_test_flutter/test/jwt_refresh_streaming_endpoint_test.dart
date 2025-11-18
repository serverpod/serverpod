import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

import 'utils/test_auth_key_manager.dart';

void main() {
  late Client client;
  late TestAuthKeyManager authKeyManager;

  setUp(() {
    authKeyManager = TestAuthKeyManager();
    client = Client(
      'http://localhost:8080/',
      authenticationKeyManager: authKeyManager,
    );
  });

  tearDown(() {
    client.close();
  });

  group(
    'Given a streaming method authenticated with a JWT token that has since been refreshed multiple times,',
    () {
      late UuidValue userId;
      late Stream<int> stream;
      late Completer<dynamic> streamClosedCompleter;
      late Completer<int> valueReceivedCompleter;
      late StreamSubscription<int> streamSubscription;
      late String finalToken;

      setUp(() async {
        userId = await client.authTest.createTestUser();
        var authSuccess = await client.authTest.createJwtToken(userId);

        await authKeyManager.put(authSuccess.token);

        stream = client.authenticatedStreamingTest.openAuthenticatedStream();

        streamClosedCompleter = Completer<dynamic>();
        valueReceivedCompleter = Completer<int>();

        streamSubscription = stream.listen(
          (final event) {
            if (!valueReceivedCompleter.isCompleted) {
              valueReceivedCompleter.complete(event);
            }
          },
          onError: (final e) {
            if (!streamClosedCompleter.isCompleted) {
              streamClosedCompleter.complete(e);
            }
          },
        );

        await valueReceivedCompleter.future;
        assert(
          !streamClosedCompleter.isCompleted,
          'Stream should be stay open after receiving a value',
        );

        for (var i = 0; i < 3; i++) {
          final newAuthSuccess = await client.jwtRefresh.refreshAccessToken(
            refreshToken: authSuccess.refreshToken!,
          );

          authSuccess = newAuthSuccess;
        }

        finalToken = authSuccess.token;
      });

      tearDown(() async {
        await streamSubscription.cancel();
      });

      test(
        'when the latest revision is revoked, then the stream closes with a ConnectionClosedException',
        () async {
          final deleted = await client.authTest.destroySpecificRefreshToken(
            finalToken,
          );

          expect(deleted, isTrue);

          await expectLater(streamClosedCompleter.future, completes);
          final exception = await streamClosedCompleter.future;
          expect(exception, isA<ConnectionClosedException>());
        },
      );
    },
  );
}
