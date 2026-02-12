import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';

/// Snapshot of a passwordless login request used by business logic.
class PasswordlessLoginRequestData {
  /// Request identifier.
  final UuidValue id;

  /// Request creation timestamp.
  final DateTime createdAt;

  /// Opaque user handle nonce.
  final String nonce;

  /// Verification challenge.
  final SecretChallenge? challenge;

  /// Completion challenge id if already linked.
  final UuidValue? loginChallengeId;

  /// Completion challenge if loaded.
  final SecretChallenge? loginChallenge;

  /// Creates a [PasswordlessLoginRequestData].
  const PasswordlessLoginRequestData({
    required this.id,
    required this.createdAt,
    required this.nonce,
    required this.challenge,
    required this.loginChallengeId,
    required this.loginChallenge,
  });
}

/// Storage contract for passwordless login requests.
abstract interface class PasswordlessLoginRequestStore {
  /// Deletes requests for [nonce].
  Future<void> deleteByNonce(
    final Session session, {
    required final String nonce,
    required final Transaction transaction,
  });

  /// Creates a new request row.
  Future<UuidValue> createRequest(
    final Session session, {
    required final String nonce,
    required final UuidValue challengeId,
    required final Transaction transaction,
  });

  /// Loads request data for verification step.
  Future<PasswordlessLoginRequestData?> getRequestForVerification(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  });

  /// Loads request data for completion step.
  Future<PasswordlessLoginRequestData?> getRequestForCompletion(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  });

  /// Atomically links completion challenge if not linked yet.
  Future<bool> linkCompletionChallengeAtomically(
    final Session session, {
    required final UuidValue requestId,
    required final UuidValue completionChallengeId,
    required final Transaction? transaction,
  });

  /// Deletes a request by [requestId].
  ///
  /// Returns `true` if a request was deleted, `false` if it did not exist.
  Future<bool> deleteById(
    final Session session, {
    required final UuidValue requestId,
    final Transaction? transaction,
  });
}

/// Default DB-backed request store using [PasswordlessLoginRequest].
class DefaultDbPasswordlessLoginRequestStore
    implements PasswordlessLoginRequestStore {
  /// Creates a new default DB-backed store.
  const DefaultDbPasswordlessLoginRequestStore();

  @override
  Future<void> deleteByNonce(
    final Session session, {
    required final String nonce,
    required final Transaction transaction,
  }) async {
    await PasswordlessLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.nonce.equals(nonce),
      transaction: transaction,
    );
  }

  @override
  Future<UuidValue> createRequest(
    final Session session, {
    required final String nonce,
    required final UuidValue challengeId,
    required final Transaction transaction,
  }) async {
    final request = await PasswordlessLoginRequest.db.insertRow(
      session,
      PasswordlessLoginRequest(
        nonce: nonce,
        challengeId: challengeId,
      ),
      transaction: transaction,
    );
    return request.id!;
  }

  @override
  Future<PasswordlessLoginRequestData?> getRequestForVerification(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    final request = await PasswordlessLoginRequest.db.findById(
      session,
      requestId,
      transaction: transaction,
      include: PasswordlessLoginRequest.include(
        challenge: SecretChallenge.include(),
      ),
    );
    return request?._toStoreData();
  }

  @override
  Future<PasswordlessLoginRequestData?> getRequestForCompletion(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    final request = await PasswordlessLoginRequest.db.findById(
      session,
      requestId,
      transaction: transaction,
      include: PasswordlessLoginRequest.include(
        loginChallenge: SecretChallenge.include(),
      ),
    );
    return request?._toStoreData();
  }

  @override
  Future<bool> linkCompletionChallengeAtomically(
    final Session session, {
    required final UuidValue requestId,
    required final UuidValue completionChallengeId,
    required final Transaction? transaction,
  }) async {
    final updated = await PasswordlessLoginRequest.db.updateWhere(
      session,
      columnValues: (final t) => [
        t.loginChallengeId(completionChallengeId),
      ],
      where: (final t) =>
          t.id.equals(requestId) & t.loginChallengeId.equals(null),
      transaction: transaction,
    );
    return updated.isNotEmpty;
  }

  @override
  Future<bool> deleteById(
    final Session session, {
    required final UuidValue requestId,
    final Transaction? transaction,
  }) async {
    final deleted = await PasswordlessLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(requestId),
      transaction: transaction,
    );
    return deleted.isNotEmpty;
  }
}

extension on PasswordlessLoginRequest {
  PasswordlessLoginRequestData _toStoreData() {
    return PasswordlessLoginRequestData(
      id: id!,
      createdAt: createdAt,
      nonce: nonce,
      challenge: challenge,
      loginChallengeId: loginChallengeId,
      loginChallenge: loginChallenge,
    );
  }
}
