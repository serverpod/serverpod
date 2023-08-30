/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a user image.
class UserImage extends _i1.SerializableEntity {
  UserImage({
    this.id,
    required this.userId,
    required this.version,
    required this.url,
  });

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

  int? id;

  /// The id of the user.
  int userId;

  /// Version of the image. Increased by one for every uploaded image.
  int version;

  /// The URL to the image.
  String url;

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
