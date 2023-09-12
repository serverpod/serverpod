/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

/// Provides a response to an authentication attempt.
abstract class AuthenticationResponse extends _i1.SerializableEntity {
  AuthenticationResponse._({
    required this.success,
    this.key,
    this.keyId,
    this.userInfo,
    this.failReason,
  });

  factory AuthenticationResponse({
    required bool success,
    String? key,
    int? keyId,
    _i2.UserInfo? userInfo,
    _i2.AuthenticationFailReason? failReason,
  }) = _AuthenticationResponseImpl;

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

  AuthenticationResponse copyWith({
    bool? success,
    String? key,
    int? keyId,
    _i2.UserInfo? userInfo,
    _i2.AuthenticationFailReason? failReason,
  });
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

  @override
  Map<String, dynamic> allToJson() {
    return {
      'success': success,
      'key': key,
      'keyId': keyId,
      'userInfo': userInfo,
      'failReason': failReason,
    };
  }
}

class _Undefined {}

class _AuthenticationResponseImpl extends AuthenticationResponse {
  _AuthenticationResponseImpl({
    required bool success,
    String? key,
    int? keyId,
    _i2.UserInfo? userInfo,
    _i2.AuthenticationFailReason? failReason,
  }) : super._(
          success: success,
          key: key,
          keyId: keyId,
          userInfo: userInfo,
          failReason: failReason,
        );

  @override
  AuthenticationResponse copyWith({
    bool? success,
    Object? key = _Undefined,
    Object? keyId = _Undefined,
    Object? userInfo = _Undefined,
    Object? failReason = _Undefined,
  }) {
    return AuthenticationResponse(
      success: success ?? this.success,
      key: key is! String? ? this.key : key,
      keyId: keyId is! int? ? this.keyId : keyId,
      userInfo:
          userInfo is! _i2.UserInfo? ? this.userInfo?.copyWith() : userInfo,
      failReason: failReason is! _i2.AuthenticationFailReason?
          ? this.failReason
          : failReason,
    );
  }
}
