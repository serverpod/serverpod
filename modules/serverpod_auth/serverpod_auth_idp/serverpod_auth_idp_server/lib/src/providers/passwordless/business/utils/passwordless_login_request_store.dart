import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../passwordless_idp_server_exceptions.dart';

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

  /// Completion challenge id if already linked.
  final UuidValue? loginChallengeId;

  /// Completion challenge if loaded.
  final SecretChallenge? loginChallenge;

  /// Creates a [PasswordlessLoginRequestData].
  const PasswordlessLoginRequestData({
    required this.id,
    required this.createdAt,
    required this.serializedHandle,
    required this.challenge,
    required this.loginChallengeId,
    required this.loginChallenge,
  });
}

/// Storage contract for passwordless login requests.
abstract interface class PasswordlessLoginRequestStore {
  /// Deletes requests for [serializedHandle].
  Future<void> deleteByHandle(
    final Session session, {
    required final String serializedHandle,
    required final Transaction transaction,
  });

  /// Creates a new request row.
  Future<UuidValue> createRequest(
    final Session session, {
    required final String serializedHandle,
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

/// Generic DB-backed request store using [GenericPasswordlessLoginRequest].
class GenericPasswordlessLoginRequestStore
    implements PasswordlessLoginRequestStore {
  /// Optional source prefix to isolate requests that share the same table.
  final String? source;

  /// Creates a generic DB-backed store.
  const GenericPasswordlessLoginRequestStore({this.source});

  @override
  Future<void> deleteByHandle(
    final Session session, {
    required final String serializedHandle,
    required final Transaction transaction,
  }) async {
    await GenericPasswordlessLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.nonce.equals(_toStoredHandle(serializedHandle)),
      transaction: transaction,
    );
  }

  @override
  Future<UuidValue> createRequest(
    final Session session, {
    required final String serializedHandle,
    required final UuidValue challengeId,
    required final Transaction transaction,
  }) async {
    final request = await GenericPasswordlessLoginRequest.db.insertRow(
      session,
      GenericPasswordlessLoginRequest(
        nonce: _toStoredHandle(serializedHandle),
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
    return _loadRequest(
      session,
      requestId: requestId,
      transaction: transaction,
      challenge: SecretChallenge.include(),
    );
  }

  @override
  Future<PasswordlessLoginRequestData?> getRequestForCompletion(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    return _loadRequest(
      session,
      requestId: requestId,
      transaction: transaction,
      loginChallenge: SecretChallenge.include(),
    );
  }

  Future<PasswordlessLoginRequestData?> _loadRequest(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
    final SecretChallengeInclude? challenge,
    final SecretChallengeInclude? loginChallenge,
  }) async {
    final request = await GenericPasswordlessLoginRequest.db.findById(
      session,
      requestId,
      transaction: transaction,
      include: GenericPasswordlessLoginRequest.include(
        challenge: challenge,
        loginChallenge: loginChallenge,
      ),
    );
    return request?.toStoreData(store: this);
  }

  @override
  Future<bool> linkCompletionChallengeAtomically(
    final Session session, {
    required final UuidValue requestId,
    required final UuidValue completionChallengeId,
    required final Transaction? transaction,
  }) async {
    final updated = await GenericPasswordlessLoginRequest.db.updateWhere(
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
    final deleted = await GenericPasswordlessLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(requestId),
      transaction: transaction,
    );
    return deleted.isNotEmpty;
  }

  String _toStoredHandle(final String serializedHandle) {
    final source = this.source;
    if (source == null) return serializedHandle;
    return '$source::$serializedHandle';
  }

  String _fromStoredHandle(final String storedHandle) {
    final source = this.source;
    if (source == null) return storedHandle;

    final prefix = '$source::';
    if (!storedHandle.startsWith(prefix)) {
      throw PasswordlessLoginInvalidException();
    }
    return storedHandle.substring(prefix.length);
  }
}

extension on GenericPasswordlessLoginRequest {
  PasswordlessLoginRequestData toStoreData({
    required final GenericPasswordlessLoginRequestStore store,
  }) {
    return PasswordlessLoginRequestData(
      id: id!,
      createdAt: createdAt,
      serializedHandle: store._fromStoredHandle(nonce),
      challenge: challenge,
      loginChallengeId: loginChallengeId,
      loginChallenge: loginChallenge,
    );
  }
}
