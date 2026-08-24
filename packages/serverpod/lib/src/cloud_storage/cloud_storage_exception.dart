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

/// Exception thrown when a file does not exist in cloud storage.
class CloudStorageFileNotFoundException extends CloudStorageException {
  /// Creates a new [CloudStorageFileNotFoundException].
  CloudStorageFileNotFoundException({
    required this.storageId,
    required this.path,
  }) : super('No file exists at path "$path" in storage "$storageId".');

  /// Identifier of the storage that does not contain the file.
  final String storageId;

  /// Path of the object that was not found.
  final String path;
}

/// Exception thrown when a file cannot be stored without overwriting an
/// existing file.
class CloudStorageFileAlreadyExistsException extends CloudStorageException {
  /// Creates a new [CloudStorageFileAlreadyExistsException].
  CloudStorageFileAlreadyExistsException({
    required this.storageId,
    required this.path,
  }) : super(
         'A file already exists at path "$path" in storage "$storageId".',
       );

  /// Identifier of the storage containing the file.
  final String storageId;

  /// Path of the file that already exists.
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
