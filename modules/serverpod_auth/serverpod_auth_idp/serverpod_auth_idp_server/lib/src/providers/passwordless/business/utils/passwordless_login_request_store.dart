import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';

/// DB-backed request store using [GenericPasswordlessLoginRequest].
class GenericPasswordlessLoginRequestStore {
  /// Creates a DB-backed store.
  const GenericPasswordlessLoginRequestStore();

  /// Creates a new request row.
  Future<UuidValue> createRequest(
    final Session session, {
    required final String serializedHandle,
    required final UuidValue challengeId,
    required final Transaction transaction,
  }) async {
    final request = await GenericPasswordlessLoginRequest.db.insertRow(
      session,
      GenericPasswordlessLoginRequest(
        nonce: serializedHandle,
        challengeId: challengeId,
      ),
      transaction: transaction,
    );
    return request.id!;
  }

  /// Deletes requests and their associated challenges for [serializedHandle].
  Future<void> deleteByHandle(
    final Session session, {
    required final String serializedHandle,
    required final Transaction transaction,
  }) async {
    final deleted = await GenericPasswordlessLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.nonce.equals(serializedHandle),
      transaction: transaction,
    );
    await _deleteChallenges(session, deleted, transaction: transaction);
  }

  /// Deletes a request and its associated challenge by [requestId].
  ///
  /// Returns `true` if a request was deleted, `false` if it did not exist.
  Future<bool> deleteById(
    final Session session, {
    required final UuidValue requestId,
    final Transaction? transaction,
  }) async {
    final deleted = await GenericPasswordlessLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(requestId),
      transaction: transaction,
    );
    await _deleteChallenges(session, deleted, transaction: transaction);
    return deleted.isNotEmpty;
  }

  /// Loads request data with verification challenge.
  Future<PasswordlessLoginRequestData?> getRequestWithChallenge(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    final request = await GenericPasswordlessLoginRequest.db.findById(
      session,
      requestId,
      transaction: transaction,
      include: GenericPasswordlessLoginRequest.include(
        challenge: SecretChallenge.include(),
      ),
    );
    return request?._toData();
  }

  static Future<void> _deleteChallenges(
    final Session session,
    final List<GenericPasswordlessLoginRequest> requests, {
    final Transaction? transaction,
  }) async {
    final challengeIds = requests.map((final r) => r.challengeId).toSet();
    if (challengeIds.isNotEmpty) {
      await SecretChallenge.db.deleteWhere(
        session,
        where: (final t) => t.id.inSet(challengeIds),
        transaction: transaction,
      );
    }
  }
}

/// Snapshot of a passwordless login request used by business logic.
class PasswordlessLoginRequestData {
  /// Request identifier.
  final UuidValue id;

  /// Request creation timestamp.
  final DateTime createdAt;

  /// Serialized handle stored with the request.
  final String serializedHandle;

  /// Verification challenge.
  final SecretChallenge? challenge;

  /// Creates a [PasswordlessLoginRequestData].
  const PasswordlessLoginRequestData({
    required this.id,
    required this.createdAt,
    required this.serializedHandle,
    required this.challenge,
  });
}

extension on GenericPasswordlessLoginRequest {
  PasswordlessLoginRequestData _toData() {
    return PasswordlessLoginRequestData(
      id: id!,
      createdAt: createdAt,
      serializedHandle: nonce,
      challenge: challenge,
    );
  }
}
