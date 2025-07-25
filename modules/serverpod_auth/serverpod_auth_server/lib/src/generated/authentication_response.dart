/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'user_info.dart' as _i2;
import 'authentication_fail_reason.dart' as _i3;

/// Provides a response to an authentication attempt.
abstract class AuthenticationResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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
    _i3.AuthenticationFailReason? failReason,
  }) = _AuthenticationResponseImpl;

  factory AuthenticationResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return AuthenticationResponse(
      success: jsonSerialization['success'] as bool,
      key: jsonSerialization['key'] as String?,
      keyId: jsonSerialization['keyId'] as int?,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
      failReason: jsonSerialization['failReason'] == null
          ? null
          : _i3.AuthenticationFailReason.fromJson(
              (jsonSerialization['failReason'] as int)),
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
  _i3.AuthenticationFailReason? failReason;

  /// Returns a shallow copy of this [AuthenticationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthenticationResponse copyWith({
    bool? success,
    String? key,
    int? keyId,
    _i2.UserInfo? userInfo,
    _i3.AuthenticationFailReason? failReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (key != null) 'key': key,
      if (keyId != null) 'keyId': keyId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      if (failReason != null) 'failReason': failReason?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'success': success,
      if (key != null) 'key': key,
      if (keyId != null) 'keyId': keyId,
      if (userInfo != null) 'userInfo': userInfo?.toJsonForProtocol(),
      if (failReason != null) 'failReason': failReason?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthenticationResponseImpl extends AuthenticationResponse {
  _AuthenticationResponseImpl({
    required bool success,
    String? key,
    int? keyId,
    _i2.UserInfo? userInfo,
    _i3.AuthenticationFailReason? failReason,
  }) : super._(
          success: success,
          key: key,
          keyId: keyId,
          userInfo: userInfo,
          failReason: failReason,
        );

  /// Returns a shallow copy of this [AuthenticationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      key: key is String? ? key : this.key,
      keyId: keyId is int? ? keyId : this.keyId,
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
      failReason: failReason is _i3.AuthenticationFailReason?
          ? failReason
          : this.failReason,
    );
  }
}
