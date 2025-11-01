import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../apple.dart';

/// Endpoint for handling Sign in with Apple.
///
/// To expose these endpoint methods on your server, extend this class in a
/// concrete class.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
abstract class AppleIDPBaseEndpoint extends Endpoint {
  /// Accessor for the configured Apple IDP instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  AppleIDP get appleIDP => AuthServices.getIdentityProvider<AppleIDP>();

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
    return appleIDP.login(
      session,
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
