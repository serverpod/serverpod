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

abstract class AuthSuccess
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AuthSuccess._({
    required this.authStrategy,
    required this.token,
    this.tokenExpiresAt,
    this.refreshToken,
    required this.authUserId,
    required this.scopeNames,
  });

  factory AuthSuccess({
    required String authStrategy,
    required String token,
    DateTime? tokenExpiresAt,
    String? refreshToken,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
  }) = _AuthSuccessImpl;

  factory AuthSuccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthSuccess(
      authStrategy: jsonSerialization['authStrategy'] as String,
      token: jsonSerialization['token'] as String,
      tokenExpiresAt: jsonSerialization['tokenExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['tokenExpiresAt'],
            ),
      refreshToken: jsonSerialization['refreshToken'] as String?,
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      scopeNames: _i1.SetJsonExtension.fromJson(
        (jsonSerialization['scopeNames'] as List),
        itemFromJson: (e) => e as String,
      )!,
    );
  }

  /// The authentication strategy used for this session.
  ///
  /// Stores the [AuthStrategy] used to generate this authentication response.
  /// Stored as string to allow users to extend with custom authentication methods.
  String authStrategy;

  /// The authentication token, in the case of JWT this is the access token.
  String token;

  /// The token expiration date in UTC, if any.
  DateTime? tokenExpiresAt;

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
    String? authStrategy,
    String? token,
    DateTime? tokenExpiresAt,
    String? refreshToken,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'authStrategy': authStrategy,
      'token': token,
      if (tokenExpiresAt != null) 'tokenExpiresAt': tokenExpiresAt?.toJson(),
      if (refreshToken != null) 'refreshToken': refreshToken,
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'authStrategy': authStrategy,
      'token': token,
      if (tokenExpiresAt != null) 'tokenExpiresAt': tokenExpiresAt?.toJson(),
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
    required String authStrategy,
    required String token,
    DateTime? tokenExpiresAt,
    String? refreshToken,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
  }) : super._(
         authStrategy: authStrategy,
         token: token,
         tokenExpiresAt: tokenExpiresAt,
         refreshToken: refreshToken,
         authUserId: authUserId,
         scopeNames: scopeNames,
       );

  /// Returns a shallow copy of this [AuthSuccess]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthSuccess copyWith({
    String? authStrategy,
    String? token,
    Object? tokenExpiresAt = _Undefined,
    Object? refreshToken = _Undefined,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
  }) {
    return AuthSuccess(
      authStrategy: authStrategy ?? this.authStrategy,
      token: token ?? this.token,
      tokenExpiresAt: tokenExpiresAt is DateTime?
          ? tokenExpiresAt
          : this.tokenExpiresAt,
      refreshToken: refreshToken is String? ? refreshToken : this.refreshToken,
      authUserId: authUserId ?? this.authUserId,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
    );
  }
}
