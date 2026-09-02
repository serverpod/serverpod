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
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i312scxx;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;

abstract class ObjectUser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _i312scxx.UserInfo? userInfo,
  }) = _ObjectUserImpl;

  factory ObjectUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_i312scxx.UserInfo>(
              jsonSerialization['userInfo'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? name;

  int userInfoId;

  _i312scxx.UserInfo? userInfo;

  /// Returns a shallow copy of this [ObjectUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectUser copyWith({
    int? id,
    String? name,
    int? userInfoId,
    _i312scxx.UserInfo? userInfo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectUser',
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectUser',
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectUserImpl extends ObjectUser {
  _ObjectUserImpl({
    int? id,
    String? name,
    required int userInfoId,
    _i312scxx.UserInfo? userInfo,
  }) : super._(
         id: id,
         name: name,
         userInfoId: userInfoId,
         userInfo: userInfo,
       );

  /// Returns a shallow copy of this [ObjectUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      userInfo: userInfo is _i312scxx.UserInfo?
          ? userInfo
          : this.userInfo?.copyWith(),
    );
  }
}
