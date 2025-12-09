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
import '../../auth_user/models/auth_user.dart' as _i2;
import '../../profile/models/user_profile_image.dart' as _i3;
import 'package:serverpod_auth_core_client/src/protocol/protocol.dart' as _i4;

abstract class UserProfile implements _i1.SerializableModel {
  UserProfile._({
    this.id,
    required this.authUserId,
    this.authUser,
    this.userName,
    this.fullName,
    this.email,
    DateTime? createdAt,
    this.imageId,
    this.image,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _i1.UuidValue? imageId,
    _i3.UserProfileImage? image,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      imageId: jsonSerialization['imageId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['imageId']),
      image: jsonSerialization['image'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.UserProfileImage>(
              jsonSerialization['image'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to.
  _i2.AuthUser? authUser;

  /// The first name of the user or the user's nickname.
  String? userName;

  /// The full name of the user.
  String? fullName;

  /// The verified email address of the user.
  ///
  /// This should only be set by authentication providers that have
  /// checked ownership of this email for the user.
  ///
  /// Stored in lower-case.
  String? email;

  /// The time when this user was created.
  DateTime createdAt;

  _i1.UuidValue? imageId;

  /// The user's profile image.
  _i3.UserProfileImage? image;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _i1.UuidValue? imageId,
    _i3.UserProfileImage? image,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.UserProfile',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'createdAt': createdAt.toJson(),
      if (imageId != null) 'imageId': imageId?.toJson(),
      if (image != null) 'image': image?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _i1.UuidValue? imageId,
    _i3.UserProfileImage? image,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         userName: userName,
         fullName: fullName,
         email: email,
         createdAt: createdAt,
         imageId: imageId,
         image: image,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? createdAt,
    Object? imageId = _Undefined,
    Object? image = _Undefined,
  }) {
    return UserProfile(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      createdAt: createdAt ?? this.createdAt,
      imageId: imageId is _i1.UuidValue? ? imageId : this.imageId,
      image: image is _i3.UserProfileImage? ? image : this.image?.copyWith(),
    );
  }
}
