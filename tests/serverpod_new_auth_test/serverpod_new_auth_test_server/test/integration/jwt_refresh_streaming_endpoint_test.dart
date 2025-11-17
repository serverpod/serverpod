import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const universalHashPepper = 'test-pepper';

final jwtTokenManagerFactory = AuthenticationTokensTokenManagerFactory(
  AuthenticationTokenConfig(
    refreshTokenHashPepper: universalHashPepper,
    algorithm: AuthenticationTokenAlgorithm.hmacSha512(
      SecretKey('test-private-key-for-HS512'),
    ),
  ),
);

void main() {
  setUp(() {
    AuthServices.set(
      primaryTokenManager: jwtTokenManagerFactory,
      identityProviders: [],
    );
  });

  withServerpod('Given a streaming endpoint authenticated with JWT', (
    final sessionBuilder,
    final endpoints,
  ) {
    late UuidValue userId;
    late UuidValue authId;
    late AuthSuccess authSuccess;
    late Stream<int> stream;
    const scopeName = 'test-scope';
    late Session session;
    late TestSessionBuilder authenticatedSessionBuilder;

    setUp(() async {
      userId = await endpoints.authTest.createTestUser(sessionBuilder);
      authSuccess = await endpoints.authTest.createJwtToken(
        sessionBuilder,
        userId,
      );

      final authenticationTokens =
          AuthServices.getTokenManager<AuthenticationTokensTokenManager>()
              .authenticationTokens;
      final tokenData = authenticationTokens.jwtUtil.verifyJwt(
        authSuccess.token,
      );
      authId = tokenData.refreshTokenId;

      authenticatedSessionBuilder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          userId.toString(),
          {const Scope(scopeName)},
          authId: authId.toString(),
        ),
      );

      session = authenticatedSessionBuilder.build();

      stream = endpoints.authenticatedStreamingTest.openAuthenticatedStream(
        authenticatedSessionBuilder,
      );
    });

    group('when calling the streaming endpoint method,', () {
      late Completer<dynamic> streamClosedCompleter;
      late Completer<int> valueReceivedCompleter;
      late StreamSubscription<int> streamSubscription;

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
      });

      tearDown(() async {
        await streamSubscription.cancel();
      });

      group('and when refreshing tokens multiple times,', () {
        late UuidValue finalRefreshTokenId;

        setUp(() async {
          for (var i = 0; i < 3; i++) {
            final newAuthSuccess = await endpoints.jwtRefresh
                .refreshAccessToken(
                  sessionBuilder,
                  refreshToken: authSuccess.refreshToken!,
                );

            authSuccess = newAuthSuccess;

            await Future.delayed(const Duration(milliseconds: 150));
          }

          final authenticationTokens =
              AuthServices.getTokenManager<AuthenticationTokensTokenManager>()
                  .authenticationTokens;
          final tokenData = authenticationTokens.jwtUtil.verifyJwt(
            authSuccess.token,
          );
          finalRefreshTokenId = tokenData.refreshTokenId;
        });

        test('then stream remains open', () {
          expect(streamClosedCompleter.isCompleted, isFalse);
        });

        test(
          'and when the last refreshed token is revoked, then the stream closes with an error',
          () async {
            final authenticationTokens =
                AuthServices.getTokenManager<AuthenticationTokensTokenManager>()
                    .authenticationTokens;

            final deleted = await authenticationTokens.destroyRefreshToken(
              session,
              refreshTokenId: finalRefreshTokenId,
            );

            expect(deleted, isTrue);

            await expectLater(streamClosedCompleter.future, completes);
            final exception = await streamClosedCompleter.future;
            expect(exception, isA<ConnectionClosedException>());
          },
        );
      });
    });
  });
}
