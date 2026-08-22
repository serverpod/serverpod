import 'dart:io';

/// Exception thrown by [CloudStorage].
class CloudStorageException extends IOException {
  /// Description of the exception.
  String message;

  /// Creates a new exception.
  CloudStorageException(this.message) : super();

  @override
  String toString() {
    return '$runtimeType: $message';
  }
}

/// Exception thrown when an object does not exist in cloud storage.
class CloudStorageFileNotFoundException extends CloudStorageException {
  /// Creates a new [CloudStorageFileNotFoundException].
  CloudStorageFileNotFoundException({
    required this.storageId,
    required this.path,
  }) : super('No object exists at path "$path" in storage "$storageId".');

  /// Identifier of the storage that does not contain the object.
  final String storageId;

  /// Path of the object that was not found.
  final String path;
}

/// Exception thrown when a cloud storage operation is not supported.
class CloudStorageUnsupportedOperationException extends CloudStorageException {
  /// Creates a new [CloudStorageUnsupportedOperationException].
  CloudStorageUnsupportedOperationException({
    required this.storageId,
    required this.operation,
  }) : super('Storage "$storageId" does not support $operation.');

  /// Identifier of the storage that does not support the operation.
  final String storageId;

  /// Description of the unsupported operation.
  final String operation;
}
