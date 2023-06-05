/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

/// Provides a response to an authentication attempt.
abstract class AuthenticationResponse extends _i1.SerializableEntity {
  const AuthenticationResponse._();

  const factory AuthenticationResponse({
    required bool success,
    String? key,
    int? keyId,
    _i2.UserInfo? userInfo,
    _i2.AuthenticationFailReason? failReason,
  }) = _AuthenticationResponse;

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

  AuthenticationResponse copyWith({
    bool? success,
    String? key,
    int? keyId,
    _i2.UserInfo? userInfo,
    _i2.AuthenticationFailReason? failReason,
  });

  /// True if the authentication was successful.
  bool get success;

  /// The key associated with a successful authentication.
  String? get key;

  /// The id of the key associated with a successful authentication.
  int? get keyId;

  /// The [UserInfo] of the authenticated user, only set if the authentication
  /// was successful.
  _i2.UserInfo? get userInfo;

  /// Reason for a failed authentication attempt, only set if the authentication
  /// failed.
  _i2.AuthenticationFailReason? get failReason;
}

class _Undefined {}

/// Provides a response to an authentication attempt.
class _AuthenticationResponse extends AuthenticationResponse {
  const _AuthenticationResponse({
    required this.success,
    this.key,
    this.keyId,
    this.userInfo,
    this.failReason,
  }) : super._();

  /// True if the authentication was successful.
  @override
  final bool success;

  /// The key associated with a successful authentication.
  @override
  final String? key;

  /// The id of the key associated with a successful authentication.
  @override
  final int? keyId;

  /// The [UserInfo] of the authenticated user, only set if the authentication
  /// was successful.
  @override
  final _i2.UserInfo? userInfo;

  /// Reason for a failed authentication attempt, only set if the authentication
  /// failed.
  @override
  final _i2.AuthenticationFailReason? failReason;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is AuthenticationResponse &&
            (identical(
                  other.success,
                  success,
                ) ||
                other.success == success) &&
            (identical(
                  other.key,
                  key,
                ) ||
                other.key == key) &&
            (identical(
                  other.keyId,
                  keyId,
                ) ||
                other.keyId == keyId) &&
            (identical(
                  other.userInfo,
                  userInfo,
                ) ||
                other.userInfo == userInfo) &&
            (identical(
                  other.failReason,
                  failReason,
                ) ||
                other.failReason == failReason));
  }

  @override
  int get hashCode => Object.hash(
        success,
        key,
        keyId,
        userInfo,
        failReason,
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
      key: key == _Undefined ? this.key : (key as String?),
      keyId: keyId == _Undefined ? this.keyId : (keyId as int?),
      userInfo:
          userInfo == _Undefined ? this.userInfo : (userInfo as _i2.UserInfo?),
      failReason: failReason == _Undefined
          ? this.failReason
          : (failReason as _i2.AuthenticationFailReason?),
    );
  }
}
