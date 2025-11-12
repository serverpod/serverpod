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

abstract class AuthUserModel implements _i1.SerializableModel {
  AuthUserModel._({
    required this.id,
    required this.createdAt,
    required this.scopeNames,
    required this.blocked,
  });

  factory AuthUserModel({
    required _i1.UuidValue id,
    required DateTime createdAt,
    required Set<String> scopeNames,
    required bool blocked,
  }) = _AuthUserModelImpl;

  factory AuthUserModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUserModel(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      scopeNames: _i1.SetJsonExtension.fromJson(
        (jsonSerialization['scopeNames'] as List),
        itemFromJson: (e) => e as String,
      )!,
      blocked: jsonSerialization['blocked'] as bool,
    );
  }

  _i1.UuidValue id;

  /// The time when this user was created.
  DateTime createdAt;

  /// Set of scopes that this user can access.
  Set<String> scopeNames;

  /// If `true` the user will be blocked from signing in.
  bool blocked;

  /// Returns a shallow copy of this [AuthUserModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthUserModel copyWith({
    _i1.UuidValue? id,
    DateTime? createdAt,
    Set<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
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

class _AuthUserModelImpl extends AuthUserModel {
  _AuthUserModelImpl({
    required _i1.UuidValue id,
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
  @_i1.useResult
  @override
  AuthUserModel copyWith({
    _i1.UuidValue? id,
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
