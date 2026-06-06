import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: 'test-pepper',
  );

  const newEmailIdpConfig = EmailIdpConfig(secretHashPepper: 'test');
  final googleIdpConfig = GoogleIdpConfig(
    clientSecret: GoogleClientSecret.fromJson({
      'web': {
        'client_id': 'id',
        'client_secret': 'secret',
        'redirect_uris': ['uri'],
      },
    }),
  );

  withServerpod('Given no legacy passwords,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;

    setUp(() {
      session = sessionBuilder.build();
      AuthServices.set(
        identityProviderBuilders: [
          newEmailIdpConfig,
        ],
        tokenManagerBuilders: [tokenManagerConfig],
      );
    });

    tearDown(() {
      AuthServices.set(
        identityProviderBuilders: [],
        tokenManagerBuilders: [tokenManagerConfig],
      );
    });

    test(
      'when attempting to run `importLegacyPasswordIfNeeded` for a non-existent account, then it completes without error.',
      () async {
        await expectLater(
          AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
            session,
            email: '404@serverpod.dev',
            password: 'DoesNotExist123!',
          ),
          completes,
        );
      },
    );
  });

  withServerpod('Given legacy identifiers for Google migration,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;

    setUp(() {
      session = sessionBuilder.build();
      AuthServices.set(
        identityProviderBuilders: [
          newEmailIdpConfig,
          googleIdpConfig,
        ],
        tokenManagerBuilders: [tokenManagerConfig],
      );
    });

    tearDown(() {
      AuthServices.set(
        identityProviderBuilders: [],
        tokenManagerBuilders: [tokenManagerConfig],
      );
    });

    test(
      'when importing with a matching Google user identifier then it links and clears the legacy identifier.',
      () async {
        final authUser = await const AuthUsers().create(session);
        await AuthBackwardsCompatibility.storeLegacyExternalUserIdentifier(
          session,
          authUserId: authUser.id,
          userIdentifier: 'google-sub-123',
        );

        await AuthBackwardsCompatibility.importGoogleAccountFromDetails(
          session,
          accountDetails: _googleAccountDetails(
            userIdentifier: 'google-sub-123',
            email: 'legacy.user@example.com',
          ),
        );

        final googleAccount = (await GoogleAccount.db.find(session)).single;
        expect(googleAccount.authUserId, authUser.id);
        expect(googleAccount.userIdentifier, 'google-sub-123');
        expect(googleAccount.email, 'legacy.user@example.com');

        expect(
          await AuthBackwardsCompatibility.lookUpLegacyExternalUserIdentifier(
            session,
            userIdentifier: 'google-sub-123',
          ),
          isNull,
        );
      },
    );

    test(
      'when importing with no Google user identifier match but a case-insensitive email match then it links and clears the email-based legacy identifier.',
      () async {
        final authUser = await const AuthUsers().create(session);
        await AuthBackwardsCompatibility.storeLegacyExternalUserIdentifier(
          session,
          authUserId: authUser.id,
          userIdentifier: 'Legacy.User@Example.com',
        );

        await AuthBackwardsCompatibility.importGoogleAccountFromDetails(
          session,
          accountDetails: _googleAccountDetails(
            userIdentifier: 'google-sub-456',
            email: 'legacy.user@example.com',
          ),
        );

        final googleAccount = (await GoogleAccount.db.find(session)).single;
        expect(googleAccount.authUserId, authUser.id);
        expect(googleAccount.userIdentifier, 'google-sub-456');
        expect(googleAccount.email, 'legacy.user@example.com');

        expect(
          await AuthBackwardsCompatibility.lookUpLegacyExternalUserIdentifier(
            session,
            userIdentifier: 'Legacy.User@Example.com',
          ),
          isNull,
        );
      },
    );

    test(
      'when importing with no matching identifier then it does not link and does not clear unrelated mappings.',
      () async {
        final authUser = await const AuthUsers().create(session);
        await AuthBackwardsCompatibility.storeLegacyExternalUserIdentifier(
          session,
          authUserId: authUser.id,
          userIdentifier: 'someone@example.com',
        );

        await AuthBackwardsCompatibility.importGoogleAccountFromDetails(
          session,
          accountDetails: _googleAccountDetails(
            userIdentifier: 'google-sub-789',
            email: 'nomatch@example.com',
          ),
        );

        expect(await GoogleAccount.db.find(session), isEmpty);
        expect(
          await AuthBackwardsCompatibility.lookUpLegacyExternalUserIdentifier(
            session,
            userIdentifier: 'someone@example.com',
          ),
          authUser.id,
        );
      },
    );
  });
}

GoogleAccountDetails _googleAccountDetails({
  required final String userIdentifier,
  required final String email,
}) {
  return (
    userIdentifier: userIdentifier,
    email: email,
    name: null,
    fullName: null,
    image: null,
    verifiedEmail: true,
  );
}
