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

/// Connects a table for handling uploading of files.
abstract class CloudStorageDirectUploadEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CloudStorageDirectUploadEntry._({
    this.id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
    int? maxFileSize,
    this.contentLength,
    bool? preventOverwrite,
    this.contentType,
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.customMetadata,
  }) : maxFileSize = maxFileSize ?? 10485760,
       preventOverwrite = preventOverwrite ?? false;

  factory CloudStorageDirectUploadEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
    int? maxFileSize,
    int? contentLength,
    bool? preventOverwrite,
    String? contentType,
    String? cacheControl,
    String? contentDisposition,
    String? contentEncoding,
    String? customMetadata,
  }) = _CloudStorageDirectUploadEntryImpl;

  factory CloudStorageDirectUploadEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CloudStorageDirectUploadEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      expiration: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiration'],
      ),
      authKey: jsonSerialization['authKey'] as String,
      maxFileSize: jsonSerialization['maxFileSize'] as int?,
      contentLength: jsonSerialization['contentLength'] as int?,
      preventOverwrite: jsonSerialization['preventOverwrite'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['preventOverwrite'],
            ),
      contentType: jsonSerialization['contentType'] as String?,
      cacheControl: jsonSerialization['cacheControl'] as String?,
      contentDisposition: jsonSerialization['contentDisposition'] as String?,
      contentEncoding: jsonSerialization['contentEncoding'] as String?,
      customMetadata: jsonSerialization['customMetadata'] as String?,
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

  /// The expiration time of when the file can be uploaded.
  DateTime expiration;

  /// Access key for retrieving a private file.
  String authKey;

  /// Maximum accepted upload size in bytes.
  int maxFileSize;

  /// Exact expected upload size in bytes, if known.
  int? contentLength;

  /// Whether an existing file must not be overwritten.
  bool preventOverwrite;

  /// MIME type to store with the uploaded file.
  String? contentType;

  /// HTTP cache control value to store with the uploaded file.
  String? cacheControl;

  /// HTTP content disposition value to store with the uploaded file.
  String? contentDisposition;

  /// HTTP content encoding value to store with the uploaded file.
  String? contentEncoding;

  /// JSON-encoded custom metadata to store with the uploaded file.
  String? customMetadata;

  /// Returns a shallow copy of this [CloudStorageDirectUploadEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CloudStorageDirectUploadEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
    int? maxFileSize,
    int? contentLength,
    bool? preventOverwrite,
    String? contentType,
    String? cacheControl,
    String? contentDisposition,
    String? contentEncoding,
    String? customMetadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.CloudStorageDirectUploadEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toJson(),
      'authKey': authKey,
      'maxFileSize': maxFileSize,
      if (contentLength != null) 'contentLength': contentLength,
      'preventOverwrite': preventOverwrite,
      if (contentType != null) 'contentType': contentType,
      if (cacheControl != null) 'cacheControl': cacheControl,
      if (contentDisposition != null) 'contentDisposition': contentDisposition,
      if (contentEncoding != null) 'contentEncoding': contentEncoding,
      if (customMetadata != null) 'customMetadata': customMetadata,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.CloudStorageDirectUploadEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toJson(),
      'authKey': authKey,
      'maxFileSize': maxFileSize,
      if (contentLength != null) 'contentLength': contentLength,
      'preventOverwrite': preventOverwrite,
      if (contentType != null) 'contentType': contentType,
      if (cacheControl != null) 'cacheControl': cacheControl,
      if (contentDisposition != null) 'contentDisposition': contentDisposition,
      if (contentEncoding != null) 'contentEncoding': contentEncoding,
      if (customMetadata != null) 'customMetadata': customMetadata,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CloudStorageDirectUploadEntryImpl extends CloudStorageDirectUploadEntry {
  _CloudStorageDirectUploadEntryImpl({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
    int? maxFileSize,
    int? contentLength,
    bool? preventOverwrite,
    String? contentType,
    String? cacheControl,
    String? contentDisposition,
    String? contentEncoding,
    String? customMetadata,
  }) : super._(
         id: id,
         storageId: storageId,
         path: path,
         expiration: expiration,
         authKey: authKey,
         maxFileSize: maxFileSize,
         contentLength: contentLength,
         preventOverwrite: preventOverwrite,
         contentType: contentType,
         cacheControl: cacheControl,
         contentDisposition: contentDisposition,
         contentEncoding: contentEncoding,
         customMetadata: customMetadata,
       );

  /// Returns a shallow copy of this [CloudStorageDirectUploadEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CloudStorageDirectUploadEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
    int? maxFileSize,
    Object? contentLength = _Undefined,
    bool? preventOverwrite,
    Object? contentType = _Undefined,
    Object? cacheControl = _Undefined,
    Object? contentDisposition = _Undefined,
    Object? contentEncoding = _Undefined,
    Object? customMetadata = _Undefined,
  }) {
    return CloudStorageDirectUploadEntry(
      id: id is int? ? id : this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      expiration: expiration ?? this.expiration,
      authKey: authKey ?? this.authKey,
      maxFileSize: maxFileSize ?? this.maxFileSize,
      contentLength: contentLength is int? ? contentLength : this.contentLength,
      preventOverwrite: preventOverwrite ?? this.preventOverwrite,
      contentType: contentType is String? ? contentType : this.contentType,
      cacheControl: cacheControl is String? ? cacheControl : this.cacheControl,
      contentDisposition: contentDisposition is String?
          ? contentDisposition
          : this.contentDisposition,
      contentEncoding: contentEncoding is String?
          ? contentEncoding
          : this.contentEncoding,
      customMetadata: customMetadata is String?
          ? customMetadata
          : this.customMetadata,
    );
  }
}
