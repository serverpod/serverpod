import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../generated/protocol.dart';
import 'phone_id_store.dart';

/// Hash-only phone ID storage implementation.
///
/// This implementation stores only a hash of the phone number, providing
/// maximum privacy as the original phone number cannot be recovered.
///
/// Use this when you don't need to retrieve the phone number later.
class PhoneIdHashStore extends PhoneIdStore {
  /// The pepper used for hashing phone numbers.
  final String pepper;

  /// Creates a new [PhoneIdHashStore] with the given pepper.
  PhoneIdHashStore({required this.pepper});

  /// Creates a [PhoneIdHashStore] from passwords configuration.
  factory PhoneIdHashStore.fromPasswords(Serverpod serverpod) {
    final pepper = serverpod.getPassword('phoneHashPepper');
    if (pepper == null || pepper.isEmpty) {
      throw StateError('phoneHashPepper must be configured in passwords.');
    }
    return PhoneIdHashStore(pepper: pepper);
  }

  @override
  String hashPhone(String phone) {
    final normalized = normalizePhone(phone);
    final hmac = Hmac(sha256, utf8.encode(pepper));
    return hmac.convert(utf8.encode(normalized)).toString();
  }

  @override
  Future<UuidValue?> findAuthUserIdByPhoneHash(
    Session session, {
    required String phoneHash,
    Transaction? transaction,
  }) async {
    final row = await SmsPhoneIdHash.db.findFirstRow(
      session,
      where: (t) => t.phoneHash.equals(phoneHash),
      transaction: transaction,
    );
    return row?.authUserId;
  }

  @override
  Future<bool> isPhoneBoundForUser(
    Session session, {
    required UuidValue authUserId,
    Transaction? transaction,
  }) async {
    final count = await SmsPhoneIdHash.db.count(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    return count > 0;
  }

  @override
  Future<void> bindPhone(
    Session session, {
    required UuidValue authUserId,
    required String phone,
    required bool allowRebind,
    Transaction? transaction,
  }) async {
    final normalized = normalizePhone(phone);
    final phoneHash = hashPhone(normalized);

    // Check if phone is already bound to another user
    final existingByHash = await SmsPhoneIdHash.db.findFirstRow(
      session,
      where: (t) => t.phoneHash.equals(phoneHash),
      transaction: transaction,
    );
    if (existingByHash != null && existingByHash.authUserId != authUserId) {
      throw const PhoneAlreadyBoundException();
    }

    // Check if user already has a phone bound
    final existingByUser = await SmsPhoneIdHash.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    if (existingByUser != null) {
      if (existingByUser.phoneHash == phoneHash) return;
      if (!allowRebind) throw const PhoneRebindNotAllowedException();
      await SmsPhoneIdHash.db.updateRow(
        session,
        existingByUser.copyWith(phoneHash: phoneHash),
        transaction: transaction,
      );
      return;
    }

    await SmsPhoneIdHash.db.insertRow(
      session,
      SmsPhoneIdHash(authUserId: authUserId, phoneHash: phoneHash),
      transaction: transaction,
    );
  }
}
