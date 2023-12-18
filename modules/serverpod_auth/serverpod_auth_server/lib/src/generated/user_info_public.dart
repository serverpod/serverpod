/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Information about a user that can safely be publically accessible.
abstract class UserInfoPublic extends _i1.SerializableEntity {
  UserInfoPublic._({
    this.id,
    required this.userName,
    this.fullName,
    required this.created,
    this.imageUrl,
  });

  factory UserInfoPublic({
    int? id,
    required String userName,
    String? fullName,
    required DateTime created,
    String? imageUrl,
  }) = _UserInfoPublicImpl;

  factory UserInfoPublic.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserInfoPublic(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userName: serializationManager
          .deserialize<String>(jsonSerialization['userName']),
      fullName: serializationManager
          .deserialize<String?>(jsonSerialization['fullName']),
      created: serializationManager
          .deserialize<DateTime>(jsonSerialization['created']),
      imageUrl: serializationManager
          .deserialize<String?>(jsonSerialization['imageUrl']),
    );
  }

  /// Id of the user, if known.
  int? id;

  /// The first name or nickname of the user.
  String userName;

  /// The full name of the user.
  String? fullName;

  /// The time when the user was created.
  DateTime created;

  /// URL to the user's avatar.
  String? imageUrl;

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
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'created': created,
      'imageUrl': imageUrl,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'created': created,
      'imageUrl': imageUrl,
    };
  }
}

class _Undefined {}

class _UserInfoPublicImpl extends UserInfoPublic {
  _UserInfoPublicImpl({
    int? id,
    required String userName,
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

  @override
  UserInfoPublic copyWith({
    Object? id = _Undefined,
    String? userName,
    Object? fullName = _Undefined,
    DateTime? created,
    Object? imageUrl = _Undefined,
  }) {
    return UserInfoPublic(
      id: id is int? ? id : this.id,
      userName: userName ?? this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      created: created ?? this.created,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
    );
  }
}
