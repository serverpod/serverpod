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

abstract class RefreshTokenExpiredException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  RefreshTokenExpiredException._({
    required this.authUserId,
    required this.refreshTokenId,
  });

  factory RefreshTokenExpiredException({
    required _i1.UuidValue authUserId,
    required _i1.UuidValue refreshTokenId,
  }) = _RefreshTokenExpiredExceptionImpl;

  factory RefreshTokenExpiredException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RefreshTokenExpiredException(
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      refreshTokenId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['refreshTokenId']),
    );
  }

  _i1.UuidValue authUserId;

  _i1.UuidValue refreshTokenId;

  /// Returns a shallow copy of this [RefreshTokenExpiredException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefreshTokenExpiredException copyWith({
    _i1.UuidValue? authUserId,
    _i1.UuidValue? refreshTokenId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'authUserId': authUserId.toJson(),
      'refreshTokenId': refreshTokenId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'authUserId': authUserId.toJson(),
      'refreshTokenId': refreshTokenId.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RefreshTokenExpiredExceptionImpl extends RefreshTokenExpiredException {
  _RefreshTokenExpiredExceptionImpl({
    required _i1.UuidValue authUserId,
    required _i1.UuidValue refreshTokenId,
  }) : super._(
          authUserId: authUserId,
          refreshTokenId: refreshTokenId,
        );

  /// Returns a shallow copy of this [RefreshTokenExpiredException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefreshTokenExpiredException copyWith({
    _i1.UuidValue? authUserId,
    _i1.UuidValue? refreshTokenId,
  }) {
    return RefreshTokenExpiredException(
      authUserId: authUserId ?? this.authUserId,
      refreshTokenId: refreshTokenId ?? this.refreshTokenId,
    );
  }
}
