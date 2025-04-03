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

abstract class AuthUser implements _i1.SerializableModel {
  AuthUser._({
    this.id,
    required this.created,
    this.scopeNames,
    required this.blocked,
  });

  factory AuthUser({
    int? id,
    required DateTime created,
    Set<String>? scopeNames,
    required bool blocked,
  }) = _AuthUserImpl;

  factory AuthUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUser(
      id: jsonSerialization['id'] as int?,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      scopeNames: jsonSerialization['scopeNames'] == null
          ? null
          : _i1.SetJsonExtension.fromJson(
              (jsonSerialization['scopeNames'] as List),
              itemFromJson: (e) => e as String),
      blocked: jsonSerialization['blocked'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The time when this user was created.
  DateTime created;

  /// Set of scopes that this user can access.
  Set<String>? scopeNames;

  /// True if the user is blocked from signing in.
  bool blocked;

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthUser copyWith({
    int? id,
    DateTime? created,
    Set<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'created': created.toJson(),
      if (scopeNames != null) 'scopeNames': scopeNames?.toJson(),
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
    int? id,
    required DateTime created,
    Set<String>? scopeNames,
    required bool blocked,
  }) : super._(
          id: id,
          created: created,
          scopeNames: scopeNames,
          blocked: blocked,
        );

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthUser copyWith({
    Object? id = _Undefined,
    DateTime? created,
    Object? scopeNames = _Undefined,
    bool? blocked,
  }) {
    return AuthUser(
      id: id is int? ? id : this.id,
      created: created ?? this.created,
      scopeNames: scopeNames is Set<String>?
          ? scopeNames
          : this.scopeNames?.map((e0) => e0).toSet(),
      blocked: blocked ?? this.blocked,
    );
  }
}
