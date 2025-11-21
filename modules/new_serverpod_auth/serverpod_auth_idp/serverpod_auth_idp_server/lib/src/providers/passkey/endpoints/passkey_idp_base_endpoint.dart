import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';

import '../passkey.dart';

/// Base endpoint for Passkey-based authentication.
abstract class PasskeyIDPBaseEndpoint extends Endpoint {
  /// Gets the [PasskeyIDP] instance from the [AuthServices] instance.
  ///
  /// If you want to use a different instance, override this getter.
  late final PasskeyIDP passkeyIDP =
      AuthServices.getIdentityProvider<PasskeyIDP>();

  /// Returns a new challenge to be used for a login or registration request.
  Future<PasskeyChallengeResponse> createChallenge(
    final Session session,
  ) async {
    return await passkeyIDP.createChallenge(session);
  }

  /// Registers a Passkey for the [session]'s current user.
  ///
  /// Throws if the user is not authenticated.
  Future<void> register(
    final Session session, {
    required final PasskeyRegistrationRequest registrationRequest,
  }) async {
    await passkeyIDP.register(
      session,
      authUserId: session.authenticated!.authUserId,
      request: registrationRequest,
    );
  }

  /// Authenticates the user related to the given Passkey.
  Future<AuthSuccess> login(
    final Session session, {
    required final PasskeyLoginRequest loginRequest,
  }) async {
    return await passkeyIDP.login(session, request: loginRequest);
  }
}
