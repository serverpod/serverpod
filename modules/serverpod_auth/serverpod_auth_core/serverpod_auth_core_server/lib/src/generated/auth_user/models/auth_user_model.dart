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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/src/generated/protocol.dart'
    as _i8reeoob;

/// DTO for transferring authentication user information.
abstract class AuthUserModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AuthUserModel._({
    required this.id,
    required this.createdAt,
    required this.scopeNames,
    required this.blocked,
  });

  factory AuthUserModel({
    required _is.UuidValue id,
    required DateTime createdAt,
    required Set<String> scopeNames,
    required bool blocked,
  }) = _AuthUserModelImpl;

  factory AuthUserModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUserModel(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      scopeNames: _i8reeoob.Protocol().deserialize<Set<String>>(
        jsonSerialization['scopeNames'],
      ),
      blocked: _is.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
    );
  }

  _is.UuidValue id;

  /// The time when this user was created.
  DateTime createdAt;

  /// Set of scopes that this user can access.
  Set<String> scopeNames;

  /// If `true` the user will be blocked from signing in.
  bool blocked;

  /// Returns a shallow copy of this [AuthUserModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuthUserModel copyWith({
    _is.UuidValue? id,
    DateTime? createdAt,
    Set<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.AuthUserModel',
      'id': id.toJson(),
      'createdAt': createdAt.toJson(),
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.AuthUserModel',
      'id': id.toJson(),
      'createdAt': createdAt.toJson(),
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AuthUserModelImpl extends AuthUserModel {
  _AuthUserModelImpl({
    required _is.UuidValue id,
    required DateTime createdAt,
    required Set<String> scopeNames,
    required bool blocked,
  }) : super._(
         id: id,
         createdAt: createdAt,
         scopeNames: scopeNames,
         blocked: blocked,
       );

  /// Returns a shallow copy of this [AuthUserModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuthUserModel copyWith({
    _is.UuidValue? id,
    DateTime? createdAt,
    Set<String>? scopeNames,
    bool? blocked,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      blocked: blocked ?? this.blocked,
    );
  }
}
