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
import '../../profile/models/user_profile.dart' as _ixqiikps;

/// Database entity for storing user profile image information.
abstract class UserProfileImage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _isc.UuidValue? id,
    required _isc.UuidValue userProfileId,
    _ixqiikps.UserProfile? userProfile,
    DateTime? createdAt,
    required String storageId,
    required String path,
    required Uri url,
  }) = _UserProfileImageImpl;

  factory UserProfileImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileImage(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userProfileId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['userProfileId'],
      ),
      userProfile: jsonSerialization['userProfile'] == null
          ? null
          : _ifwxqeej.Protocol().deserialize<_ixqiikps.UserProfile>(
              jsonSerialization['userProfile'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      url: _isc.UriJsonExtension.fromJson(jsonSerialization['url']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue userProfileId;

  /// The [UserProfile] this image belongs to.
  _ixqiikps.UserProfile? userProfile;

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
  @_isc.useResult
  UserProfileImage copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userProfileId,
    _ixqiikps.UserProfile? userProfile,
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_core.UserProfileImage',
      if (id != null) 'id': id?.toJson(),
      'userProfileId': userProfileId.toJson(),
      if (userProfile != null) 'userProfile': userProfile?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'storageId': storageId,
      'path': path,
      'url': url.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImageImpl extends UserProfileImage {
  _UserProfileImageImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userProfileId,
    _ixqiikps.UserProfile? userProfile,
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
  @_isc.useResult
  @override
  UserProfileImage copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userProfileId,
    Object? userProfile = _Undefined,
    DateTime? createdAt,
    String? storageId,
    String? path,
    Uri? url,
  }) {
    return UserProfileImage(
      id: id is _isc.UuidValue? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      userProfile: userProfile is _ixqiikps.UserProfile?
          ? userProfile
          : this.userProfile?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      url: url ?? this.url,
    );
  }
}
