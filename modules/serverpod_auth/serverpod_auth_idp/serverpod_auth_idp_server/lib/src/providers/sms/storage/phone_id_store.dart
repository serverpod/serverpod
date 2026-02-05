import 'package:serverpod/serverpod.dart';

import '../util/phone_normalizer.dart';

/// Exception thrown when trying to bind a phone that is already bound to another user.
class PhoneAlreadyBoundException implements Exception {
  /// The error message.
  final String message;

  /// Creates a new [PhoneAlreadyBoundException].
  const PhoneAlreadyBoundException([this.message = 'Phone already bound']);

  @override
  String toString() => 'PhoneAlreadyBoundException: $message';
}

/// Exception thrown when trying to rebind a phone but rebind is not allowed.
class PhoneRebindNotAllowedException implements Exception {
  /// The error message.
  final String message;

  /// Creates a new [PhoneRebindNotAllowedException].
  const PhoneRebindNotAllowedException([this.message = 'Phone rebind disabled']);

  @override
  String toString() => 'PhoneRebindNotAllowedException: $message';
}

/// Abstract interface for phone ID storage.
///
/// Implementations can choose to store phone numbers as hashes only (for privacy)
/// or as encrypted values (for retrieval).
abstract class PhoneIdStore {
  /// Normalizes a phone number by removing formatting characters.
  String normalizePhone(String phone) => normalizePhoneNumber(phone);

  /// Returns a deterministic hash of the phone number for lookup purposes.
  String hashPhone(String phone);

  /// Finds the auth user ID associated with the given phone hash.
  Future<UuidValue?> findAuthUserIdByPhoneHash(
    Session session, {
    required String phoneHash,
    Transaction? transaction,
  });

  /// Finds the auth user ID associated with the given phone number.
  Future<UuidValue?> findAuthUserIdByPhone(
    Session session, {
    required String phone,
    Transaction? transaction,
  }) async {
    final normalized = normalizePhone(phone);
    return findAuthUserIdByPhoneHash(
      session,
      phoneHash: hashPhone(normalized),
      transaction: transaction,
    );
  }

  /// Returns true if the user has a phone number bound.
  Future<bool> isPhoneBoundForUser(
    Session session, {
    required UuidValue authUserId,
    Transaction? transaction,
  });

  /// Binds a phone number to a user.
  ///
  /// Throws [PhoneAlreadyBoundException] if the phone is already bound to another user.
  /// Throws [PhoneRebindNotAllowedException] if the user already has a phone and rebind is not allowed.
  Future<void> bindPhone(
    Session session, {
    required UuidValue authUserId,
    required String phone,
    required bool allowRebind,
    Transaction? transaction,
  });

  /// Returns the phone number for a user, if available.
  ///
  /// This is only supported by encrypted storage implementations.
  /// Hash-only implementations will always return null.
  Future<String?> getPhone(
    Session session, {
    required UuidValue authUserId,
    Transaction? transaction,
  }) async {
    return null;
  }
}
