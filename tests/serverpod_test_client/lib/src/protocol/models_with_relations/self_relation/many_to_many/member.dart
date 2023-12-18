/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Member extends _i1.SerializableModel {
  Member._({
    this.id,
    required this.name,
    this.blocking,
    this.blockedBy,
  });

  factory Member({
    int? id,
    required String name,
    List<_i2.Blocking>? blocking,
    List<_i2.Blocking>? blockedBy,
  }) = _MemberImpl;

  factory Member.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Member(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      blocking: serializationManager
          .deserialize<List<_i2.Blocking>?>(jsonSerialization['blocking']),
      blockedBy: serializationManager
          .deserialize<List<_i2.Blocking>?>(jsonSerialization['blockedBy']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.Blocking>? blocking;

  List<_i2.Blocking>? blockedBy;

  Member copyWith({
    int? id,
    String? name,
    List<_i2.Blocking>? blocking,
    List<_i2.Blocking>? blockedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'blocking': blocking,
      'blockedBy': blockedBy,
    };
  }
}

class _Undefined {}

class _MemberImpl extends Member {
  _MemberImpl({
    int? id,
    required String name,
    List<_i2.Blocking>? blocking,
    List<_i2.Blocking>? blockedBy,
  }) : super._(
          id: id,
          name: name,
          blocking: blocking,
          blockedBy: blockedBy,
        );

  @override
  Member copyWith({
    Object? id = _Undefined,
    String? name,
    Object? blocking = _Undefined,
    Object? blockedBy = _Undefined,
  }) {
    return Member(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      blocking:
          blocking is List<_i2.Blocking>? ? blocking : this.blocking?.clone(),
      blockedBy: blockedBy is List<_i2.Blocking>?
          ? blockedBy
          : this.blockedBy?.clone(),
    );
  }
}
