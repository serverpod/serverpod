import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as dart_jsonwebtoken;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import '../../test_tags.dart';

void main() {
  final jwt = Jwt(
    config: JwtConfig(
      algorithm: HmacSha512JwtAlgorithmConfiguration(
        key: SecretKey('test-private-key-for-HS512'),
      ),
      refreshTokenHashPepper: 'test-pepper',
    ),
  );

  withServerpod('Given an existing `AuthUser`,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await jwt.authUsers.create(session);
      authUserId = authUser.id;
    });

    test('when requesting a new token pair, then one is returned.', () async {
      expect(
        await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        ),
        isNotNull,
      );
    });

    test(
      'when requesting a new token pair, then expiration date is returned.',
      () async {
        final now = DateTime.now();
        late AuthSuccess authSuccess;

        await withClock(Clock.fixed(now), () async {
          authSuccess = await jwt.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
            method: 'test',
          );
        });

        final expirationExpected = now
            .toUtc()
            .add(jwt.config.accessTokenLifetime)
            .truncatedToSecond();

        expect(authSuccess.tokenExpiresAt, isA<DateTime>());
        expect(authSuccess.tokenExpiresAt, expirationExpected);
      },
    );

    test(
      'when requesting a new token pair with scopes, then those are visible on the initial access token.',
      () async {
        final authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {const Scope('test')},
          method: 'test',
        );

        final decodedToken = jwt.jwtUtil.verifyJwt(
          authSuccess.token,
        );
        expect(decodedToken.scopes, hasLength(1));
        expect(decodedToken.scopes.single.name, 'test');
      },
    );

    test(
      'when requesting a new token pair with extra claims, then those are visible on the initial access token.',
      () async {
        final authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          extraClaims: {'test': 123},
          method: 'test',
        );

        final decodedToken = dart_jsonwebtoken.JWT.decode(authSuccess.token);

        expect((decodedToken.payload as Map)['test'], 123);
      },
    );

    test(
      'when requesting a new token pair with extra claims that conflict with registered claims, then it will throw.',
      () async {
        expect(
          () => jwt.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
            extraClaims: {'exp': 123, 'custom': 'hello'},
            method: 'test',
          ),
          throwsArgumentError,
        );
      },
    );
  });

  withServerpod(
    'Given a valid `TokenPair` for a refresh token with scopes and extra claims,',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (
      final sessionBuilder,
      final endpoints,
    ) {
      const String scopeName = 'test scope';
      late Session session;
      late UuidValue authUserId;
      late AuthSuccess authSuccess;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await jwt.authUsers.create(
          session,
        );
        authUserId = authUser.id;

        authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {const Scope(scopeName)},
          extraClaims: {'string': 'foo', 'int': 1},
          method: 'test',
        );
      });

      test(
        'when refreshing the tokens, then a new AuthSuccess is returned with new tokens, but same auth info.',
        () async {
          final newAuthSuccess = await jwt.refreshAccessToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          expect(newAuthSuccess.authStrategy, authSuccess.authStrategy);
          expect(newAuthSuccess.authUserId, authSuccess.authUserId);
          expect(newAuthSuccess.scopeNames, authSuccess.scopeNames);
          expect(newAuthSuccess.token, isNot(authSuccess.token));
          expect(newAuthSuccess.refreshToken, isNot(authSuccess.refreshToken));
        },
      );

      test(
        'when calling `destroyRefreshToken` with a valid refresh token ID, then it returns true.',
        () async {
          final deleted = await jwt.destroyRefreshToken(
            session,
            refreshTokenId: _extractRefreshTokenId(authSuccess.token),
          );

          expect(deleted, isTrue);
        },
      );

      test(
        'when calling `destroyRefreshToken` with an invalid refresh token ID, then it returns false.',
        () async {
          final deleted = await jwt.destroyRefreshToken(
            session,
            refreshTokenId: const Uuid().v4obj(),
          );

          expect(deleted, isFalse);
        },
      );

      test(
        'when calling `destroyAllRefreshTokens`, then it returns the list of deleted token IDs.',
        () async {
          final newAuthSuccesses = await List.generate(
            3,
            (final _) async => jwt.createTokens(
              session,
              authUserId: authUserId,
              method: 'test',
            ),
          ).wait;

          final deletedIds = await jwt.destroyAllRefreshTokens(
            session,
            authUserId: authUserId,
          );

          expect(deletedIds.toSet(), {
            _extractRefreshTokenId(authSuccess.token),
            for (final authSuccess in newAuthSuccesses)
              _extractRefreshTokenId(authSuccess.token),
          });
        },
      );

      test(
        'when calling destroyRefreshToken, then authenticationRevoked message is published with correct authId',
        () async {
          final refreshTokenId = jwt.jwtUtil
              .verifyJwt(authSuccess.token)
              .refreshTokenId;

          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(
                authUserId.uuid,
              );
          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          final deleted = await jwt.destroyRefreshToken(
            session,
            refreshTokenId: refreshTokenId,
          );

          session.messages.removeListener(
            channelName,
            revocationMessages.add,
          );

          expect(deleted, isTrue);
          expect(revocationMessages, [
            isA<RevokedAuthenticationAuthId>().having(
              (final m) => m.authId,
              'authId',
              refreshTokenId.toString(),
            ),
          ]);
        },
      );

      test(
        'when calling destroyAllRefreshTokens, then authenticationRevoked message is published for the user',
        () async {
          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(
                authUserId.uuid,
              );
          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          final deletedIds = await jwt.destroyAllRefreshTokens(
            session,
            authUserId: authUserId,
          );

          session.messages.removeListener(
            channelName,
            revocationMessages.add,
          );

          expect(deletedIds, isNotEmpty);
          expect(revocationMessages, [
            isA<RevokedAuthenticationUser>(),
          ]);
        },
      );
    },
  );

  withServerpod('Given an auth user with a JWT token,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await jwt.authUsers.create(session);
      authUserId = authUser.id;

      await jwt.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
    });

    test(
      'when listing the tokens for that user, then it is returned.',
      () async {
        final tokenInfos = await jwt.listJwtTokens(
          session,
          authUserId: authUserId,
        );

        expect(tokenInfos.single.authUserId, authUserId);
      },
    );
  });

  withServerpod('Given two auth users with a JWT token each,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId1;
    late UuidValue authUserId2;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser1 = await jwt.authUsers.create(session);
      authUserId1 = authUser1.id;

      await jwt.createTokens(
        session,
        authUserId: authUserId1,
        scopes: {},
        method: 'test',
      );

      final authUser2 = await jwt.authUsers.create(session);
      authUserId2 = authUser2.id;

      await jwt.createTokens(
        session,
        authUserId: authUserId2,
        scopes: {},
        method: 'test',
      );
    });

    test(
      'when listing the tokens for one user, then only their tokens are returned.',
      () async {
        final tokenInfos = await jwt.listJwtTokens(
          session,
          authUserId: authUserId1,
        );

        expect(tokenInfos.single.authUserId, authUserId1);
      },
    );
  });

  withServerpod('Given a user with scopes,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();
      final authUser = await jwt.authUsers.create(session);
      authUserId = authUser.id;
      // Assign scopes to the user using update
      await jwt.authUsers.update(
        session,
        authUserId: authUserId,
        scopes: {const Scope('user-scope')},
      );
    });

    test(
      'when no scopes are provided, the users scopes should be used.',
      () async {
        final authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          method: 'test',
        );
        final decodedToken = jwt.jwtUtil.verifyJwt(
          authSuccess.token,
        );
        expect(decodedToken.scopes, hasLength(1));
        expect(decodedToken.scopes.single.name, 'user-scope');
      },
    );

    test('when scopes are provided, the provided scopes are used.', () async {
      final authSuccess = await jwt.createTokens(
        session,
        authUserId: authUserId,
        scopes: {
          const Scope('test-scope'),
        },
        method: 'test',
      );
      final decodedToken = jwt.jwtUtil.verifyJwt(
        authSuccess.token,
      );
      expect(decodedToken.scopes, hasLength(1));
      expect(decodedToken.scopes.single.name, 'test-scope');
    });
  });

  withServerpod('Given a user that is blocked,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();
      final authUser = await jwt.authUsers.create(session);
      authUserId = authUser.id;
      // Block the user using update
      await jwt.authUsers.update(
        session,
        authUserId: authUserId,
        blocked: true,
      );
    });

    test(
      'when creating tokens, an AuthUserBlockedException should be thrown.',
      () async {
        await expectLater(
          () => jwt.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
            method: 'test',
          ),
          throwsA(isA<AuthUserBlockedException>()),
        );
      },
    );

    test(
      'when creating token with skipUserBlockedChecked as true, then the token should be created successfully.',
      () async {
        final authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
          skipUserBlockedChecked: true,
        );
        expect(authSuccess, isNotNull);
      },
    );
  });

  withServerpod('Given a JwtConfig with extraClaimsProvider,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      const authUsers = AuthUsers();
      final authUser = await authUsers.create(session);
      authUserId = authUser.id;
    });

    test(
      'when requesting a new token pair with the provider configured, then provider claims are included in the access token.',
      () async {
        final jwtWithHook = Jwt(
          config: JwtConfig(
            algorithm: HmacSha512JwtAlgorithmConfiguration(
              key: SecretKey('test-private-key-for-HS512'),
            ),
            refreshTokenHashPepper: 'test-pepper',
            extraClaimsProvider: (final session, final context) async {
              return {'hookClaim': 'hookValue', 'userRole': 'admin'};
            },
          ),
        );

        final authSuccess = await jwtWithHook.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );

        final decodedToken = dart_jsonwebtoken.JWT.decode(authSuccess.token);
        final payload = decodedToken.payload as Map;

        expect(payload['hookClaim'], 'hookValue');
        expect(payload['userRole'], 'admin');
      },
    );

    test(
      'when requesting a new token pair with both provider and extraClaims, then provider can control how claims are merged.',
      () async {
        final jwtWithHook = Jwt(
          config: JwtConfig(
            algorithm: HmacSha512JwtAlgorithmConfiguration(
              key: SecretKey('test-private-key-for-HS512'),
            ),
            refreshTokenHashPepper: 'test-pepper',
            extraClaimsProvider: (final session, final context) async {
              // Provider can decide how to merge extraClaims
              return {
                ...?context.extraClaims,
                'providerClaim': 'fromProvider',
                'conflictKey': 'providerWins',
              };
            },
          ),
        );

        final authSuccess = await jwtWithHook.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          extraClaims: {'paramClaim': 'fromParam', 'conflictKey': 'paramLoses'},
          method: 'test',
        );

        final decodedToken = dart_jsonwebtoken.JWT.decode(authSuccess.token);
        final payload = decodedToken.payload as Map;

        expect(payload['providerClaim'], 'fromProvider');
        expect(payload['paramClaim'], 'fromParam');
        expect(payload['conflictKey'], 'providerWins');
      },
    );

    test(
      'when provider returns null, then no extra claims are added from the provider.',
      () async {
        final jwtWithHook = Jwt(
          config: JwtConfig(
            algorithm: HmacSha512JwtAlgorithmConfiguration(
              key: SecretKey('test-private-key-for-HS512'),
            ),
            refreshTokenHashPepper: 'test-pepper',
            extraClaimsProvider: (final session, final context) async {
              return null;
            },
          ),
        );

        final authSuccess = await jwtWithHook.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );

        final decodedToken = dart_jsonwebtoken.JWT.decode(authSuccess.token);
        final payload = decodedToken.payload as Map;

        // Should only contain standard claims, no custom ones
        expect(payload.containsKey('hookClaim'), isFalse);
      },
    );

    test(
      'when provider accesses session context, then it can fetch additional data.',
      () async {
        const authUsers = AuthUsers();
        final jwtWithHook = Jwt(
          config: JwtConfig(
            algorithm: HmacSha512JwtAlgorithmConfiguration(
              key: SecretKey('test-private-key-for-HS512'),
            ),
            refreshTokenHashPepper: 'test-pepper',
            extraClaimsProvider: (final session, final context) async {
              // Provider can fetch additional data from database using session
              final authUser = await authUsers.get(
                session,
                authUserId: context.authUserId,
              );
              return {
                'userId': authUser.id.toString(),
                'userExists': true,
              };
            },
          ),
        );

        final authSuccess = await jwtWithHook.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );

        final decodedToken = dart_jsonwebtoken.JWT.decode(authSuccess.token);
        final payload = decodedToken.payload as Map;

        expect(payload['userId'], authUserId.toString());
        expect(payload['userExists'], isTrue);
      },
    );

    test(
      'when provider uses method and scopes parameters, then it can customize claims based on them.',
      () async {
        final jwtWithHook = Jwt(
          config: JwtConfig(
            algorithm: HmacSha512JwtAlgorithmConfiguration(
              key: SecretKey('test-private-key-for-HS512'),
            ),
            refreshTokenHashPepper: 'test-pepper',
            extraClaimsProvider: (final session, final context) async {
              // Provider can use method and scopes to customize claims
              return {
                'authMethod': context.method,
                'scopeCount': context.scopes.length,
                'hasAdminScope': context.scopes.any(
                  (final s) => s.name == 'admin',
                ),
              };
            },
          ),
        );

        final authSuccess = await jwtWithHook.createTokens(
          session,
          authUserId: authUserId,
          scopes: {const Scope('admin'), const Scope('user')},
          method: 'email',
        );

        final decodedToken = dart_jsonwebtoken.JWT.decode(authSuccess.token);
        final payload = decodedToken.payload as Map;

        expect(payload['authMethod'], 'email');
        expect(payload['scopeCount'], 2);
        expect(payload['hasAdminScope'], isTrue);
      },
    );
  });

  withServerpod('Given an auth user with an expired refresh token,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late AuthSuccess authSuccess;
    late UuidValue tokenId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await jwt.authUsers.create(
        session,
      );
      authUserId = authUser.id;

      await withClock(
        Clock.fixed(
          DateTime.now().subtract(
            jwt.config.refreshTokenLifetime,
          ),
        ),
        () async {
          authSuccess = await jwt.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
            method: 'test',
          );

          tokenId = jwt.jwtUtil.verifyJwt(authSuccess.token).refreshTokenId;
        },
      );
    });

    test(
      'when calling refreshAccessToken with the expired token, then authenticationRevoked message is published with correct authId.',
      () async {
        final channelName =
            MessageCentralServerpodChannels.revokedAuthentication(
              authUserId.uuid,
            );
        final revocationMessages = <SerializableModel>[];
        session.messages.addListener(
          channelName,
          revocationMessages.add,
        );

        await expectLater(
          () => jwt.refreshAccessToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          ),
          throwsA(anything),
        );

        session.messages.removeListener(
          channelName,
          revocationMessages.add,
        );

        expect(revocationMessages, [
          isA<RevokedAuthenticationAuthId>().having(
            (final m) => m.authId,
            'authId',
            tokenId.toString(),
          ),
        ]);
      },
    );
  });

  withServerpod(
    'Given an auth user with a valid refresh token,',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late AuthSuccess authSuccess;
      late UuidValue refreshTokenId;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await jwt.authUsers.create(session);
        authUserId = authUser.id;

        authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );

        refreshTokenId = jwt.jwtUtil
            .verifyJwt(authSuccess.token)
            .refreshTokenId;
      });

      test(
        'when calling refreshAccessToken with an invalid secret, then authenticationRevoked message is published with correct authId.',
        () async {
          final tokenParts = authSuccess.refreshToken!.split(':');
          tokenParts[3] = 'dGVzdA==';
          final invalidRefreshToken = tokenParts.join(':');

          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(
                authUserId.uuid,
              );
          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          await expectLater(
            () => jwt.refreshAccessToken(
              session,
              refreshToken: invalidRefreshToken,
            ),
            throwsA(anything),
          );

          session.messages.removeListener(
            channelName,
            revocationMessages.add,
          );

          expect(revocationMessages, [
            isA<RevokedAuthenticationAuthId>().having(
              (final m) => m.authId,
              'authId',
              refreshTokenId.toString(),
            ),
          ]);
        },
      );
    },
  );
}

UuidValue _extractRefreshTokenId(final String accessToken) {
  final jwt = dart_jsonwebtoken.JWT.decode(accessToken);
  const claimName = 'dev.serverpod.refreshTokenId';
  final refreshTokenIdClaim = (jwt.payload as Map)[claimName] as String;
  return UuidValue.withValidation(refreshTokenIdClaim);
}

extension on DateTime {
  DateTime truncatedToSecond() =>
      DateTime.utc(year, month, day, hour, minute, second);
}
