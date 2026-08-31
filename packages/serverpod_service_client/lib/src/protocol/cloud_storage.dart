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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// An entry in the database for an uploaded file.
abstract class CloudStorageEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CloudStorageEntry._({
    this.id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
    this.contentType,
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.customMetadata,
  });

  factory CloudStorageEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _idt.ByteData byteData,
    required bool verified,
    String? contentType,
    String? cacheControl,
    String? contentDisposition,
    String? contentEncoding,
    String? customMetadata,
  }) = _CloudStorageEntryImpl;

  factory CloudStorageEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return CloudStorageEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      addedTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['addedTime'],
      ),
      expiration: jsonSerialization['expiration'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['expiration'],
            ),
      byteData: _isc.ByteDataJsonExtension.fromJson(
        jsonSerialization['byteData'],
      ),
      verified: _isc.BoolJsonExtension.fromJson(jsonSerialization['verified']),
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

  /// The time when the file was added.
  DateTime addedTime;

  /// The time at which the file expires and can be deleted.
  DateTime? expiration;

  /// The actual data of the uploaded file.
  _idt.ByteData byteData;

  /// True if the file has been verified as uploaded.
  bool verified;

  /// MIME type stored with the file.
  String? contentType;

  /// HTTP cache control value stored with the file.
  String? cacheControl;

  /// HTTP content disposition value stored with the file.
  String? contentDisposition;

  /// HTTP content encoding value stored with the file.
  String? contentEncoding;

  /// JSON-encoded custom metadata stored with the file.
  String? customMetadata;

  /// Returns a shallow copy of this [CloudStorageEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CloudStorageEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? addedTime,
    DateTime? expiration,
    _idt.ByteData? byteData,
    bool? verified,
    String? contentType,
    String? cacheControl,
    String? contentDisposition,
    String? contentEncoding,
    String? customMetadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.CloudStorageEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toJson(),
      if (expiration != null) 'expiration': expiration?.toJson(),
      'byteData': byteData.toJson(),
      'verified': verified,
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
      '__className__': 'serverpod.CloudStorageEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toJson(),
      if (expiration != null) 'expiration': expiration?.toJson(),
      'byteData': byteData.toJson(),
      'verified': verified,
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

class _CloudStorageEntryImpl extends CloudStorageEntry {
  _CloudStorageEntryImpl({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _idt.ByteData byteData,
    required bool verified,
    String? contentType,
    String? cacheControl,
    String? contentDisposition,
    String? contentEncoding,
    String? customMetadata,
  }) : super._(
         id: id,
         storageId: storageId,
         path: path,
         addedTime: addedTime,
         expiration: expiration,
         byteData: byteData,
         verified: verified,
         contentType: contentType,
         cacheControl: cacheControl,
         contentDisposition: contentDisposition,
         contentEncoding: contentEncoding,
         customMetadata: customMetadata,
       );

  /// Returns a shallow copy of this [CloudStorageEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CloudStorageEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? addedTime,
    Object? expiration = _Undefined,
    _idt.ByteData? byteData,
    bool? verified,
    Object? contentType = _Undefined,
    Object? cacheControl = _Undefined,
    Object? contentDisposition = _Undefined,
    Object? contentEncoding = _Undefined,
    Object? customMetadata = _Undefined,
  }) {
    return CloudStorageEntry(
      id: id is int? ? id : this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      addedTime: addedTime ?? this.addedTime,
      expiration: expiration is DateTime? ? expiration : this.expiration,
      byteData: byteData ?? this.byteData.clone(),
      verified: verified ?? this.verified,
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
