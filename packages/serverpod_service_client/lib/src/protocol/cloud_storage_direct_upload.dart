/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class CloudStorageDirectUploadEntry extends _i1.SerializableEntity {
  CloudStorageDirectUploadEntry({
    this.id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
  });

  factory CloudStorageDirectUploadEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CloudStorageDirectUploadEntry(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      storageId: serializationManager
          .deserializeJson<String>(jsonSerialization['storageId']),
      path: serializationManager
          .deserializeJson<String>(jsonSerialization['path']),
      expiration: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['expiration']),
      authKey: serializationManager
          .deserializeJson<String>(jsonSerialization['authKey']),
    );
  }

  int? id;

  String storageId;

  String path;

  DateTime expiration;

  String authKey;

  @override
  String get className => 'CloudStorageDirectUploadEntry';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration,
      'authKey': authKey,
    };
  }
}
