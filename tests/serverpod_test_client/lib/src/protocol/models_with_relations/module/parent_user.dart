/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ParentUser extends _i1.SerializableEntity {
  ParentUser._({
    this.id,
    this.name,
    this.userInfoId,
  });

  factory ParentUser({
    int? id,
    String? name,
    int? userInfoId,
  }) = _ParentUserImpl;

  factory ParentUser.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ParentUser(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name:
          serializationManager.deserialize<String?>(jsonSerialization['name']),
      userInfoId: serializationManager
          .deserialize<int?>(jsonSerialization['userInfoId']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? name;

  int? userInfoId;

  ParentUser copyWith({
    int? id,
    String? name,
    int? userInfoId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (userInfoId != null) 'userInfoId': userInfoId,
    };
  }
}

class _Undefined {}

class _ParentUserImpl extends ParentUser {
  _ParentUserImpl({
    int? id,
    String? name,
    int? userInfoId,
  }) : super._(
          id: id,
          name: name,
          userInfoId: userInfoId,
        );

  @override
  ParentUser copyWith({
    Object? id = _Undefined,
    Object? name = _Undefined,
    Object? userInfoId = _Undefined,
  }) {
    return ParentUser(
      id: id is int? ? id : this.id,
      name: name is String? ? name : this.name,
      userInfoId: userInfoId is int? ? userInfoId : this.userInfoId,
    );
  }
}
