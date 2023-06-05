/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Connects a table for handling uploading of files.
abstract class CloudStorageDirectUploadEntry extends _i1.SerializableEntity {
  const CloudStorageDirectUploadEntry._();

  const factory CloudStorageDirectUploadEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
  }) = _CloudStorageDirectUploadEntry;

  factory CloudStorageDirectUploadEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CloudStorageDirectUploadEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      storageId: serializationManager
          .deserialize<String>(jsonSerialization['storageId']),
      path: serializationManager.deserialize<String>(jsonSerialization['path']),
      expiration: serializationManager
          .deserialize<DateTime>(jsonSerialization['expiration']),
      authKey: serializationManager
          .deserialize<String>(jsonSerialization['authKey']),
    );
  }

  CloudStorageDirectUploadEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The storageId, typically `public` or `private`.
  String get storageId;

  /// The path where the file is stored.
  String get path;

  /// The expiration time of when the file can be uploaded.
  DateTime get expiration;

  /// Access key for retrieving a private file.
  String get authKey;
}

class _Undefined {}

/// Connects a table for handling uploading of files.
class _CloudStorageDirectUploadEntry extends CloudStorageDirectUploadEntry {
  const _CloudStorageDirectUploadEntry({
    this.id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
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

  /// The expiration time of when the file can be uploaded.
  @override
  final DateTime expiration;

  /// Access key for retrieving a private file.
  @override
  final String authKey;

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

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is CloudStorageDirectUploadEntry &&
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
                  other.expiration,
                  expiration,
                ) ||
                other.expiration == expiration) &&
            (identical(
                  other.authKey,
                  authKey,
                ) ||
                other.authKey == authKey));
  }

  @override
  int get hashCode => Object.hash(
        id,
        storageId,
        path,
        expiration,
        authKey,
      );

  @override
  CloudStorageDirectUploadEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
  }) {
    return CloudStorageDirectUploadEntry(
      id: id == _Undefined ? this.id : (id as int?),
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      expiration: expiration ?? this.expiration,
      authKey: authKey ?? this.authKey,
    );
  }
}
