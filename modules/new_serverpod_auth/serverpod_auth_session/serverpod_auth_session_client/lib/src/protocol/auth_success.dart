/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AuthSuccess implements _i1.SerializableModel {
  AuthSuccess._({
    required this.sessionKey,
    required this.authUserId,
    required this.scopeNames,
  });

  factory AuthSuccess({
    required String sessionKey,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
  }) = _AuthSuccessImpl;

  factory AuthSuccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthSuccess(
      sessionKey: jsonSerialization['sessionKey'] as String,
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      scopeNames: _i1.SetJsonExtension.fromJson(
          (jsonSerialization['scopeNames'] as List),
          itemFromJson: (e) => e as String)!,
    );
  }

  String sessionKey;

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
    String? sessionKey,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionKey': sessionKey,
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AuthSuccessImpl extends AuthSuccess {
  _AuthSuccessImpl({
    required String sessionKey,
    required _i1.UuidValue authUserId,
    required Set<String> scopeNames,
  }) : super._(
          sessionKey: sessionKey,
          authUserId: authUserId,
          scopeNames: scopeNames,
        );

  /// Returns a shallow copy of this [AuthSuccess]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthSuccess copyWith({
    String? sessionKey,
    _i1.UuidValue? authUserId,
    Set<String>? scopeNames,
  }) {
    return AuthSuccess(
      sessionKey: sessionKey ?? this.sessionKey,
      authUserId: authUserId ?? this.authUserId,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
    );
  }
}
