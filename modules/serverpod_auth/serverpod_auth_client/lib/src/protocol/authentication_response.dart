/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

/// Provides a response to an authentication attempt.
class AuthenticationResponse extends _i1.SerializableEntity {
  AuthenticationResponse({
    required this.success,
    this.key,
    this.keyId,
    this.userInfo,
    this.failReason,
  });

  factory AuthenticationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return AuthenticationResponse(
      success:
          serializationManager.deserialize<bool>(jsonSerialization['success']),
      key: serializationManager.deserialize<String?>(jsonSerialization['key']),
      keyId: serializationManager.deserialize<int?>(jsonSerialization['keyId']),
      userInfo: serializationManager
          .deserialize<_i2.UserInfo?>(jsonSerialization['userInfo']),
      failReason:
          serializationManager.deserialize<_i2.AuthenticationFailReason?>(
              jsonSerialization['failReason']),
    );
  }

  /// True if the authentication was successful.
  bool success;

  /// The key associated with a successful authentication.
  String? key;

  /// The id of the key associated with a successful authentication.
  int? keyId;

  /// The [UserInfo] of the authenticated user, only set if the authentication
  /// was successful.
  _i2.UserInfo? userInfo;

  /// Reason for a failed authentication attempt, only set if the authentication
  /// failed.
  _i2.AuthenticationFailReason? failReason;

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'key': key,
      'keyId': keyId,
      'userInfo': userInfo,
      'failReason': failReason,
    };
  }
}
