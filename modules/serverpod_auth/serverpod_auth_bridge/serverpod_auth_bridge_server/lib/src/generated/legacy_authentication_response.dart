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
import 'legacy_user_info.dart' as _i2;
import 'legacy_authentication_fail_reason.dart' as _i3;
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart'
    as _i4;

abstract class LegacyAuthenticationResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  LegacyAuthenticationResponse._({
    required this.success,
    this.key,
    this.keyId,
    this.userInfo,
    this.failReason,
  });

  factory LegacyAuthenticationResponse({
    required bool success,
    String? key,
    int? keyId,
    _i2.LegacyUserInfo? userInfo,
    _i3.LegacyAuthenticationFailReason? failReason,
  }) = _LegacyAuthenticationResponseImpl;

  factory LegacyAuthenticationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LegacyAuthenticationResponse(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      key: jsonSerialization['key'] as String?,
      keyId: jsonSerialization['keyId'] as int?,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.LegacyUserInfo>(
              jsonSerialization['userInfo'],
            ),
      failReason: jsonSerialization['failReason'] == null
          ? null
          : _i3.LegacyAuthenticationFailReason.fromJson(
              (jsonSerialization['failReason'] as int),
            ),
    );
  }

  bool success;

  String? key;

  int? keyId;

  _i2.LegacyUserInfo? userInfo;

  _i3.LegacyAuthenticationFailReason? failReason;

  /// Returns a shallow copy of this [LegacyAuthenticationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegacyAuthenticationResponse copyWith({
    bool? success,
    String? key,
    int? keyId,
    _i2.LegacyUserInfo? userInfo,
    _i3.LegacyAuthenticationFailReason? failReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_bridge.LegacyAuthenticationResponse',
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
      '__className__': 'serverpod_auth_bridge.LegacyAuthenticationResponse',
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

class _LegacyAuthenticationResponseImpl extends LegacyAuthenticationResponse {
  _LegacyAuthenticationResponseImpl({
    required bool success,
    String? key,
    int? keyId,
    _i2.LegacyUserInfo? userInfo,
    _i3.LegacyAuthenticationFailReason? failReason,
  }) : super._(
         success: success,
         key: key,
         keyId: keyId,
         userInfo: userInfo,
         failReason: failReason,
       );

  /// Returns a shallow copy of this [LegacyAuthenticationResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegacyAuthenticationResponse copyWith({
    bool? success,
    Object? key = _Undefined,
    Object? keyId = _Undefined,
    Object? userInfo = _Undefined,
    Object? failReason = _Undefined,
  }) {
    return LegacyAuthenticationResponse(
      success: success ?? this.success,
      key: key is String? ? key : this.key,
      keyId: keyId is int? ? keyId : this.keyId,
      userInfo: userInfo is _i2.LegacyUserInfo?
          ? userInfo
          : this.userInfo?.copyWith(),
      failReason: failReason is _i3.LegacyAuthenticationFailReason?
          ? failReason
          : this.failReason,
    );
  }
}
