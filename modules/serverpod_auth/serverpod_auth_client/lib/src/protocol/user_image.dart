/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a user image.
abstract class UserImage extends _i1.SerializableEntity {
  const UserImage._();

  const factory UserImage({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) = _UserImage;

  factory UserImage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserImage(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      version:
          serializationManager.deserialize<int>(jsonSerialization['version']),
      url: serializationManager.deserialize<String>(jsonSerialization['url']),
    );
  }

  UserImage copyWith({
    int? id,
    int? userId,
    int? version,
    String? url,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The id of the user.
  int get userId;

  /// Version of the image. Increased by one for every uploaded image.
  int get version;

  /// The URL to the image.
  String get url;
}

class _Undefined {}

/// Database bindings for a user image.
class _UserImage extends UserImage {
  const _UserImage({
    this.id,
    required this.userId,
    required this.version,
    required this.url,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The id of the user.
  @override
  final int userId;

  /// Version of the image. Increased by one for every uploaded image.
  @override
  final int version;

  /// The URL to the image.
  @override
  final String url;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is UserImage &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userId,
                  userId,
                ) ||
                other.userId == userId) &&
            (identical(
                  other.version,
                  version,
                ) ||
                other.version == version) &&
            (identical(
                  other.url,
                  url,
                ) ||
                other.url == url));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        version,
        url,
      );

  @override
  UserImage copyWith({
    Object? id = _Undefined,
    int? userId,
    int? version,
    String? url,
  }) {
    return UserImage(
      id: id == _Undefined ? this.id : (id as int?),
      userId: userId ?? this.userId,
      version: version ?? this.version,
      url: url ?? this.url,
    );
  }
}
