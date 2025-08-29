import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';

/// Base endpoint for Passkey-based authentication.
abstract class PasskeyAccountBaseEndpoint extends Endpoint {
  static const String _method = 'passkey';

  /// Returns a new challenge to be used for a login or registration request.
  Future<PasskeyChallengeResponse> createChallenge(
    final Session session,
  ) async {
    final challenge = await PasskeyAccounts.createChallenge(session);

    return (id: challenge.id!, challenge: challenge.challenge);
  }

  /// Registers a Passkey for the [session]'s current user.
  Future<void> register(
    final Session session, {
    required final PasskeyRegistrationRequest registrationRequest,
  }) async {
    return session.db.transaction((final transaction) async {
      await PasskeyAccounts.registerPasskey(
        session,
        request: registrationRequest,
        transaction: transaction,
      );
    });
  }

  /// Authenticates the user related to the given Passkey.
  Future<AuthSuccess> authenticate(
    final Session session, {
    required final PasskeyLoginRequest loginRequest,
  }) async {
    return session.db.transaction((final transaction) async {
      final authUserId = await PasskeyAccounts.authenticate(
        session,
        request: loginRequest,
        transaction: transaction,
      );

      return _createSession(
        session,
        authUserId,
        transaction: transaction,
      );
    });
  }

  Future<AuthSuccess> _createSession(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
  }) async {
    final authUser = await AuthUsers.get(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );

    if (authUser.blocked) {
      throw AuthUserBlockedException();
    }

    final sessionKey = await AuthSessions.createSession(
      session,
      authUserId: authUserId,
      method: _method,
      scopes: authUser.scopes,
      transaction: transaction,
    );

    return sessionKey;
  }
}

/// A challenge to be used for a passkey registration or login.
typedef PasskeyChallengeResponse = ({
  UuidValue id,
  ByteData challenge,
});
