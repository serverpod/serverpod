import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../business/passkey_idp.dart';

/// Base endpoint for Passkey-based authentication.
abstract class PasskeyIdpBaseEndpoint extends IdpBaseEndpoint {
  /// Gets the [PasskeyIdp] instance from the [AuthServices] instance.
  ///
  /// If you want to use a different instance, override this getter.
  late final PasskeyIdp passkeyIdp =
      AuthServices.getIdentityProvider<PasskeyIdp>();

  /// Returns a new challenge to be used for a login or registration request.
  Future<PasskeyChallengeResponse> createChallenge(
    Session session,
  ) async {
    return await passkeyIdp.createChallenge(session);
  }

  /// Registers a Passkey for the [session]'s current user.
  ///
  /// Throws if the user is not authenticated.
  Future<void> register(
    Session session, {
    required PasskeyRegistrationRequest registrationRequest,
  }) async {
    await passkeyIdp.register(
      session,
      authUserId: session.authenticated!.authUserId,
      request: registrationRequest,
    );
  }

  /// Authenticates the user related to the given Passkey.
  Future<AuthSuccess> login(
    Session session, {
    required PasskeyLoginRequest loginRequest,
  }) async {
    return await passkeyIdp.login(session, request: loginRequest);
  }

  @override
  Future<bool> hasAccount(Session session) async =>
      await passkeyIdp.hasAccount(session);
}
