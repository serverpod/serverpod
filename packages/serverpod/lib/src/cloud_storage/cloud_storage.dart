import 'dart:typed_data';

import 'package:serverpod/src/cloud_storage/cloud_storage_exception.dart';
import 'package:serverpod/src/cloud_storage/upload_description.dart';

import '../server/session.dart';

/// The [CloudStorage] provides a standardized interface to store binary files
/// in the cloud. The default implementation is to use the database for binary
/// storage, but it can be extended to support Google Cloud, Amazon S3, or any
/// other cloud storage service.
///
/// The storage needs to be registered with the Serverpod before starting the
/// server. All methods in this class should throw an CloudStorageException if
/// the method fails.
abstract class CloudStorage {
  /// Identifies the storage. You can use multiple cloud storage types in a
  /// single Serverpod.
  String storageId;

  /// Creates a [CloudStorage] with the specified [storageId]. By default,
  /// two storages are used by Serverpod `public` and `private`. The public
  /// should be accessible to everyone (usually through a web interface),
  /// while the private is accessed internally only.
  CloudStorage(this.storageId);

  /// Saves a file to the cloud. The path should be relative to the root
  /// directory of the storage (i.e. the string shouldn't start with a
  /// slash).
  /// This method should throw a CloudStorageException if the file upload fails.
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    StoreFileOptions options = const StoreFileOptions(),
  });

  /// Retrieves a file from the cloud storage.
  ///
  /// Throws a [CloudStorageFileNotFoundException] if no file exists at [path].
  Future<ByteData> retrieveFile({
    required Session session,
    required String path,
  });

  /// Returns metadata and properties for the file at [path].
  ///
  /// Throws a [CloudStorageFileNotFoundException] if no file exists at
  /// [path].
  Future<FileStat> statFile({
    required Session session,
    required String path,
  });

  /// Returns true if the file exists.
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    try {
      await statFile(session: session, path: path);
      return true;
    } on CloudStorageFileNotFoundException {
      return false;
    }
  }

  /// Deletes the specified file if it exists. Does nothing if the file doesn't
  /// exist.
  Future<void> deleteFile({
    required Session session,
    required String path,
  });

  /// Returns a public link to a file in the storage.
  ///
  /// Throws a [CloudStorageFileNotFoundException] if the file does not exist.
  /// Throws a [CloudStorageUnsupportedOperationException] if the storage does
  /// not provide public URLs.
  Future<Uri> publicDownloadUrl({
    required Session session,
    required String path,
  });

  /// Returns a temporary link to a file in the storage with a
  /// [TemporaryDownloadUrlOptions.expirationDuration] time.
  ///
  /// Throws a [CloudStorageFileNotFoundException] if no file exists at [path].
  /// Throws a [CloudStorageUnsupportedOperationException] if this storage does
  /// not provide temporary URLs.
  Future<Uri> temporaryDownloadUrl({
    required Session session,
    required String path,
    TemporaryDownloadUrlOptions options = const TemporaryDownloadUrlOptions(),
  });

  /// Creates an URL that a client can post a file to via http post, optionally
  /// within the specified duration. After the file has been sent, the
  /// [verifyUpload] method should be called. If the file upload
  /// hasn't been confirmed before the URL expires, the file will be deleted.
  ///
  /// Throws a [CloudStorageUnsupportedOperationException] if this storage does not
  /// support direct file uploads.
  Future<UploadDescription> createUploadDescription({
    required Session session,
    required String path,
    UploadOptions options = const UploadOptions(),
  });

  /// Verifies a client upload at [path].
  ///
  /// Returns `true` when the upload was successfully verified and `false` when
  /// no uploaded file exists.
  Future<bool> verifyUpload({
    required Session session,
    required String path,
  });
}

/// Options used when the server stores a file directly.
final class StoreFileOptions {
  /// Time after which the file is considered expired.
  final DateTime? expiration;

  /// When true, the upload should fail if a file already exists at the
  /// given path.
  final bool preventOverwrite;

  /// Metadata to attach to the file.
  final FileMetadata metadata;

  /// Creates store-file options.
  const StoreFileOptions({
    this.expiration,
    this.preventOverwrite = false,
    this.metadata = const FileMetadata(),
  });
}

/// Options used when creating a client upload description.
final class UploadOptions {
  /// How long the upload authorization remains valid.
  final Duration expirationDuration;

  /// Maximum accepted file size in bytes.
  final int maxFileSize;

  /// Exact file size in bytes, when known. Lets the
  /// provider pin the accepted size instead of allowing anything up to
  /// [maxFileSize]. Must not exceed [maxFileSize].
  final int? contentLength;

  /// When true, the upload should fail if a file already exists at the
  /// given path.
  final bool preventOverwrite;

  /// Metadata to attach to the file.
  final FileMetadata metadata;

  /// Creates upload options.
  const UploadOptions({
    this.expirationDuration = const Duration(minutes: 10),
    this.maxFileSize = 10 * 1024 * 1024,
    this.contentLength,
    this.preventOverwrite = false,
    this.metadata = const FileMetadata(),
  });

  /// Validates provided options.
  void validate() {
    if (expirationDuration <= Duration.zero) {
      throw CloudStorageException(
        'Upload expirationDuration must be positive.',
      );
    }
    if (maxFileSize < 0) {
      throw CloudStorageException('Upload maxFileSize must be >= 0.');
    }
    if (contentLength != null && contentLength! < 0) {
      throw CloudStorageException('Upload contentLength must be >= 0.');
    }
    if (contentLength != null && contentLength! > maxFileSize) {
      throw CloudStorageException(
        'Content length ($contentLength bytes) exceeds maximum file size '
        '($maxFileSize bytes).',
      );
    }
  }
}

/// Options used to create a temporary download URL.
final class TemporaryDownloadUrlOptions {
  /// How long the URL remains valid.
  final Duration expirationDuration;

  /// Optional filename presented to the downloader.
  final String? downloadFileName;

  /// Optional response content type override.
  final String? contentType;

  /// Creates temporary-download URL options.
  const TemporaryDownloadUrlOptions({
    this.expirationDuration = const Duration(minutes: 10),
    this.downloadFileName,
    this.contentType,
  });

  /// Validates provided options.
  void validate() {
    if (expirationDuration <= Duration.zero) {
      throw CloudStorageException(
        'Temporary download URL expirationDuration must be positive.',
      );
    }
  }
}

/// Portable metadata that can be attached to a stored file.
final class FileMetadata {
  /// MIME type of the file.
  final String? contentType;

  /// HTTP cache control value for the file.
  final String? cacheControl;

  /// HTTP content disposition value for the file.
  final String? contentDisposition;

  /// HTTP content encoding value for the file.
  final String? contentEncoding;

  /// User-defined metadata.
  final Map<String, String> custom;

  /// Creates file metadata.
  const FileMetadata({
    this.contentType,
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.custom = const {},
  });
}

/// Metadata and properties reported for a stored file.
final class FileStat {
  /// File size in bytes.
  final int size;

  /// Time at which the file was last modified, when supplied by the storage.
  final DateTime? lastModified;

  /// MIME type of the file, when supplied by the storage.
  final String? contentType;

  /// HTTP cache control value of the file, when supplied by the storage.
  final String? cacheControl;

  /// HTTP content disposition value, when supplied by the storage.
  final String? contentDisposition;

  /// HTTP content encoding value, when supplied by the storage.
  final String? contentEncoding;

  /// Provider entity tag or generation identifier.
  final String? etag;

  /// User-defined metadata returned by the storage.
  final Map<String, String> custom;

  /// Creates file statistics.
  const FileStat({
    required this.size,
    this.lastModified,
    this.contentType,
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.etag,
    this.custom = const {},
  });
}
