/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a user image.
abstract class UserImage extends _i1.SerializableModel {
  UserImage._({
    this.id,
    required this.userId,
    required this.version,
    required this.url,
  });

  factory UserImage({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) = _UserImageImpl;

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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the user.
  int userId;

  /// Version of the image. Increased by one for every uploaded image.
  int version;

  /// The URL to the image.
  String url;

  UserImage copyWith({
    int? id,
    int? userId,
    int? version,
    String? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }
}

class _Undefined {}

class _UserImageImpl extends UserImage {
  _UserImageImpl({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) : super._(
          id: id,
          userId: userId,
          version: version,
          url: url,
        );

  @override
  UserImage copyWith({
    Object? id = _Undefined,
    int? userId,
    int? version,
    String? url,
  }) {
    return UserImage(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      version: version ?? this.version,
      url: url ?? this.url,
    );
  }
}
