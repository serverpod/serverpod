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
import 'package:serverpod_auth_core_client/src/protocol/protocol.dart' as _i2;

/// Core database entity representing a user in the authentication system.
///
/// This class is meant to be used only to interact with the database. To transfer
/// user data, use the [AuthUserModel] DTO.
abstract class AuthUser implements _i1.SerializableModel {
  AuthUser._({
    this.id,
    DateTime? createdAt,
    required this.scopeNames,
    bool? blocked,
  }) : createdAt = createdAt ?? DateTime.now(),
       blocked = blocked ?? false;

  factory AuthUser({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required Set<String> scopeNames,
    bool? blocked,
  }) = _AuthUserImpl;

  factory AuthUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUser(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      scopeNames: _i2.Protocol().deserialize<Set<String>>(
        jsonSerialization['scopeNames'],
      ),
      blocked: jsonSerialization['blocked'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  /// The time when this user was created.
  DateTime createdAt;

  /// Set of scopes that this user can access.
  Set<String> scopeNames;

  /// If `true` the user will be blocked from signing in.
  bool blocked;

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthUser copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    Set<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.AuthUser',
      if (id != null) 'id': id?.toJson(),
      'createdAt': createdAt.toJson(),
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthUserImpl extends AuthUser {
  _AuthUserImpl({
    _i1.UuidValue? id,
    DateTime? createdAt,
    required Set<String> scopeNames,
    bool? blocked,
  }) : super._(
         id: id,
         createdAt: createdAt,
         scopeNames: scopeNames,
         blocked: blocked,
       );

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthUser copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    Set<String>? scopeNames,
    bool? blocked,
  }) {
    return AuthUser(
      id: id is _i1.UuidValue? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      blocked: blocked ?? this.blocked,
    );
  }
}
