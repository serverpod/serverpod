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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i2;
import 'package:serverpod_auth_test_client/src/protocol/protocol.dart' as _i3;

abstract class UserData implements _i1.SerializableModel {
  UserData._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.displayName,
    this.bio,
  });

  factory UserData({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String displayName,
    String? bio,
  }) = _UserDataImpl;

  factory UserData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserData(
      id: jsonSerialization['id'] as int?,
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      displayName: jsonSerialization['displayName'] as String,
      bio: jsonSerialization['bio'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// User's display name
  String displayName;

  /// User's bio
  String? bio;

  /// Returns a shallow copy of this [UserData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserData copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? displayName,
    String? bio,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserData',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'displayName': displayName,
      if (bio != null) 'bio': bio,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserDataImpl extends UserData {
  _UserDataImpl({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String displayName,
    String? bio,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         displayName: displayName,
         bio: bio,
       );

  /// Returns a shallow copy of this [UserData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserData copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? displayName,
    Object? bio = _Undefined,
  }) {
    return UserData(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      displayName: displayName ?? this.displayName,
      bio: bio is String? ? bio : this.bio,
    );
  }
}
