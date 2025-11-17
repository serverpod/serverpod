import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
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

  group('Given a streaming endpoint authenticated with JWT', () {
    late UuidValue userId;
    late AuthSuccess authSuccess;
    late Stream<int> stream;

    setUp(() async {
      userId = await client.authTest.createTestUser();
      authSuccess = await client.authTest.createJwtToken(userId);

      final tokenParts = authSuccess.token.split('.');
      if (tokenParts.length != 3) {
        throw Exception('Invalid JWT token format');
      }

      await authKeyManager.put(authSuccess.token);

      stream = client.authenticatedStreamingTest.openAuthenticatedStream();
    });

    group(
      'when calling the streaming endpoint method and refreshing tokens multiple times',
      () {
        late Completer<dynamic> streamClosedCompleter;
        late Completer<int> valueReceivedCompleter;
        late StreamSubscription<int> streamSubscription;
        late UuidValue finalRefreshTokenId;

        setUp(() async {
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

          for (var i = 0; i < 3; i++) {
            final newAuthSuccess = await client.jwtRefresh.refreshAccessToken(
              refreshToken: authSuccess.refreshToken!,
            );

            authSuccess = newAuthSuccess;
            await authKeyManager.put(authSuccess.token);

            await Future<void>.delayed(const Duration(milliseconds: 150));
          }

          final tokenParts = authSuccess.token.split('.');
          if (tokenParts.length == 3) {
            final payload = tokenParts[1];
            final normalizedPayload = base64Url.normalize(payload);
            final decodedPayload = utf8.decode(
              base64Url.decode(normalizedPayload),
            );
            final Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);
            finalRefreshTokenId = UuidValue.fromString(
              payloadMap['dev.serverpod.refreshTokenId'],
            );
          }
        });

        tearDown(() async {
          await streamSubscription.cancel();
        });

        test('then stream remains open', () {
          expect(streamClosedCompleter.isCompleted, isFalse);
        });

        test(
          'when the last refreshed token is revoked, then the stream closes with an error.',
          () async {
            final deleted = await client.authTest.destroySpecificRefreshToken(
              finalRefreshTokenId,
            );

            expect(deleted, isTrue);

            await expectLater(streamClosedCompleter.future, completes);
            final exception = await streamClosedCompleter.future;
            expect(exception, isA<ConnectionClosedException>());
          },
        );
      },
    );
  });
}
