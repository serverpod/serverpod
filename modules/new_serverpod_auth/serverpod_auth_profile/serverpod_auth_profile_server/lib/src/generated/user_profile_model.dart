/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UserProfileModel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserProfileModel._({
    required this.authUserId,
    this.userName,
    this.fullName,
    this.email,
    this.imageUrl,
  });

  factory UserProfileModel({
    required _i1.UuidValue authUserId,
    String? userName,
    String? fullName,
    String? email,
    Uri? imageUrl,
  }) = _UserProfileModelImpl;

  factory UserProfileModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileModel(
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      imageUrl: jsonSerialization['imageUrl'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(jsonSerialization['imageUrl']),
    );
  }

  /// The [AuthUser]'s ID this profile belongs to.
  _i1.UuidValue authUserId;

  /// The first name of the user or the user's nickname.
  String? userName;

  /// The full name of the user.
  String? fullName;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String? email;

  /// The public URL of the user's profile image.
  Uri? imageUrl;

  /// Returns a shallow copy of this [UserProfileModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfileModel copyWith({
    _i1.UuidValue? authUserId,
    String? userName,
    String? fullName,
    String? email,
    Uri? imageUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'authUserId': authUserId.toJson(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (imageUrl != null) 'imageUrl': imageUrl?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'authUserId': authUserId.toJson(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (imageUrl != null) 'imageUrl': imageUrl?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileModelImpl extends UserProfileModel {
  _UserProfileModelImpl({
    required _i1.UuidValue authUserId,
    String? userName,
    String? fullName,
    String? email,
    Uri? imageUrl,
  }) : super._(
          authUserId: authUserId,
          userName: userName,
          fullName: fullName,
          email: email,
          imageUrl: imageUrl,
        );

  /// Returns a shallow copy of this [UserProfileModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfileModel copyWith({
    _i1.UuidValue? authUserId,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    Object? imageUrl = _Undefined,
  }) {
    return UserProfileModel(
      authUserId: authUserId ?? this.authUserId,
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      imageUrl: imageUrl is Uri? ? imageUrl : this.imageUrl,
    );
  }
}
