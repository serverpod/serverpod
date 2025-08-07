import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given 1 active and 1 expired Apple-backed auth user,',
    (final sessionBuilder, final _) {
      late Session session;
      late UuidValue activeUser;
      late UuidValue inactiveUser;
      late AppleAccountsAdmin admin;

      setUp(() async {
        session = sessionBuilder.build();

        activeUser = await _createAppleBackedUser(session);
        inactiveUser = await _createAppleBackedUser(session);

        final siwa = _SignInWithAppleFake(knownRefreshTokens: {
          activeUser.uuid,
        });
        admin = AppleAccountsAdmin(siwa);
      });

      test(
          'when calling `AppleAccountsAdmin.checkAccountStatus`, then the callback is invoked for the expired one.',
          () async {
        final expiredUsers = <UuidValue>{};

        await admin.checkAccountStatus(
          session,
          onExpiredUserAuthentication: expiredUsers.add,
        );

        expect(expiredUsers, equals({inactiveUser}));
      });

      test(
          'when calling `AppleAccountsAdmin.checkAccountStatus`, then all `lastRefreshedAt` timestamps are updated.',
          () async {
        final timeBeforeUpdate = DateTime.now();

        await admin.checkAccountStatus(
          session,
          onExpiredUserAuthentication: (final _) {},
        );

        for (final appleAccount in await AppleAccount.db.find(session)) {
          expect(
            appleAccount.lastRefreshedAt.isAfter(timeBeforeUpdate),
            isTrue,
          );
        }
      });
    },
  );
}

/// Creates an `AuthUser` with Apple authentication with a refresh token equal to the user id.
///
/// The account's refresh token is marked as not having been checked in the last 24 hours,
/// so that it will get picked up by the next `checkAccountStatus` run.
Future<UuidValue> _createAppleBackedUser(final Session session) async {
  final authUser = await AuthUsers.create(session);

  await AppleAccount.db.insertRow(
    session,
    AppleAccount(
      userIdentifier: authUser.id.toString(),
      refreshToken: authUser.id.toString(),
      refreshTokenRequestedWithBundleIdentifier: false,
      email: '${authUser.id}@serverpod.dev',
      isEmailVerified: true,
      isPrivateEmail: false,
      authUserId: authUser.id,
      firstName: 'firstName',
      lastName: 'lastName',
      lastRefreshedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  );

  return authUser.id;
}

class _SignInWithAppleFake extends Fake implements SignInWithApple {
  final Set<String> knownRefreshTokens;

  _SignInWithAppleFake({
    required this.knownRefreshTokens,
  });

  @override
  Future<RefreshTokenValidationResponse> validateRefreshToken(
    final String refreshToken, {
    required final bool useBundleIdentifier,
  }) async {
    if (knownRefreshTokens.contains(refreshToken)) {
      return RefreshTokenValidationResponse(
        accessToken: '',
        accessTokenExpiresIn: 0,
        idToken: '',
      );
    } else {
      throw RevokedTokenException();
    }
  }
}
