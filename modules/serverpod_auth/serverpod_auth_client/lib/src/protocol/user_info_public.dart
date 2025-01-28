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

/// Information about a user that can safely be publicly accessible.
abstract class UserInfoPublic implements _i1.SerializableModel {
  UserInfoPublic._({
    this.id,
    this.userName,
    this.fullName,
    required this.created,
    this.imageUrl,
  });

  factory UserInfoPublic({
    int? id,
    String? userName,
    String? fullName,
    required DateTime created,
    String? imageUrl,
  }) = _UserInfoPublicImpl;

  factory UserInfoPublic.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserInfoPublic(
      id: jsonSerialization['id'] as int?,
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      imageUrl: jsonSerialization['imageUrl'] as String?,
    );
  }

  /// Id of the user, if known.
  int? id;

  /// The first name or nickname of the user.
  String? userName;

  /// The full name of the user.
  String? fullName;

  /// The time when the user was created.
  DateTime created;

  /// URL to the user's avatar.
  String? imageUrl;

  /// Returns a shallow copy of this [UserInfoPublic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserInfoPublic copyWith({
    int? id,
    String? userName,
    String? fullName,
    DateTime? created,
    String? imageUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      'created': created.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserInfoPublicImpl extends UserInfoPublic {
  _UserInfoPublicImpl({
    int? id,
    String? userName,
    String? fullName,
    required DateTime created,
    String? imageUrl,
  }) : super._(
          id: id,
          userName: userName,
          fullName: fullName,
          created: created,
          imageUrl: imageUrl,
        );

  /// Returns a shallow copy of this [UserInfoPublic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserInfoPublic copyWith({
    Object? id = _Undefined,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    DateTime? created,
    Object? imageUrl = _Undefined,
  }) {
    return UserInfoPublic(
      id: id is int? ? id : this.id,
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      created: created ?? this.created,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
    );
  }
}
