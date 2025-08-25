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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../common/models/auth_strategy.dart' as _i2;

abstract class AuthSuccess implements _i1.SerializableModel {
  AuthSuccess._({
    required this.authStrategy,
    required this.token,
    this.refreshToken,
    required this.authUserId,
    required this.scopeNames,
  });

  factory AuthSuccess({
    required _i2.AuthStrategy authStrategy,
    required String token,
    String? refreshToken,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
  }) = _AuthSuccessImpl;

  factory AuthSuccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthSuccess(
      authStrategy: _i2.AuthStrategy.fromJson(
          (jsonSerialization['authStrategy'] as String)),
      token: jsonSerialization['token'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String?,
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      scopeNames: _i1.SetJsonExtension.fromJson(
          (jsonSerialization['scopeNames'] as List),
          itemFromJson: (e) => e as String)!,
    );
  }

  /// The authentication strategy used for this session.
  _i2.AuthStrategy authStrategy;

  /// The authentication token, in the case of JWT this is the access token.
  String token;

  /// Optional refresh token.
  String? refreshToken;

  /// The [AuthUser] this session belongs to.
  _i1.UuidValue authUserId;

  /// The scopes this session provides access to.
  ///
  /// These are not connected to the [authUser], and can for example represent a subset of their permissions.
  Set<String> scopeNames;

  /// Returns a shallow copy of this [AuthSuccess]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthSuccess copyWith({
    _i2.AuthStrategy? authStrategy,
    String? token,
    String? refreshToken,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'authStrategy': authStrategy.toJson(),
      'token': token,
      if (refreshToken != null) 'refreshToken': refreshToken,
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthSuccessImpl extends AuthSuccess {
  _AuthSuccessImpl({
    required _i2.AuthStrategy authStrategy,
    required String token,
    String? refreshToken,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
  }) : super._(
          authStrategy: authStrategy,
          token: token,
          refreshToken: refreshToken,
          authUserId: authUserId,
          scopeNames: scopeNames,
        );

  /// Returns a shallow copy of this [AuthSuccess]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthSuccess copyWith({
    _i2.AuthStrategy? authStrategy,
    String? token,
    Object? refreshToken = _Undefined,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
  }) {
    return AuthSuccess(
      authStrategy: authStrategy ?? this.authStrategy,
      token: token ?? this.token,
      refreshToken: refreshToken is String? ? refreshToken : this.refreshToken,
      authUserId: authUserId ?? this.authUserId,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
    );
  }
}
