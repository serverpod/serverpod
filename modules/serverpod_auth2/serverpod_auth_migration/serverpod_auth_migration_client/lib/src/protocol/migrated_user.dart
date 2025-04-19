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

abstract class MigratedUser implements _i1.SerializableModel {
  MigratedUser._({
    this.id,
    required this.oldUserId,
    required this.newUserId,
  });

  factory MigratedUser({
    int? id,
    required int oldUserId,
    required _i1.UuidValue newUserId,
  }) = _MigratedUserImpl;

  factory MigratedUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return MigratedUser(
      id: jsonSerialization['id'] as int?,
      oldUserId: jsonSerialization['oldUserId'] as int,
      newUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['newUserId']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int oldUserId;

  _i1.UuidValue newUserId;

  /// Returns a shallow copy of this [MigratedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MigratedUser copyWith({
    int? id,
    int? oldUserId,
    _i1.UuidValue? newUserId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'oldUserId': oldUserId,
      'newUserId': newUserId.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MigratedUserImpl extends MigratedUser {
  _MigratedUserImpl({
    int? id,
    required int oldUserId,
    required _i1.UuidValue newUserId,
  }) : super._(
          id: id,
          oldUserId: oldUserId,
          newUserId: newUserId,
        );

  /// Returns a shallow copy of this [MigratedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MigratedUser copyWith({
    Object? id = _Undefined,
    int? oldUserId,
    _i1.UuidValue? newUserId,
  }) {
    return MigratedUser(
      id: id is int? ? id : this.id,
      oldUserId: oldUserId ?? this.oldUserId,
      newUserId: newUserId ?? this.newUserId,
    );
  }
}
