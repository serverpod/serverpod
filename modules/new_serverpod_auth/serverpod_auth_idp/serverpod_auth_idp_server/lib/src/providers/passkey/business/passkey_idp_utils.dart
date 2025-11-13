import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:passkeys_server/passkeys_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';

import '../../../generated/protocol.dart';
import '../../../utils/byte_data_extension.dart';

/// Utility functions for the Passkey identity provider.
final class PasskeyIDPUtils {
  final Duration _challengeLifetime;
  final Passkeys _passkeys;

  /// Creates a new instance of [PasskeyIDPUtils].
  PasskeyIDPUtils({
    required final Duration challengeLifetime,
    required final Passkeys passkeys,
  }) : _challengeLifetime = challengeLifetime,
       _passkeys = passkeys;

  /// Returns the challenge and deletes it from the database (as each challenge
  /// should only be used once).
  ///
  /// Throws a [PasskeyChallengeNotFoundException] if the challenge is not found.
  /// Throws a [PasskeyChallengeExpiredException] if the challenge has expired.
  Future<PasskeyChallenge> _consumeChallenge(
    final Session session,
    final UuidValue challengeId, {
    required final Transaction? transaction,
  }) async {
    final challenge = await PasskeyChallenge.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(challengeId),
      transaction: transaction,
    );

    if (challenge.isEmpty) {
      throw PasskeyChallengeNotFoundException();
    }

    if (challenge.single.createdAt.isBefore(
      clock.now().subtract(_challengeLifetime),
    )) {
      throw PasskeyChallengeExpiredException();
    }

    return challenge.single;
  }

  /// Creates a new challenge to be used for a subsequent registration or login.
  Future<PasskeyChallenge> createChallenge(
    final Session session, {
    required final Transaction? transaction,
  }) async {
    final challengeBytes = await _passkeys.createChallenge();

    final challenge = await PasskeyChallenge.db.insertRow(
      session,
      PasskeyChallenge(challenge: ByteData.sublistView(challengeBytes)),
      transaction: transaction,
    );

    return challenge;
  }

  /// Authenticates the client with the given Passkey credentials.
  ///
  /// Returns the [AuthUser]'s ID upon successful login.
  ///
  /// Throws a [PasskeyChallengeNotFoundException] if the challenge is not found.
  /// Throws a [PasskeyChallengeExpiredException] if the challenge has expired.
  /// Throws a [PasskeyPublicKeyNotFoundException] if the public key is not found.
  Future<UuidValue> authenticate(
    final Session session, {
    required final PasskeyLoginRequest request,
    required final Transaction? transaction,
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

  /// Links the given passkey to the [authUserId].
  Future<void> registerPasskey(
    final Session session, {
    required final UuidValue authUserId,
    required final PasskeyRegistrationRequest request,
    required final Transaction? transaction,
  }) async {
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
      transaction: transaction,
    );
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

  /// Deletes all passkey accounts matching the given filters.
  ///
  /// If [authUserId] is provided, only the passkey accounts for that user will be deleted.
  /// If [passkeyAccountId] is provided, only the passkey account with that ID will be deleted.
  Future<List<DeletedPasskeyAccount>> deletePasskeyAccounts(
    final Session session, {
    required final UuidValue? authUserId,
    required final UuidValue? passkeyAccountId,
    required final Transaction? transaction,
  }) async {
    final removedAccounts = await PasskeyAccount.db.deleteWhere(
      session,
      where: (final t) {
        Expression expression = Constant.bool(true);

        if (authUserId != null) {
          expression &= t.authUserId.equals(authUserId);
        }

        if (passkeyAccountId != null) {
          expression &= t.id.equals(passkeyAccountId);
        }

        return expression;
      },
      transaction: transaction,
    );

    return removedAccounts
        .map(
          (final account) => (
            authUserId: account.authUserId,
            passkeyAccountId: account.id!,
          ),
        )
        .toList();
  }
}

/// A tuple of (auth user ID, passkey account ID) representing a deleted
/// passkey account.
typedef DeletedPasskeyAccount = ({
  UuidValue authUserId,
  UuidValue passkeyAccountId,
});
