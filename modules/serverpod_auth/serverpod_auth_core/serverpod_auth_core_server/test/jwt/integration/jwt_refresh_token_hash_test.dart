import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

const _minimalCostPrefix = r'$argon2id$v=19$m=8,t=1,p=1$';

void main() {
  const pepper = 'test-pepper';
  final jwt = Jwt(
    config: JwtConfig(
      algorithm: HmacSha512JwtAlgorithmConfiguration(
        key: SecretKey('test-private-key-for-HS512'),
      ),
      refreshTokenHashPepper: pepper,
    ),
  );

  withServerpod('Given an auth user,', (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();
      authUserId = (await jwt.authUsers.create(session)).id;
    });

    test(
      'when creating a token pair, '
      'then the rotating secret is stored at the minimal Argon2 cost',
      () async {
        await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );

        final refreshToken = await RefreshToken.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
        );
        expect(
          refreshToken?.rotatingSecretHash,
          startsWith(_minimalCostPrefix),
        );
      },
    );
  });

  withServerpod(
    'Given a refresh token whose rotating secret is stored at the default Argon2 cost,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late AuthSuccess authSuccess;

      setUp(() async {
        session = sessionBuilder.build();
        authUserId = (await jwt.authUsers.create(session)).id;
        authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );

        final rotatingSecret = base64Decode(
          authSuccess.refreshToken!.split(':')[3],
        );
        final defaultCostHash = await Argon2HashUtil(
          hashPepper: pepper,
          hashSaltLength: 16,
        ).createHashFromBytes(secret: rotatingSecret);

        final refreshToken = await RefreshToken.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
        );
        await RefreshToken.db.updateRow(
          session,
          refreshToken!.copyWith(rotatingSecretHash: defaultCostHash),
        );
      });

      test(
        'when refreshing the access token, '
        'then a new token pair is returned',
        () async {
          final refreshed = await jwt.refreshAccessToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          expect(refreshed.refreshToken, isNot(authSuccess.refreshToken));
        },
      );

      test(
        'when refreshing the access token, '
        'then the new rotating secret is stored at the minimal Argon2 cost',
        () async {
          await jwt.refreshAccessToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          final refreshToken = await RefreshToken.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );
          expect(
            refreshToken?.rotatingSecretHash,
            startsWith(_minimalCostPrefix),
          );
        },
      );

      test(
        'when refreshing with another rotating secret, '
        'then RefreshTokenInvalidSecretException is thrown',
        () async {
          final parts = authSuccess.refreshToken!.split(':');
          parts[3] = base64Encode(List.filled(64, 0));

          await expectLater(
            jwt.refreshAccessToken(session, refreshToken: parts.join(':')),
            throwsA(isA<RefreshTokenInvalidSecretException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a refresh token whose rotating secret is stored with a 4 byte salt,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late AuthSuccess authSuccess;

      setUp(() async {
        session = sessionBuilder.build();
        authUserId = (await jwt.authUsers.create(session)).id;
        authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );

        final refreshToken = await RefreshToken.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
        );
        await RefreshToken.db.updateRow(
          session,
          refreshToken!.copyWith(
            rotatingSecretHash:
                '${_minimalCostPrefix}AQIDBA==\$${base64Encode(List.filled(32, 0))}',
          ),
        );
      });

      test(
        'when refreshing the access token, '
        'then RefreshTokenInvalidSecretException is thrown',
        () async {
          await expectLater(
            jwt.refreshAccessToken(
              session,
              refreshToken: authSuccess.refreshToken!,
            ),
            throwsA(isA<RefreshTokenInvalidSecretException>()),
          );
        },
      );

      test(
        'when refreshing the access token, '
        'then the refresh token is deleted',
        () async {
          await expectLater(
            jwt.refreshAccessToken(
              session,
              refreshToken: authSuccess.refreshToken!,
            ),
            throwsA(anything),
          );

          final refreshToken = await RefreshToken.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );
          expect(refreshToken, isNull);
        },
      );
    },
  );
}
