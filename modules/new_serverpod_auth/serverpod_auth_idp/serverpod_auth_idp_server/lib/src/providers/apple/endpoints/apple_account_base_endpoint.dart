import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/session.dart';

import '../apple.dart';

/// Endpoint for handling Sign in with Apple.
///
/// To expose these endpoint methods on your server, extend this class in a
/// concrete class.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
abstract class AppleAccountBaseEndpoint extends Endpoint {
  static const String _method = 'apple';

  /// Signs in a user with their Apple account.
  ///
  /// If no user exists yet linked to the Apple-provided identifier, a new one
  /// will be created (without any `Scope`s). Further their provided name and
  /// email (if any) will be used for the `UserProfile` which will be linked to
  /// their `AuthUser`.
  ///
  /// Returns a session for the user upon successful login.
  Future<AuthSuccess> signIn(
    final Session session, {
    required final String identityToken,
    required final String authorizationCode,

    /// Whether the sign-in was triggered from a native Apple platform app.
    ///
    /// Pass `false` for web sign-ins or 3rd party platforms like Android.
    required final bool isNativeApplePlatformSignIn,
    final String? firstName,
    final String? lastName,
  }) async {
    return session.db.transaction((final transaction) async {
      final account = await AppleAccounts.signIn(
        session,
        identityToken: identityToken,
        authorizationCode: authorizationCode,
        isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
        firstName: firstName,
        lastName: lastName,
        transaction: transaction,
      );

      if (account.authUserNewlyCreated) {
        await UserProfiles.createUserProfile(
          session,
          account.authUserId,
          UserProfileData(
            fullName: [account.details.firstName, account.details.lastName]
                .nonNulls
                .map((final n) => n.trim())
                .where((final n) => n.isNotEmpty)
                .join(' '),
            email: account.details.isVerifiedEmail == true
                ? account.details.email
                : null,
          ),
          transaction: transaction,
        );
      }

      return _createSession(
        session,
        account.authUserId,
        transaction: transaction,
      );
    });
  }

  Future<AuthSuccess> _createSession(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    return AuthSessions.createSession(
      session,
      authUserId: authUserId,
      method: _method,
      transaction: transaction,
    );
  }
}
