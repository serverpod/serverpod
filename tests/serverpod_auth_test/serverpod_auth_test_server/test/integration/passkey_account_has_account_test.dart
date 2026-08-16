import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: 'test-pepper-long-enough',
  );

  setUp(() async {
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [
        const PasskeyIdpConfig(
          hostname: 'localhost',
        ),
      ],
    );
  });

  tearDown(() async {
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [],
    );
  });

  withServerpod(
    'Given an unauthenticated session',
    (final sessionBuilder, final endpoints) {
      test(
        'when calling hasAccount then it returns false',
        () async {
          final result = await endpoints.passkeyAccount.hasAccount(
            sessionBuilder,
          );
          expect(result, isFalse);
        },
      );
    },
  );

  withServerpod('Given an authenticated session but no Passkey account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late TestSessionBuilder session;

    setUp(() async {
      session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          const Uuid().v4obj().uuid,
          {},
        ),
      );
    });

    test(
      'when calling hasAccount then it returns false',
      () async {
        final result = await endpoints.passkeyAccount.hasAccount(session);
        expect(result, isFalse);
      },
    );
  });

  withServerpod('Given an authenticated session with a Passkey account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late AuthUserModel authUser;
    late TestSessionBuilder session;

    setUp(() async {
      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      await PasskeyAccount.db.insertRow(
        setupSession,
        PasskeyAccount(
          authUserId: authUser.id,
          keyId: ByteData(0),
          keyIdBase64: 'base64',
          clientDataJSON: ByteData(0),
          attestationObject: ByteData(0),
          originalChallenge: ByteData(0),
        ),
      );
      session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          authUser.id.uuid,
          {},
        ),
      );
    });

    test(
      'when calling hasAccount then it returns true',
      () async {
        final result = await endpoints.passkeyAccount.hasAccount(session);
        expect(result, isTrue);
      },
    );
  });
}
