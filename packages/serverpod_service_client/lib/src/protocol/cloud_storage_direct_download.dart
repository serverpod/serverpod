/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Grants temporary download access to a database-backed stored file.
abstract class CloudStorageDirectDownloadEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CloudStorageDirectDownloadEntry._({
    this.id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
    this.downloadFileName,
    this.contentType,
  });

  factory CloudStorageDirectDownloadEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
    String? downloadFileName,
    String? contentType,
  }) = _CloudStorageDirectDownloadEntryImpl;

  factory CloudStorageDirectDownloadEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CloudStorageDirectDownloadEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      expiration: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiration'],
      ),
      authKey: jsonSerialization['authKey'] as String,
      downloadFileName: jsonSerialization['downloadFileName'] as String?,
      contentType: jsonSerialization['contentType'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The storage containing the file.
  String storageId;

  /// The path of the file.
  String path;

  /// The expiration time of the temporary URL.
  DateTime expiration;

  /// Opaque access key carried by the temporary URL.
  String authKey;

  /// Optional filename presented to the downloader.
  String? downloadFileName;

  /// Optional response MIME type override.
  String? contentType;

  /// Returns a shallow copy of this [CloudStorageDirectDownloadEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CloudStorageDirectDownloadEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
    String? downloadFileName,
    String? contentType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.CloudStorageDirectDownloadEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toJson(),
      'authKey': authKey,
      if (downloadFileName != null) 'downloadFileName': downloadFileName,
      if (contentType != null) 'contentType': contentType,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.CloudStorageDirectDownloadEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toJson(),
      'authKey': authKey,
      if (downloadFileName != null) 'downloadFileName': downloadFileName,
      if (contentType != null) 'contentType': contentType,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CloudStorageDirectDownloadEntryImpl
    extends CloudStorageDirectDownloadEntry {
  _CloudStorageDirectDownloadEntryImpl({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
    String? downloadFileName,
    String? contentType,
  }) : super._(
         id: id,
         storageId: storageId,
         path: path,
         expiration: expiration,
         authKey: authKey,
         downloadFileName: downloadFileName,
         contentType: contentType,
       );

  /// Returns a shallow copy of this [CloudStorageDirectDownloadEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CloudStorageDirectDownloadEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
    Object? downloadFileName = _Undefined,
    Object? contentType = _Undefined,
  }) {
    return CloudStorageDirectDownloadEntry(
      id: id is int? ? id : this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      expiration: expiration ?? this.expiration,
      authKey: authKey ?? this.authKey,
      downloadFileName: downloadFileName is String?
          ? downloadFileName
          : this.downloadFileName,
      contentType: contentType is String? ? contentType : this.contentType,
    );
  }
}
