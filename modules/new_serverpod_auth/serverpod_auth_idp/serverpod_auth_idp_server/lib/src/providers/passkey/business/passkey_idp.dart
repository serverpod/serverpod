import 'dart:typed_data';

import 'package:passkeys_server/passkeys_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart';

import 'passkey_idp_admin.dart';
import 'passkey_idp_config.dart';
import 'passkey_idp_utils.dart';

/// Passkey account management functions.
final class PasskeyIDP {
  /// The method used when authenticating with the Passkey identity provider.
  static const String method = 'passkey';

  /// Administrative methods for working with Passkey-backed accounts.
  final PasskeyIDPAdmin admin;

  /// The configuration for the Passkey identity provider.
  final PasskeyIDPConfig config;

  /// Utility functions for the Passkey identity provider.
  final PasskeyIDPUtils utils;

  final AuthUsers _authUsers;
  final TokenIssuer _tokenIssuer;

  PasskeyIDP._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this.admin,
    this._authUsers,
  );

  /// Creates a new instance of [PasskeyIDP].
  factory PasskeyIDP(
    final PasskeyIDPConfig config, {
    required final TokenIssuer tokenIssuer,
    final AuthUsers authUsers = const AuthUsers(),
  }) {
    final utils = PasskeyIDPUtils(
      challengeLifetime: config.challengeLifetime,
      passkeys: Passkeys(
        config: PasskeysConfig(relyingPartyId: config.hostname),
      ),
    );

    return PasskeyIDP._(
      config,
      tokenIssuer,
      utils,
      PasskeyIDPAdmin(
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
}

/// A challenge to be used for a passkey registration or login.
typedef PasskeyChallengeResponse = ({UuidValue id, ByteData challenge});
