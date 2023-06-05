/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class _Undefined {}

/// Information about a user that can safely be publically accessible.
class UserInfoPublic extends _i1.SerializableEntity {
  UserInfoPublic({
    this.id,
    required this.userName,
    this.fullName,
    required this.created,
    this.imageUrl,
  });

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
  final int? id;

  /// The first name or nickname of the user.
  final String userName;

  /// The full name of the user.
  final String? fullName;

  /// The time when the user was created.
  final DateTime created;

  /// URL to the user's avatar.
  final String? imageUrl;

  late Function({
    int? id,
    String? userName,
    String? fullName,
    DateTime? created,
    String? imageUrl,
  }) copyWith = _copyWith;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is UserInfoPublic &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userName,
                  userName,
                ) ||
                other.userName == userName) &&
            (identical(
                  other.fullName,
                  fullName,
                ) ||
                other.fullName == fullName) &&
            (identical(
                  other.created,
                  created,
                ) ||
                other.created == created) &&
            (identical(
                  other.imageUrl,
                  imageUrl,
                ) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userName,
        fullName,
        created,
        imageUrl,
      );

  UserInfoPublic _copyWith({
    Object? id = _Undefined,
    String? userName,
    Object? fullName = _Undefined,
    DateTime? created,
    Object? imageUrl = _Undefined,
  }) {
    return UserInfoPublic(
      id: id == _Undefined ? this.id : (id as int?),
      userName: userName ?? this.userName,
      fullName: fullName == _Undefined ? this.fullName : (fullName as String?),
      created: created ?? this.created,
      imageUrl: imageUrl == _Undefined ? this.imageUrl : (imageUrl as String?),
    );
  }
}
