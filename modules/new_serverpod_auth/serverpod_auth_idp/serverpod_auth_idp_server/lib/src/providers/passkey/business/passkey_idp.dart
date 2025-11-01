import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:passkeys_server/passkeys_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/util/byte_data_extension.dart';

/// Passkey account management functions.
final class PasskeyIDP {
  /// Administrative methods for working with Passkey-backed accounts.
  final PasskeyIDPAdmin admin;

  /// The configuration for the Passkey identity provider.
  final PasskeyIDPConfig config;

  final Passkeys _passkeys;

  /// Creates a new instance of [PasskeyIDP].
  PasskeyIDP(
    this.config,
  )   : admin = PasskeyIDPAdmin(challengeLifetime: config.challengeLifetime),
        _passkeys = Passkeys(
          config: PasskeysConfig(
            relyingPartyId: config.hostname,
          ),
        );

  /// Creates a new challenge to be used for a subsequent registration or login.
  Future<PasskeyChallenge> createChallenge(final Session session) async {
    final challengeBytes = await _passkeys.createChallenge();

    final challenge = await PasskeyChallenge.db.insertRow(
      session,
      PasskeyChallenge(challenge: ByteData.sublistView(challengeBytes)),
    );

    return challenge;
  }

  /// Links the given passkey to the [session]'s current user.
  Future<void> registerPasskey(
    final Session session, {
    required final PasskeyRegistrationRequest request,
    final Transaction? transaction,
  }) async {
    final authUserId = (await session.authenticated)!.authUserId;

    final challenge = await _consumeChallenge(
      session,
      request.challengeId,
      transaction: transaction,
    );

    await _passkeys.verifyRegistration(
      keyId: request.keyId.asUint8List,
      attestationObject: request.attestationObject.asUint8List,
      clientDataJSON: request.clientDataJSON.asUint8List,
      challenge: challenge.challenge.asUint8List,
    );

    await PasskeyAccount.db.insertRow(
      session,
      PasskeyAccount(
        authUserId: authUserId,
        keyId: request.keyId,
        keyIdBase64: base64Encode(request.keyId.asUint8List),
        clientDataJSON: request.clientDataJSON,
        attestationObject: request.attestationObject,
        originalChallenge: challenge.challenge,
      ),
    );
  }

  /// Authenticates the client with the given Passkey credentials.
  ///
  /// Returns the [AuthUser]'s ID upon successful login.
  Future<UuidValue> authenticate(
    final Session session, {
    required final PasskeyLoginRequest request,
    final Transaction? transaction,
  }) async {
    final challenge = await _consumeChallenge(
      session,
      request.challengeId,
      transaction: transaction,
    );

    final passkeyAccount = await _getAccount(
      session,
      keyId: request.keyId,
      transaction: transaction,
    );

    await _passkeys.verifyLogin(
      registrationAttestationObject:
          passkeyAccount.attestationObject.asUint8List,
      authenticatorData: request.authenticatorData.asUint8List,
      clientDataJSON: request.clientDataJSON.asUint8List,
      signature: request.signature.asUint8List,
      challenge: challenge.challenge.asUint8List,
    );

    return passkeyAccount.authUserId;
  }

  /// Returns the challenge and deletes it from the database (as each challenge
  /// should only be used once).
  Future<PasskeyChallenge> _consumeChallenge(
    final Session session,
    final UuidValue challengeId, {
    final Transaction? transaction,
  }) async {
    final challenge = await PasskeyChallenge.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(challengeId),
      transaction: transaction,
    );

    if (challenge.isEmpty) {
      throw PasskeyChallengeNotFoundException();
    }

    if (challenge.single.createdAt
        .isBefore(clock.now().subtract(config.challengeLifetime))) {
      throw PasskeyChallengeExpiredException();
    }

    return challenge.single;
  }

  Future<PasskeyAccount> _getAccount(
    final Session session, {
    required final ByteData keyId,
    final Transaction? transaction,
  }) async {
    final account = await PasskeyAccount.db.findFirstRow(
      session,
      where: (final t) => t.keyIdBase64.equals(base64Encode(keyId.asUint8List)),
      transaction: transaction,
    );

    if (account == null) {
      throw PasskeyPublicKeyNotFoundException();
    }

    return account;
  }
}
