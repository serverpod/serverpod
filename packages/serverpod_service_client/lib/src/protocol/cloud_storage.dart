/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class CloudStorageEntry extends SerializableEntity {
  @override
  String get className => 'CloudStorageEntry';

  int? id;
  late String storageId;
  late String path;
  late DateTime addedTime;
  DateTime? expiration;
  late ByteData byteData;
  late bool verified;

  CloudStorageEntry({
    this.id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  });

  CloudStorageEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    storageId = _data['storageId']!;
    path = _data['path']!;
    addedTime = DateTime.tryParse(_data['addedTime'])!;
    expiration = _data['expiration'] != null
        ? DateTime.tryParse(_data['expiration'])
        : null;
    byteData = _data['byteData'] is String
        ? (_data['byteData'] as String).base64DecodedByteData()!
        : ByteData.view((_data['byteData'] as Uint8List).buffer);
    verified = _data['verified']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toUtc().toIso8601String(),
      'expiration': expiration?.toUtc().toIso8601String(),
      'byteData': byteData.base64encodedString(),
      'verified': verified,
    });
  }
}
