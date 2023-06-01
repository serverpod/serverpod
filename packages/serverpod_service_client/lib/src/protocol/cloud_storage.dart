/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

/// An entry in the database for an uploaded file.
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// The storageId, typically `public` or `private`.
  final String storageId;

  /// The path where the file is stored.
  final String path;

  /// The time when the file was added.
  final DateTime addedTime;

  /// The time at which the file expires and can be deleted.
  final DateTime? expiration;

  /// The actual data of the uploaded file.
  final _i2.ByteData byteData;

  /// True if the file has been verified as uploaded.
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
    return identical(this, other) ||
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

  CloudStorageEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? addedTime,
    DateTime? expiration,
    _i2.ByteData? byteData,
    bool? verified,
  }) {
    return CloudStorageEntry(
      id: id ?? this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      addedTime: addedTime ?? this.addedTime,
      expiration: expiration ?? this.expiration,
      byteData: byteData ?? this.byteData,
      verified: verified ?? this.verified,
    );
  }
}
