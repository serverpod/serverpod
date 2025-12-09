import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../business/apple_idp.dart';

/// Endpoint for handling Sign in with Apple.
///
/// To expose these endpoint methods on your server, extend this class in a
/// concrete class.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
abstract class AppleIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured Apple Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  AppleIdp get appleIdp => AuthServices.instance.appleIdp;

  /// {@template apple_idp_base_endpoint.login}
  /// Signs in a user with their Apple account.
  ///
  /// If no user exists yet linked to the Apple-provided identifier, a new one
  /// will be created (without any `Scope`s). Further their provided name and
  /// email (if any) will be used for the `UserProfile` which will be linked to
  /// their `AuthUser`.
  ///
  /// Returns a session for the user upon successful login.
  /// {@endtemplate}
  Future<AuthSuccess> login(
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
    return appleIdp.login(
      session,
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// {@template apple_idp_base_endpoint.link}
  /// Attaches an Apple authentication to the current user.
  ///
  /// [identityToken] is the identity token from Apple.
  /// [authorizationCode] is the authorization code from Apple.
  /// [isNativeApplePlatformSignIn] indicates if the sign-in was triggered from a native Apple platform app.
  /// [firstName] is the user's first name (optional).
  /// [lastName] is the user's last name (optional).
  /// [transaction] is the transaction to use for the database operations.
  /// {@endtemplate}
  Future<AuthSuccess> link(
    final Session session, {
    required final String identityToken,
    required final String authorizationCode,
    required final bool isNativeApplePlatformSignIn,
    final String? firstName,
    final String? lastName,
    final Transaction? transaction,
  }) async {
    return appleIdp.link(
      session,
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
      firstName: firstName,
      lastName: lastName,
      transaction: transaction,
    );
  }

  /// {@macro apple_idp_base_endpoint.has_apple_account}
  Future<bool> hasAppleAccount(final Session session) async {
    return appleIdp.hasAppleAccount(session);
  }
}
