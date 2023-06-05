/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

/// An entry in the database for an uploaded file.
abstract class CloudStorageEntry extends _i1.SerializableEntity {
  const CloudStorageEntry._();

  const factory CloudStorageEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _i2.ByteData byteData,
    required bool verified,
  }) = _CloudStorageEntry;

  factory CloudStorageEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CloudStorageEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      storageId: serializationManager
          .deserialize<String>(jsonSerialization['storageId']),
      path: serializationManager.deserialize<String>(jsonSerialization['path']),
      addedTime: serializationManager
          .deserialize<DateTime>(jsonSerialization['addedTime']),
      expiration: serializationManager
          .deserialize<DateTime?>(jsonSerialization['expiration']),
      byteData: serializationManager
          .deserialize<_i2.ByteData>(jsonSerialization['byteData']),
      verified:
          serializationManager.deserialize<bool>(jsonSerialization['verified']),
    );
  }

  CloudStorageEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? addedTime,
    DateTime? expiration,
    _i2.ByteData? byteData,
    bool? verified,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The storageId, typically `public` or `private`.
  String get storageId;

  /// The path where the file is stored.
  String get path;

  /// The time when the file was added.
  DateTime get addedTime;

  /// The time at which the file expires and can be deleted.
  DateTime? get expiration;

  /// The actual data of the uploaded file.
  _i2.ByteData get byteData;

  /// True if the file has been verified as uploaded.
  bool get verified;
}

class _Undefined {}

/// An entry in the database for an uploaded file.
class _CloudStorageEntry extends CloudStorageEntry {
  const _CloudStorageEntry({
    this.id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The storageId, typically `public` or `private`.
  @override
  final String storageId;

  /// The path where the file is stored.
  @override
  final String path;

  /// The time when the file was added.
  @override
  final DateTime addedTime;

  /// The time at which the file expires and can be deleted.
  @override
  final DateTime? expiration;

  /// The actual data of the uploaded file.
  @override
  final _i2.ByteData byteData;

  /// True if the file has been verified as uploaded.
  @override
  final bool verified;

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

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is CloudStorageEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.storageId,
                  storageId,
                ) ||
                other.storageId == storageId) &&
            (identical(
                  other.path,
                  path,
                ) ||
                other.path == path) &&
            (identical(
                  other.addedTime,
                  addedTime,
                ) ||
                other.addedTime == addedTime) &&
            (identical(
                  other.expiration,
                  expiration,
                ) ||
                other.expiration == expiration) &&
            (identical(
                  other.byteData,
                  byteData,
                ) ||
                other.byteData == byteData) &&
            (identical(
                  other.verified,
                  verified,
                ) ||
                other.verified == verified));
  }

  @override
  int get hashCode => Object.hash(
        id,
        storageId,
        path,
        addedTime,
        expiration,
        byteData,
        verified,
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
      id: id == _Undefined ? this.id : (id as int?),
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      addedTime: addedTime ?? this.addedTime,
      expiration: expiration == _Undefined
          ? this.expiration
          : (expiration as DateTime?),
      byteData: byteData ?? this.byteData,
      verified: verified ?? this.verified,
    );
  }
}
