import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
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
      late AuthSuccess authSuccess;
      late Stream<int> stream;
      late Completer<dynamic> streamClosedCompleter;
      late Completer<int> valueReceivedCompleter;
      late StreamSubscription<int> streamSubscription;

      setUp(() async {
        userId = await client.authTest.createTestUser();
        authSuccess = await client.authTest.createJwtToken(userId);

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
        expect(streamClosedCompleter.isCompleted, isFalse);

        for (var i = 0; i < 3; i++) {
          final newAuthSuccess = await client.jwtRefresh.refreshAccessToken(
            refreshToken: authSuccess.refreshToken!,
          );

          authSuccess = newAuthSuccess;
        }

        // We save the last access token so that we can revoke its authId later.
        await authKeyManager.put(authSuccess.token);
      });

      tearDown(() async {
        await streamSubscription.cancel();
      });

      test(
        'when the latest revision is revoked, then the stream closes with a ConnectionClosedException',
        () async {
          final deleted = await client.authTest.destroySpecificRefreshToken();

          expect(deleted, isTrue);

          await expectLater(streamClosedCompleter.future, completes);
          final exception = await streamClosedCompleter.future;
          expect(exception, isA<ConnectionClosedException>());
        },
      );
    },
  );
}
