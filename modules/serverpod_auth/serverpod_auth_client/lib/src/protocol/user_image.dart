/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

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
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userId: serializationManager
          .deserializeJson<int>(jsonSerialization['userId']),
      version: serializationManager
          .deserializeJson<int>(jsonSerialization['version']),
      url: serializationManager
          .deserializeJson<String>(jsonSerialization['url']),
    );
  }

  int? id;

  int userId;

  int version;

  String url;

  @override
  String get className => 'serverpod_auth_server.UserImage';
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
