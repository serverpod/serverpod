/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class CloudStorageDirectUploadEntry extends TableRow {
  @override
  String get className => 'CloudStorageDirectUploadEntry';
  @override
  String get tableName => 'serverpod_cloud_storage_direct_upload';

  @override
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

  CloudStorageDirectUploadEntry.fromSerialization(Map<String, dynamic> serialization) {
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

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toUtc().toIso8601String(),
      'authKey': authKey,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toUtc().toIso8601String(),
      'authKey': authKey,
    });
  }
}

class CloudStorageDirectUploadEntryTable extends Table {
  CloudStorageDirectUploadEntryTable() : super(tableName: 'serverpod_cloud_storage_direct_upload');

  @override
  String tableName = 'serverpod_cloud_storage_direct_upload';
  final id = ColumnInt('id');
  final storageId = ColumnString('storageId');
  final path = ColumnString('path');
  final expiration = ColumnDateTime('expiration');
  final authKey = ColumnString('authKey');

  @override
  List<Column> get columns => [
    id,
    storageId,
    path,
    expiration,
    authKey,
  ];
}

CloudStorageDirectUploadEntryTable tCloudStorageDirectUploadEntry = CloudStorageDirectUploadEntryTable();
