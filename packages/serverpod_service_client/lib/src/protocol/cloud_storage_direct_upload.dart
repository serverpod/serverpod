/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class CloudStorageDirectUploadEntry extends SerializableEntity {
  @override
  String get className => 'CloudStorageDirectUploadEntry';

  int? id;
  late String storageId;
  late String path;
  late DateTime expiration;
  late String authKey;

  CloudStorageDirectUploadEntry({
    this.id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
  });

  CloudStorageDirectUploadEntry.fromSerialization(
      Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    storageId = _data['storageId']!;
    path = _data['path']!;
    expiration = DateTime.tryParse(_data['expiration'])!;
    authKey = _data['authKey']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toUtc().toIso8601String(),
      'authKey': authKey,
    });
  }
}
