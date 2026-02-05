import 'dart:typed_data';

import 'package:passkeys_server/passkeys_server.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'passkey_idp_admin.dart';
import 'passkey_idp_config.dart';
import 'passkey_idp_utils.dart';

/// Passkey account management functions.
class PasskeyIdp extends Idp {
  /// The method used when authenticating with the Passkey identity provider.
  static const String method = 'passkey';

  /// Administrative methods for working with Passkey-backed accounts.
  final PasskeyIdpAdmin admin;

  /// The configuration for the Passkey identity provider.
  final PasskeyIdpConfig config;

  /// Utility functions for the Passkey identity provider.
  final PasskeyIdpUtils utils;

  final AuthUsers _authUsers;
  final TokenIssuer _tokenIssuer;

  PasskeyIdp._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this.admin,
    this._authUsers,
  );

  /// Creates a new instance of [PasskeyIdp].
  factory PasskeyIdp(
    final PasskeyIdpConfig config, {
    required final TokenIssuer tokenManager,
    final AuthUsers authUsers = const AuthUsers(),
  }) {
    final utils = PasskeyIdpUtils(
      challengeLifetime: config.challengeLifetime,
      passkeys: Passkeys(
        config: PasskeysConfig(relyingPartyId: config.hostname),
      ),
    );

    return PasskeyIdp._(
      config,
      tokenManager,
      utils,
      PasskeyIdpAdmin(
        challengeLifetime: config.challengeLifetime,
        utils: utils,
      ),
      authUsers,
    );
  }

  /// Creates a new challenge to be used for a subsequent registration or login.
  Future<PasskeyChallengeResponse> createChallenge(
    final Session session, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final challenge = await utils.createChallenge(
          session,
          transaction: transaction,
        );

        return (id: challenge.id!, challenge: challenge.challenge);
      },
    );
  }

  /// Links the given passkey to the given [authUserId].
  Future<void> register(
    final Session session, {
    required final UuidValue authUserId,
    required final PasskeyRegistrationRequest request,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      await utils.registerPasskey(
        session,
        authUserId: authUserId,
        request: request,
        transaction: transaction,
      );
    });
  }

  /// Authenticates the client with the given Passkey credentials.
  ///
  /// Returns the [AuthUser]'s ID upon successful login.
  Future<AuthSuccess> login(
    final Session session, {
    required final PasskeyLoginRequest request,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      final authUserId = await utils.authenticate(
        session,
        request: request,
        transaction: transaction,
      );

      final authUser = await _authUsers.get(
        session,
        authUserId: authUserId,
        transaction: transaction,
      );

      if (authUser.blocked) {
        throw AuthUserBlockedException();
      }

      return _tokenIssuer.issueToken(
        session,
        authUserId: authUserId,
        method: method,
        scopes: authUser.scopes,
        transaction: transaction,
      );
    });
  }

  @override
  Future<bool> hasAccount(final Session session) async =>
      await utils.getAccount(session) != null;
}

/// A challenge to be used for a passkey registration or login.
typedef PasskeyChallengeResponse = ({UuidValue id, ByteData challenge});

/// Extension to get the PasskeyIdp instance from the AuthServices.
extension PasskeyIdpGetter on AuthServices {
  /// Returns the PasskeyIdp instance from the AuthServices.
  PasskeyIdp get passkeyIdp => AuthServices.getIdentityProvider<PasskeyIdp>();
}
