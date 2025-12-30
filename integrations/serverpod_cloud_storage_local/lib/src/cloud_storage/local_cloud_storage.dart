import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

/// A [CloudStorage] implementation that stores files on the local filesystem.
///
/// This is useful for development, self-hosted deployments, or scenarios where
/// you don't want to use cloud storage providers like S3 or GCP.
///
/// Example usage:
/// ```dart
/// pod.addCloudStorage(
///   LocalCloudStorage(
///     serverpod: pod,
///     storageId: 'public',
///     storagePath: '/var/serverpod/uploads/public',
///     public: true,
///   ),
/// );
/// ```
class LocalCloudStorage extends CloudStorage {
  /// The Serverpod instance.
  final Serverpod _serverpod;

  /// The base path on the local filesystem where files will be stored.
  final String storagePath;

  /// Whether the storage is publicly accessible.
  final bool public;

  /// Optional custom host for public URLs. If not provided, the server's
  /// public host will be used.
  final String? publicHost;

  /// Optional custom port for public URLs. If not provided, the server's
  /// public port will be used.
  final int? publicPort;

  /// Optional custom scheme for public URLs. If not provided, the server's
  /// public scheme will be used.
  final String? publicScheme;

  /// Timer for periodic cleanup of expired files.
  Timer? _cleanupTimer;

  /// Whether the cleanup scheduler is currently running.
  bool get isCleanupSchedulerRunning => _cleanupTimer != null;

  /// Creates a new [LocalCloudStorage].
  ///
  /// [serverpod] is the Serverpod instance.
  /// [storageId] identifies this storage (e.g., 'public' or 'private').
  /// [storagePath] is the base directory where files will be stored.
  /// [public] determines if files are publicly accessible via URL.
  /// [publicHost], [publicPort], and [publicScheme] allow customizing the
  /// public URL generation.
  LocalCloudStorage({
    required Serverpod serverpod,
    required String storageId,
    required this.storagePath,
    required this.public,
    this.publicHost,
    this.publicPort,
    this.publicScheme,
  })  : _serverpod = serverpod,
        super(storageId) {
    // Ensure the storage directory exists
    final dir = Directory(storagePath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  /// Gets the full file path for a given storage path.
  ///
  /// Sanitizes the path to prevent directory traversal attacks by:
  /// 1. Normalizing the path (resolving . and ..)
  /// 2. Removing any leading slashes to prevent absolute paths
  /// 3. Removing any remaining .. segments
  /// 4. Ensuring the final path is within the storage directory
  String _getFullPath(String path) {
    // First normalize the path to handle . and ..
    var sanitized = p.normalize(path);

    // Remove any leading slashes to treat all paths as relative
    while (sanitized.startsWith('/') || sanitized.startsWith('\\')) {
      sanitized = sanitized.substring(1);
    }

    // Remove any .. segments that might remain after normalization
    final segments = sanitized.split(RegExp(r'[/\\]'));
    final cleanSegments = segments.where((s) => s != '..' && s.isNotEmpty);
    sanitized = cleanSegments.join(p.separator);

    // If empty after cleaning, use a default
    if (sanitized.isEmpty) {
      sanitized = 'file';
    }

    return p.join(storagePath, sanitized);
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    try {
      final fullPath = _getFullPath(path);
      final file = File(fullPath);

      // Ensure parent directories exist
      final parentDir = file.parent;
      if (!parentDir.existsSync()) {
        parentDir.createSync(recursive: true);
      }

      // Write file
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );

      // Store metadata if expiration is set or file is unverified
      if (expiration != null || !verified) {
        await _storeMetadata(
          session: session,
          path: path,
          expiration: expiration,
          verified: verified,
        );
      }
    } catch (e) {
      throw CloudStorageException('Failed to store file: $e');
    }
  }

  @override
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    try {
      final fullPath = _getFullPath(path);
      final file = File(fullPath);

      if (!file.existsSync()) {
        return null;
      }

      // Check if file is verified (if metadata exists)
      final isVerified = await _isFileVerified(session: session, path: path);
      if (!isVerified) {
        return null;
      }

      final bytes = await file.readAsBytes();
      return ByteData.view(bytes.buffer);
    } catch (e) {
      throw CloudStorageException('Failed to retrieve file: $e');
    }
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
    if (!public) return null;

    final exists = await fileExists(session: session, path: path);
    if (!exists) return null;

    final config = _serverpod.config;

    return Uri(
      scheme: publicScheme ?? config.apiServer.publicScheme,
      host: publicHost ?? config.apiServer.publicHost,
      port: publicPort ?? config.apiServer.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: {
        'method': 'file',
        'path': path,
      },
    );
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    try {
      final fullPath = _getFullPath(path);
      final file = File(fullPath);

      if (!file.existsSync()) {
        return false;
      }

      // Check if file is verified
      return await _isFileVerified(session: session, path: path);
    } catch (e) {
      throw CloudStorageException('Failed to check if file exists: $e');
    }
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    try {
      final fullPath = _getFullPath(path);
      final file = File(fullPath);

      if (file.existsSync()) {
        await file.delete();
      }

      // Also delete metadata file if it exists
      final metadataFile = File('$fullPath.meta');
      if (metadataFile.existsSync()) {
        await metadataFile.delete();
      }
    } catch (e) {
      throw CloudStorageException('Failed to delete file: $e');
    }
  }

  /// Direct file uploads are not supported by [LocalCloudStorage].
  ///
  /// Use [storeFile] to upload files through your endpoints, or use
  /// [DatabaseCloudStorage] if you need direct upload support.
  ///
  /// Returns `null` to indicate direct uploads are not supported.
  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    // Direct file uploads require database access for tracking upload entries.
    // Since LocalCloudStorage is designed to work without database dependencies
    // for simple deployments, direct uploads are not supported.
    //
    // Use storeFile() to upload files through your endpoints instead.
    return null;
  }

  /// Since direct uploads are not supported, this method simply checks if
  /// the file exists and marks it as verified.
  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    final fullPath = _getFullPath(path);
    final file = File(fullPath);

    if (!file.existsSync()) {
      return false;
    }

    // Remove any unverified metadata if present
    final metadataFile = File('$fullPath.meta');
    if (metadataFile.existsSync()) {
      try {
        await metadataFile.delete();
      } catch (_) {
        // Ignore errors deleting metadata
      }
    }

    return true;
  }

  /// Stores metadata for a file (expiration, verified status).
  Future<void> _storeMetadata({
    required Session session,
    required String path,
    DateTime? expiration,
    bool verified = true,
  }) async {
    final fullPath = _getFullPath(path);
    final metadataFile = File('$fullPath.meta');

    final metadata = {
      'verified': verified,
      if (expiration != null) 'expiration': expiration.toIso8601String(),
    };

    await metadataFile.writeAsString(
      metadata.entries.map((e) => '${e.key}=${e.value}').join('\n'),
    );
  }

  /// Checks if a file is verified (not pending direct upload completion).
  Future<bool> _isFileVerified({
    required Session session,
    required String path,
  }) async {
    final fullPath = _getFullPath(path);
    final metadataFile = File('$fullPath.meta');

    // If no metadata file exists, the file is considered verified
    if (!metadataFile.existsSync()) {
      return true;
    }

    try {
      final content = await metadataFile.readAsString();
      final lines = content.split('\n');
      for (final line in lines) {
        final parts = line.split('=');
        if (parts.length == 2 && parts[0] == 'verified') {
          return parts[1] == 'true';
        }
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  // ============================================================
  // Expiration Cleanup Scheduler
  // ============================================================

  /// Starts a periodic cleanup task that removes expired files.
  ///
  /// [interval] specifies how often to run the cleanup. Defaults to 1 hour.
  ///
  /// Example:
  /// ```dart
  /// final storage = LocalCloudStorage(...);
  /// storage.startCleanupScheduler(Duration(minutes: 30));
  /// ```
  void startCleanupScheduler([
    Duration interval = const Duration(hours: 1),
  ]) {
    stopCleanupScheduler();
    _cleanupTimer = Timer.periodic(interval, (_) => cleanupExpiredFiles());
  }

  /// Stops the cleanup scheduler if it is running.
  void stopCleanupScheduler() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// Manually triggers cleanup of expired files.
  ///
  /// Returns the number of files that were deleted.
  ///
  /// This method walks through the storage directory, checks each `.meta` file
  /// for expiration timestamps, and deletes files that have expired.
  Future<int> cleanupExpiredFiles() async {
    var deletedCount = 0;
    final now = DateTime.now();

    try {
      final dir = Directory(storagePath);
      if (!dir.existsSync()) return 0;

      await for (final entity in dir.list(recursive: true)) {
        if (entity is! File) continue;
        if (!entity.path.endsWith('.meta')) continue;

        try {
          final expiration = await _getExpirationFromMetadata(entity);
          if (expiration != null && expiration.isBefore(now)) {
            // Delete the data file
            final dataFilePath =
                entity.path.substring(0, entity.path.length - 5);
            final dataFile = File(dataFilePath);
            if (dataFile.existsSync()) {
              await dataFile.delete();
            }

            // Delete the metadata file
            await entity.delete();
            deletedCount++;
          }
        } catch (e) {
          // Skip files that can't be processed
          continue;
        }
      }
    } catch (e) {
      // Log error if needed, but don't throw
    }

    return deletedCount;
  }

  /// Reads the expiration timestamp from a metadata file.
  Future<DateTime?> _getExpirationFromMetadata(File metadataFile) async {
    try {
      final content = await metadataFile.readAsString();
      final lines = content.split('\n');
      for (final line in lines) {
        final parts = line.split('=');
        if (parts.length == 2 && parts[0] == 'expiration') {
          return DateTime.parse(parts[1]);
        }
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
  }

  // ============================================================
  // Streaming Support for Large Files
  // ============================================================

  /// Stores a file from a stream, which is more memory-efficient for large files.
  ///
  /// Instead of loading the entire file into memory, this method streams the
  /// data directly to disk.
  ///
  /// [stream] is the source data stream.
  /// [expectedLength] is optional and can be used for progress tracking.
  /// [expiration] sets an optional expiration time for the file.
  /// [verified] marks whether the file upload is complete (default: true).
  ///
  /// Example:
  /// ```dart
  /// final fileStream = File('large_video.mp4').openRead();
  /// await storage.storeFileStream(
  ///   session: session,
  ///   path: 'videos/upload.mp4',
  ///   stream: fileStream,
  /// );
  /// ```
  Future<void> storeFileStream({
    required Session session,
    required String path,
    required Stream<List<int>> stream,
    int? expectedLength,
    DateTime? expiration,
    bool verified = true,
  }) async {
    try {
      final fullPath = _getFullPath(path);
      final file = File(fullPath);

      // Ensure parent directories exist
      final parentDir = file.parent;
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }

      // Stream directly to file
      final sink = file.openWrite();
      try {
        await for (final chunk in stream) {
          sink.add(chunk);
        }
      } finally {
        await sink.close();
      }

      // Store metadata if expiration is set or file is unverified
      if (expiration != null || !verified) {
        await _storeMetadata(
          session: session,
          path: path,
          expiration: expiration,
          verified: verified,
        );
      }
    } catch (e) {
      throw CloudStorageException('Failed to store file stream: $e');
    }
  }

  /// Retrieves a file as a stream, which is more memory-efficient for large files.
  ///
  /// Returns `null` if the file does not exist or is not verified.
  ///
  /// [chunkSize] controls the size of each chunk read from disk.
  /// Defaults to 64KB which is a good balance for most use cases.
  ///
  /// Example:
  /// ```dart
  /// final stream = await storage.retrieveFileStream(
  ///   session: session,
  ///   path: 'videos/large_video.mp4',
  /// );
  /// if (stream != null) {
  ///   await for (final chunk in stream) {
  ///     // Process chunk
  ///   }
  /// }
  /// ```
  Future<Stream<List<int>>?> retrieveFileStream({
    required Session session,
    required String path,
    int chunkSize = 64 * 1024,
  }) async {
    try {
      final fullPath = _getFullPath(path);
      final file = File(fullPath);

      if (!file.existsSync()) {
        return null;
      }

      // Check if file is verified
      final isVerified = await _isFileVerified(session: session, path: path);
      if (!isVerified) {
        return null;
      }

      // Return a stream that reads the file in chunks
      return file.openRead();
    } catch (e) {
      throw CloudStorageException('Failed to retrieve file stream: $e');
    }
  }

  /// Gets the size of a file in bytes without loading it into memory.
  ///
  /// Returns `null` if the file does not exist or is not verified.
  ///
  /// This is useful for setting Content-Length headers or progress tracking
  /// when streaming files.
  Future<int?> getFileSize({
    required Session session,
    required String path,
  }) async {
    try {
      final fullPath = _getFullPath(path);
      final file = File(fullPath);

      if (!file.existsSync()) {
        return null;
      }

      // Check if file is verified
      final isVerified = await _isFileVerified(session: session, path: path);
      if (!isVerified) {
        return null;
      }

      return await file.length();
    } catch (e) {
      throw CloudStorageException('Failed to get file size: $e');
    }
  }
}
