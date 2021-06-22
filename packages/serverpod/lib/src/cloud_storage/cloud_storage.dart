import 'dart:io';
import 'dart:typed_data';

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
  /// Identifies the storage. You can used multiple types cloud storages in a
  /// single Serverpod.
  String storageId;

  /// Creates a [CloudStorage] with the specified [storageId]. By default,
  /// two storages are used by Serverepod `public` and `private`. The public
  /// should be accessible to everyone (usually through a web interface),
  /// while the private is accessed internally only.
  CloudStorage(this.storageId);

  /// Saves a file to the cloud, optionally with an [expiration] time. The
  /// path should be relative to the root directory of the storage (i.e. the
  /// string shouldn't start with a slash).
  /// This method should throw an IOException if the file upload fails.
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
  });

  /// Retrieves a file from the cloud storage or null if no such file exists.
  /// If the files are public, the may also be accessible through a web
  /// interface.
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  });

  /// Returns a public link to a file in the storage. If the file isn't public
  /// or if no such file exists, null is returned.
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  });

  /// Returns true if the file exists.
  Future<bool> fileExists({
    required Session session,
    required String path,
  });

  /// Deletes the specified file if it exists. Does nothing if the file doesn't
  /// exist.
  Future<void> deleteFile({
    required Session session,
    required String path,
  });
}

/// Exception thrown by [CloudStorage].
class CloudStorageException extends IOException {
  /// Description of the exception.
  String message;

  /// Creates a new exception.
  CloudStorageException(this.message) : super();

  @override
  String toString() {
    return 'CloudStorageException: $message';
  }
}
