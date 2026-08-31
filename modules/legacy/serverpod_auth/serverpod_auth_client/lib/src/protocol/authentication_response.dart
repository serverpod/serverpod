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
import 'package:serverpod_auth_client/src/protocol/protocol.dart' as _i44s17dh;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'authentication_fail_reason.dart' as _ika0ufek;
import 'user_info.dart' as _iliwsvmu;

/// Provides a response to an authentication attempt.
abstract class AuthenticationResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _iliwsvmu.UserInfo? userInfo,
    _ika0ufek.AuthenticationFailReason? failReason,
  }) = _AuthenticationResponseImpl;

  factory AuthenticationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AuthenticationResponse(
      success: _isc.BoolJsonExtension.fromJson(jsonSerialization['success']),
      key: jsonSerialization['key'] as String?,
      keyId: jsonSerialization['keyId'] as int?,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i44s17dh.Protocol().deserialize<_iliwsvmu.UserInfo>(
              jsonSerialization['userInfo'],
            ),
      failReason: jsonSerialization['failReason'] == null
          ? null
          : _ika0ufek.AuthenticationFailReason.fromJson(
              (jsonSerialization['failReason'] as int),
            ),
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
  _iliwsvmu.UserInfo? userInfo;

  /// Reason for a failed authentication attempt, only set if the authentication
  /// failed.
  _ika0ufek.AuthenticationFailReason? failReason;

  /// Returns a shallow copy of this [AuthenticationResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuthenticationResponse copyWith({
    bool? success,
    String? key,
    int? keyId,
    _iliwsvmu.UserInfo? userInfo,
    _ika0ufek.AuthenticationFailReason? failReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth.AuthenticationResponse',
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
      '__className__': 'serverpod_auth.AuthenticationResponse',
      'success': success,
      if (key != null) 'key': key,
      if (keyId != null) 'keyId': keyId,
      if (userInfo != null) 'userInfo': userInfo?.toJsonForProtocol(),
      if (failReason != null) 'failReason': failReason?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthenticationResponseImpl extends AuthenticationResponse {
  _AuthenticationResponseImpl({
    required bool success,
    String? key,
    int? keyId,
    _iliwsvmu.UserInfo? userInfo,
    _ika0ufek.AuthenticationFailReason? failReason,
  }) : super._(
         success: success,
         key: key,
         keyId: keyId,
         userInfo: userInfo,
         failReason: failReason,
       );

  /// Returns a shallow copy of this [AuthenticationResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      userInfo: userInfo is _iliwsvmu.UserInfo?
          ? userInfo
          : this.userInfo?.copyWith(),
      failReason: failReason is _ika0ufek.AuthenticationFailReason?
          ? failReason
          : this.failReason,
    );
  }
}
