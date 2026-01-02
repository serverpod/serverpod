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
import '../../profile/models/user_profile.dart' as _i2;
import 'package:serverpod_auth_core_client/src/protocol/protocol.dart' as _i3;

/// Database entity for storing user profile image information.
abstract class UserProfileImage implements _i1.SerializableModel {
  UserProfileImage._({
    this.id,
    required this.userProfileId,
    this.userProfile,
    DateTime? createdAt,
    required this.storageId,
    required this.path,
    required this.url,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfileImage({
    _i1.UuidValue? id,
    required _i1.UuidValue userProfileId,
    _i2.UserProfile? userProfile,
    DateTime? createdAt,
    required String storageId,
    required String path,
    required Uri url,
  }) = _UserProfileImageImpl;

  factory UserProfileImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileImage(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userProfileId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['userProfileId'],
      ),
      userProfile: jsonSerialization['userProfile'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.UserProfile>(
              jsonSerialization['userProfile'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      url: _i1.UriJsonExtension.fromJson(jsonSerialization['url']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue userProfileId;

  /// The [UserProfile] this image belongs to.
  _i2.UserProfile? userProfile;

  /// The time when this profile image was created.
  DateTime createdAt;

  /// Storage in which the image is stored.
  String storageId;

  /// Path inside [storageId] at which the image is stored.
  String path;

  /// The public URL to access the image.
  Uri url;

  /// Returns a shallow copy of this [UserProfileImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfileImage copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userProfileId,
    _i2.UserProfile? userProfile,
    DateTime? createdAt,
    String? storageId,
    String? path,
    Uri? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.UserProfileImage',
      if (id != null) 'id': id?.toJson(),
      'userProfileId': userProfileId.toJson(),
      if (userProfile != null) 'userProfile': userProfile?.toJson(),
      'createdAt': createdAt.toJson(),
      'storageId': storageId,
      'path': path,
      'url': url.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImageImpl extends UserProfileImage {
  _UserProfileImageImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userProfileId,
    _i2.UserProfile? userProfile,
    DateTime? createdAt,
    required String storageId,
    required String path,
    required Uri url,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         userProfile: userProfile,
         createdAt: createdAt,
         storageId: storageId,
         path: path,
         url: url,
       );

  /// Returns a shallow copy of this [UserProfileImage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfileImage copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userProfileId,
    Object? userProfile = _Undefined,
    DateTime? createdAt,
    String? storageId,
    String? path,
    Uri? url,
  }) {
    return UserProfileImage(
      id: id is _i1.UuidValue? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      userProfile: userProfile is _i2.UserProfile?
          ? userProfile
          : this.userProfile?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      url: url ?? this.url,
    );
  }
}
