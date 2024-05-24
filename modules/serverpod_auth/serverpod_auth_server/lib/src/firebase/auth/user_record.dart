import 'dart:convert';

import 'package:snapshot/snapshot.dart';

final _decoder = SnapshotDecoder()
  ..register<String, Map<String, dynamic>>(
    (v) => json.decode(v),
    format: 'json',
  )
  ..register<String, DateTime>(
      (v) => DateTime.fromMicrosecondsSinceEpoch(
          (num.parse(v) * 1000 * 1000).toInt()),
      format: RegExp('epoch'))
  ..register<String, DateTime>(
      (v) => DateTime.fromMicrosecondsSinceEpoch((num.parse(v) * 1000).toInt()),
      format: RegExp('epoch:millis'))
  ..seal();

/// Represents a user.
class UserRecord extends UnmodifiableSnapshotView {
  /// The user's uid.
  String get uid => get('localId');

  /// The user's primary email, if set.
  String? get email => get('email');

  /// Whether or not the user's primary email is verified.
  bool get emailVerified => get('emailVerified') ?? false;

  /// The user's display name.
  String? get displayName => get('displayName');

  /// The user's photo URL.
  Uri? get photoUrl => get('photoUrl');

  /// The user's primary phone number, if set.
  String? get phoneNumber => get('phoneNumber');

  /// Whether or not the user is disabled.
  bool get disabled => get('disabled') ?? false;

  /// The user's custom claims object if available, typically used to define
  /// user roles and propagated to an authenticated user's ID token.
  ///
  /// This is set via [Auth.setCustomUserClaims].
  Map<String, dynamic>? get customClaims =>
      get('customAttributes', format: 'json');

  /// The ID of the tenant the user belongs to, if available.
  String? get tenantId => get('tenantId');

  /// The date the user's tokens are valid after.
  ///
  /// This is updated every time the user's refresh token are revoked either
  /// from the [Auth.revokeRefreshTokens] API or from the Firebase Auth backend
  /// on big account changes (password resets, password or email updates, etc).
  DateTime? get tokensValidAfterTime => get('validSince', format: 'epoch');

  UserRecord.fromJson(Map<String, dynamic> map)
      : super.fromJson(map, decoder: _decoder);
}
