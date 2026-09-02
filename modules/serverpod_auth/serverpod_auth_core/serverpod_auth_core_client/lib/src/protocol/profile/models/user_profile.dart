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
import 'package:serverpod_auth_core_client/src/protocol/protocol.dart'
    as _ifwxqeej;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../auth_user/models/auth_user.dart' as _ivyervu7;
import '../../profile/models/user_profile_image.dart' as _i7y29ltp;

/// Core database entity representing a user profile in the authentication system.
///
/// This class is meant to be used only to interact with the database. To transfer
/// user profile data, use the [UserProfileModel] DTO.
abstract class UserProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _isc.UuidValue? id,
    required _isc.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _isc.UuidValue? imageId,
    _i7y29ltp.UserProfileImage? image,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ifwxqeej.Protocol().deserialize<_ivyervu7.AuthUser>(
              jsonSerialization['authUser'],
            ),
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      imageId: jsonSerialization['imageId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['imageId']),
      image: jsonSerialization['image'] == null
          ? null
          : _ifwxqeej.Protocol().deserialize<_i7y29ltp.UserProfileImage>(
              jsonSerialization['image'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to.
  _ivyervu7.AuthUser? authUser;

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

  _isc.UuidValue? imageId;

  /// The user's profile image.
  _i7y29ltp.UserProfileImage? image;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserProfile copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? authUserId,
    _ivyervu7.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _isc.UuidValue? imageId,
    _i7y29ltp.UserProfileImage? image,
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.UserProfile',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJsonForProtocol(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'createdAt': createdAt.toJson(),
      if (imageId != null) 'imageId': imageId?.toJson(),
      if (image != null) 'image': image?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    String? userName,
    String? fullName,
    String? email,
    DateTime? createdAt,
    _isc.UuidValue? imageId,
    _i7y29ltp.UserProfileImage? image,
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
  @_isc.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? createdAt,
    Object? imageId = _Undefined,
    Object? image = _Undefined,
  }) {
    return UserProfile(
      id: id is _isc.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _ivyervu7.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      createdAt: createdAt ?? this.createdAt,
      imageId: imageId is _isc.UuidValue? ? imageId : this.imageId,
      image: image is _i7y29ltp.UserProfileImage?
          ? image
          : this.image?.copyWith(),
    );
  }
}
