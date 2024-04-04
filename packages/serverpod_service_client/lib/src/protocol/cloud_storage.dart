/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

/// An entry in the database for an uploaded file.
abstract class CloudStorageEntry extends _i1.SerializableEntity {
  CloudStorageEntry._({
    this.id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  });

  factory CloudStorageEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _i2.ByteData byteData,
    required bool verified,
  }) = _CloudStorageEntryImpl;

  factory CloudStorageEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return CloudStorageEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      addedTime: DateTime.parse(jsonSerialization['addedTime']),
      expiration: DateTime.tryParse(jsonSerialization['expiration']),
      byteData: (jsonSerialization['byteData'] != null &&
              jsonSerialization['byteData'] is _i2.Uint8List
          ? _i2.ByteData.view(
              jsonSerialization['byteData'].buffer,
              jsonSerialization['byteData'].offsetInBytes,
              jsonSerialization['byteData'].lengthInBytes,
            )
          : (jsonSerialization['byteData'] as String?)
              ?.base64DecodedByteData())!,
      verified: jsonSerialization['verified'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The storageId, typically `public` or `private`.
  String storageId;

  /// The path where the file is stored.
  String path;

  /// The time when the file was added.
  DateTime addedTime;

  /// The time at which the file expires and can be deleted.
  DateTime? expiration;

  /// The actual data of the uploaded file.
  _i2.ByteData byteData;

  /// True if the file has been verified as uploaded.
  bool verified;

  CloudStorageEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? addedTime,
    DateTime? expiration,
    _i2.ByteData? byteData,
    bool? verified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toJson(),
      if (expiration != null) 'expiration': expiration?.toJson(),
      'byteData': byteData.toJson(),
      'verified': verified,
    };
  }
}

class _Undefined {}

class _CloudStorageEntryImpl extends CloudStorageEntry {
  _CloudStorageEntryImpl({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _i2.ByteData byteData,
    required bool verified,
  }) : super._(
          id: id,
          storageId: storageId,
          path: path,
          addedTime: addedTime,
          expiration: expiration,
          byteData: byteData,
          verified: verified,
        );

  @override
  CloudStorageEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? addedTime,
    Object? expiration = _Undefined,
    _i2.ByteData? byteData,
    bool? verified,
  }) {
    return CloudStorageEntry(
      id: id is int? ? id : this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      addedTime: addedTime ?? this.addedTime,
      expiration: expiration is DateTime? ? expiration : this.expiration,
      byteData: byteData ?? this.byteData.clone(),
      verified: verified ?? this.verified,
    );
  }
}
