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
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i2;

abstract class ObjectUser implements _i1.SerializableModel {
  ObjectUser._({
    this.id,
    this.name,
    required this.userInfoId,
    this.userInfo,
  });

  factory ObjectUser({
    int? id,
    String? name,
    required int userInfoId,
    _i2.UserInfo? userInfo,
  }) = _ObjectUserImpl;

  factory ObjectUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? name;

  int userInfoId;

  _i2.UserInfo? userInfo;

  /// Returns a shallow copy of this [ObjectUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectUser copyWith({
    int? id,
    String? name,
    int? userInfoId,
    _i2.UserInfo? userInfo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectUserImpl extends ObjectUser {
  _ObjectUserImpl({
    int? id,
    String? name,
    required int userInfoId,
    _i2.UserInfo? userInfo,
  }) : super._(
          id: id,
          name: name,
          userInfoId: userInfoId,
          userInfo: userInfo,
        );

  /// Returns a shallow copy of this [ObjectUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectUser copyWith({
    Object? id = _Undefined,
    Object? name = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
  }) {
    return ObjectUser(
      id: id is int? ? id : this.id,
      name: name is String? ? name : this.name,
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
    );
  }
}
