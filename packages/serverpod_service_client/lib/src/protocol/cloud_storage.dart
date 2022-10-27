/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

class CloudStorageEntry extends _i1.SerializableEntity {
  CloudStorageEntry({
    this.id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  });

  factory CloudStorageEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CloudStorageEntry(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      storageId: serializationManager
          .deserializeJson<String>(jsonSerialization['storageId']),
      path: serializationManager
          .deserializeJson<String>(jsonSerialization['path']),
      addedTime: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['addedTime']),
      expiration: serializationManager
          .deserializeJson<DateTime?>(jsonSerialization['expiration']),
      byteData: serializationManager
          .deserializeJson<_i2.ByteData>(jsonSerialization['byteData']),
      verified: serializationManager
          .deserializeJson<bool>(jsonSerialization['verified']),
    );
  }

  int? id;

  String storageId;

  String path;

  DateTime addedTime;

  DateTime? expiration;

  _i2.ByteData byteData;

  bool verified;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime,
      'expiration': expiration,
      'byteData': byteData,
      'verified': verified,
    };
  }
}
