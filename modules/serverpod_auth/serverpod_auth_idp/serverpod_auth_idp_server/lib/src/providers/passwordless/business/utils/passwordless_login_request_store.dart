import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../passwordless_idp_server_exceptions.dart';

/// Snapshot of a passwordless login request used by business logic.
class PasswordlessLoginRequestData<TNonce> {
  /// Request identifier.
  final UuidValue id;

  /// Request creation timestamp.
  final DateTime createdAt;

  /// Opaque user handle nonce.
  final TNonce nonce;

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
abstract interface class PasswordlessLoginRequestStore<TNonce> {
  /// Deletes requests for [nonce].
  Future<void> deleteByNonce(
    final Session session, {
    required final TNonce nonce,
    required final Transaction transaction,
  });

  /// Creates a new request row.
  Future<UuidValue> createRequest(
    final Session session, {
    required final TNonce nonce,
    required final UuidValue challengeId,
    required final Transaction transaction,
  });

  /// Loads request data for verification step.
  Future<PasswordlessLoginRequestData<TNonce>?> getRequestForVerification(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  });

  /// Loads request data for completion step.
  Future<PasswordlessLoginRequestData<TNonce>?> getRequestForCompletion(
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
class GenericPasswordlessLoginRequestStore<TNonce>
    implements PasswordlessLoginRequestStore<TNonce> {
  /// Domain segment used in namespaced nonces.
  final String domain;

  /// Source segment used in namespaced nonces.
  final String source;

  /// Encodes nonce values to stable strings before DB persistence.
  final String Function(TNonce nonce) encodeNonce;

  /// Decodes nonce values from stable strings read from DB.
  final TNonce Function(String nonce) decodeNonce;

  /// Creates a generic DB-backed store.
  GenericPasswordlessLoginRequestStore({
    required final String domain,
    required final String source,
    required this.encodeNonce,
    required this.decodeNonce,
  }) : domain = _validateNamespaceSegment(
         name: 'domain',
         value: domain,
       ),
       source = _validateNamespaceSegment(
         name: 'source',
         value: source,
       );

  @override
  Future<void> deleteByNonce(
    final Session session, {
    required final TNonce nonce,
    required final Transaction transaction,
  }) async {
    await GenericPasswordlessLoginRequest.db.deleteWhere(
      session,
      where: (final t) => t.nonce.equals(_toNamespacedNonce(nonce)),
      transaction: transaction,
    );
  }

  @override
  Future<UuidValue> createRequest(
    final Session session, {
    required final TNonce nonce,
    required final UuidValue challengeId,
    required final Transaction transaction,
  }) async {
    final request = await GenericPasswordlessLoginRequest.db.insertRow(
      session,
      GenericPasswordlessLoginRequest(
        nonce: _toNamespacedNonce(nonce),
        challengeId: challengeId,
      ),
      transaction: transaction,
    );
    return request.id!;
  }

  @override
  Future<PasswordlessLoginRequestData<TNonce>?> getRequestForVerification(
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
    return request?._toStoreData(store: this);
  }

  @override
  Future<PasswordlessLoginRequestData<TNonce>?> getRequestForCompletion(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    final request = await GenericPasswordlessLoginRequest.db.findById(
      session,
      requestId,
      transaction: transaction,
      include: GenericPasswordlessLoginRequest.include(
        loginChallenge: SecretChallenge.include(),
      ),
    );
    return request?._toStoreData(store: this);
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

  String _toNamespacedNonce(final TNonce nonce) {
    final rawEncodedNonce = encodeNonce(nonce);
    if (rawEncodedNonce.isEmpty) {
      throw PasswordlessLoginInvalidException();
    }
    final encodedNonce = base64UrlEncode(utf8.encode(rawEncodedNonce));
    return '$domain::$source::$encodedNonce';
  }

  TNonce _fromNamespacedNonce(final String namespacedNonce) {
    final parts = namespacedNonce.split('::');
    if (parts.length != 3) {
      throw PasswordlessLoginInvalidException();
    }
    if (parts[0] != domain || parts[1] != source || parts[2].isEmpty) {
      throw PasswordlessLoginInvalidException();
    }

    try {
      final decodedNonce = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[2])),
      );
      if (decodedNonce.isEmpty) {
        throw PasswordlessLoginInvalidException();
      }
      return decodeNonce(decodedNonce);
    } catch (_) {
      throw PasswordlessLoginInvalidException();
    }
  }

  static String _validateNamespaceSegment({
    required final String name,
    required final String value,
  }) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(value, name, 'must not be empty');
    }
    if (normalized.contains('::')) {
      throw ArgumentError.value(value, name, 'must not contain "::"');
    }
    return normalized;
  }
}

extension on GenericPasswordlessLoginRequest {
  PasswordlessLoginRequestData<TNonce> _toStoreData<TNonce>({
    required final GenericPasswordlessLoginRequestStore<TNonce> store,
  }) {
    return PasswordlessLoginRequestData(
      id: id!,
      createdAt: createdAt,
      nonce: store._fromNamespacedNonce(nonce),
      challenge: challenge,
      loginChallengeId: loginChallengeId,
      loginChallenge: loginChallenge,
    );
  }
}
