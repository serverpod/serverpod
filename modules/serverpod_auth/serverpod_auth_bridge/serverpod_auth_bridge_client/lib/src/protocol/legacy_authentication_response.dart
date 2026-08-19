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
import 'package:serverpod_auth_bridge_client/src/protocol/protocol.dart'
    as _igc3veom;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'legacy_authentication_fail_reason.dart' as _ijl7odiy;
import 'legacy_user_info.dart' as _izh8x5we;

/// Response payload for legacy authentication methods.
abstract class LegacyAuthenticationResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _izh8x5we.LegacyUserInfo? userInfo,
    _ijl7odiy.LegacyAuthenticationFailReason? failReason,
  }) = _LegacyAuthenticationResponseImpl;

  factory LegacyAuthenticationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LegacyAuthenticationResponse(
      success: _isc.BoolJsonExtension.fromJson(jsonSerialization['success']),
      key: jsonSerialization['key'] as String?,
      keyId: jsonSerialization['keyId'] as int?,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _igc3veom.Protocol().deserialize<_izh8x5we.LegacyUserInfo>(
              jsonSerialization['userInfo'],
            ),
      failReason: jsonSerialization['failReason'] == null
          ? null
          : _ijl7odiy.LegacyAuthenticationFailReason.fromJson(
              (jsonSerialization['failReason'] as int),
            ),
    );
  }

  /// True when authentication succeeded.
  bool success;

  /// Session secret for successful sign-in.
  String? key;

  /// Session id for successful sign-in.
  int? keyId;

  /// Authenticated user info on success.
  _izh8x5we.LegacyUserInfo? userInfo;

  /// Failure reason when authentication fails.
  _ijl7odiy.LegacyAuthenticationFailReason? failReason;

  /// Returns a shallow copy of this [LegacyAuthenticationResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LegacyAuthenticationResponse copyWith({
    bool? success,
    String? key,
    int? keyId,
    _izh8x5we.LegacyUserInfo? userInfo,
    _ijl7odiy.LegacyAuthenticationFailReason? failReason,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegacyAuthenticationResponseImpl extends LegacyAuthenticationResponse {
  _LegacyAuthenticationResponseImpl({
    required bool success,
    String? key,
    int? keyId,
    _izh8x5we.LegacyUserInfo? userInfo,
    _ijl7odiy.LegacyAuthenticationFailReason? failReason,
  }) : super._(
         success: success,
         key: key,
         keyId: keyId,
         userInfo: userInfo,
         failReason: failReason,
       );

  /// Returns a shallow copy of this [LegacyAuthenticationResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      userInfo: userInfo is _izh8x5we.LegacyUserInfo?
          ? userInfo
          : this.userInfo?.copyWith(),
      failReason: failReason is _ijl7odiy.LegacyAuthenticationFailReason?
          ? failReason
          : this.failReason,
    );
  }
}
