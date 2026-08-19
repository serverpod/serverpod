import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

/// A [CloudStorage] implementation that stores files on the server's local
/// filesystem.
///
/// This storage requires no external services and no database tables, which
/// makes it suitable for development, testing, and self-hosted deployments
/// where files should live on the server itself.
///
/// Files are stored under [storagePath]. Expiration time and verification
/// state are kept in a `.meta` sidecar file next to the stored file; files
/// without a sidecar are treated as verified and non-expiring. Paths ending
/// in `.meta` (in any casing) are therefore reserved and rejected.
///
/// File paths are normalized before use: backslashes are treated as path
/// separators, absolute paths are made relative to the storage directory,
/// and paths that would escape the storage directory are rejected with a
/// [CloudStorageException]. Path segments containing ':' or ending in '.'
/// or ' ' are rejected as well, since they collide or misbehave on some
/// filesystems.
///
/// The storage directory must not be writable by untrusted processes;
/// symbolic links inside it are followed by the operating system.
///
/// If the storage is registered with the storage id 'public', files are
/// served through the server's built-in `/serverpod_cloud_storage` endpoint,
/// just like the default [DatabaseCloudStorage]. Note that Serverpod
/// currently registers that endpoint only if a [DatabaseCloudStorage] is
/// also registered, which is the case unless the default 'private' storage
/// is replaced or the database feature is disabled.
///
/// Direct file uploads are not supported, as they require database backed
/// upload tracking. [createDirectFileUploadDescription] returns null; store
/// uploaded data through an endpoint with `session.storage.storeFile`
/// instead.
class LocalCloudStorage extends CloudStorage with CloudStorageWithOptions {
  /// The base directory on the local filesystem where files are stored.
  final String storagePath;

  Timer? _cleanupTimer;
  bool _cleanupInProgress = false;

  static const _metadataSuffix = '.meta';

  /// Creates a new [LocalCloudStorage].
  ///
  /// [storageId] identifies this storage (e.g. 'public' or 'private').
  /// [storagePath] is the base directory where files are stored. The
  /// directory is created on first write if it does not exist.
  LocalCloudStorage(super.storageId, {required this.storagePath});

  /// Resolves a storage [path] to a path inside [storagePath].
  ///
  /// Throws a [CloudStorageException] if the path resolves to the storage
  /// root, attempts to escape the storage directory, contains segments that
  /// are unsafe on some filesystems, or uses the reserved `.meta` suffix.
  String _resolveFilePath(String path) {
    // Treat backslashes as path separators, so that traversal attempts like
    // 'foo\..\bar' behave the same on all platforms.
    var sanitized = p.posix.normalize(path.replaceAll(r'\', '/'));

    var root = p.posix.rootPrefix(sanitized);
    if (root.isNotEmpty) {
      sanitized = p.posix.relative(sanitized, from: root);
    }

    if (sanitized == '.') {
      throw CloudStorageException(
        'Invalid file path. ("$path" resolves to the storage root)',
      );
    }

    var segments = p.posix.split(sanitized);
    // Normalizing resolves '..' segments against the segments preceding
    // them, but keeps leading '..' segments, which would escape the storage
    // directory.
    if (segments.contains('..')) {
      throw CloudStorageException(
        'Invalid file path. ("$path" escapes the storage directory)',
      );
    }
    for (var segment in segments) {
      // Reject segment forms that collide or misbehave on some filesystems:
      // ':' is used by Windows drive letters and NTFS alternate data
      // streams, and Windows strips trailing dots and spaces, which would
      // let 'file.meta.' alias an internal 'file.meta' sidecar.
      if (segment.contains(':') ||
          segment.endsWith('.') ||
          segment.endsWith(' ')) {
        throw CloudStorageException(
          'Invalid file path. (segment "$segment" in "$path" is not '
          'supported)',
        );
      }
      // Checked in any casing, since 'FILE.META' and 'file.meta' are the
      // same file on case insensitive filesystems.
      if (segment.toLowerCase().endsWith(_metadataSuffix)) {
        throw CloudStorageException(
          'Invalid file path. (the "$_metadataSuffix" suffix is reserved '
          'for internal metadata files)',
        );
      }
    }

    var fullPath = p.join(storagePath, p.joinAll(segments));
    if (!p.isWithin(storagePath, fullPath)) {
      // Reachable on Windows, where drive qualified segments are not
      // recognized as roots by the posix based sanitization above and can
      // produce an absolute path when joined. This guard is load bearing,
      // not just defense in depth.
      throw CloudStorageException(
        'Invalid file path. ("$path" escapes the storage directory)',
      );
    }
    return fullPath;
  }

  File _metadataFile(String fullPath) => File('$fullPath$_metadataSuffix');

  /// Writes or removes the metadata sidecar file for [fullPath].
  ///
  /// Metadata is only kept for files that have an expiration time or are not
  /// yet verified; otherwise any stale metadata from a previous store of the
  /// same path is removed.
  Future<void> _writeMetadata(
    String fullPath, {
    DateTime? expiration,
    required bool verified,
  }) async {
    var metadataFile = _metadataFile(fullPath);
    if (expiration == null && verified) {
      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }
      return;
    }
    await metadataFile.writeAsString(
      jsonEncode({
        'verified': verified,
        if (expiration != null)
          'expiration': expiration.toUtc().toIso8601String(),
      }),
    );
  }

  /// Reads the metadata sidecar for [fullPath], or returns null if none
  /// exists.
  ///
  /// Returns an unverified entry if the metadata cannot be read or parsed,
  /// so that corrupt metadata never exposes a potentially unverified file.
  Future<({bool verified, DateTime? expiration})?> _readMetadata(
    String fullPath,
  ) async {
    var metadataFile = _metadataFile(fullPath);
    if (!await metadataFile.exists()) return null;
    try {
      var metadata = jsonDecode(await metadataFile.readAsString());
      if (metadata is! Map<String, dynamic>) {
        return (verified: false, expiration: null);
      }
      var verified = metadata['verified'];
      var expiration = metadata['expiration'];
      if (verified is! bool || (expiration != null && expiration is! String)) {
        return (verified: false, expiration: null);
      }
      return (
        verified: verified,
        expiration: expiration is String ? DateTime.parse(expiration) : null,
      );
    } catch (_) {
      return (verified: false, expiration: null);
    }
  }

  /// Whether the file at [fullPath] exists, is verified, and has not
  /// expired.
  Future<bool> _isAvailable(String fullPath) async {
    if (!await File(fullPath).exists()) return false;
    var metadata = await _readMetadata(fullPath);
    if (metadata == null) return true;
    if (!metadata.verified) return false;
    var expiration = metadata.expiration;
    return expiration == null || expiration.isAfter(DateTime.now().toUtc());
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    var fullPath = _resolveFilePath(path);
    try {
      var file = File(fullPath);
      await file.parent.create(recursive: true);

      // Write the metadata sidecar before the data file, so that a failure
      // between the two writes can never expose an unverified or expiring
      // file as a verified, non-expiring one. For plain stores the sidecar
      // is instead removed after the data write, so that a failure keeps
      // any stale restrictions rather than lifting them.
      var keepsMetadata = expiration != null || !verified;
      if (keepsMetadata) {
        await _writeMetadata(
          fullPath,
          expiration: expiration,
          verified: verified,
        );
      }
      try {
        await file.writeAsBytes(Uint8List.sublistView(byteData));
      } catch (_) {
        await _cleanUpFailedStore(fullPath);
        rethrow;
      }
      if (!keepsMetadata) {
        await _writeMetadata(fullPath, expiration: null, verified: true);
      }
    } catch (e) {
      throw CloudStorageException('Failed to store file. ($e)');
    }
  }

  /// Best effort removal of the data file and metadata sidecar after a
  /// failed store, so that no partial file is left behind that would be
  /// served as verified content.
  Future<void> _cleanUpFailedStore(String fullPath) async {
    try {
      var file = File(fullPath);
      if (await file.exists()) {
        await file.delete();
      }
      var metadataFile = _metadataFile(fullPath);
      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }
    } on FileSystemException {
      // Keep the original error.
    }
  }

  @override
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    var fullPath = _resolveFilePath(path);
    try {
      if (!await _isAvailable(fullPath)) return null;
      var bytes = await File(fullPath).readAsBytes();
      return ByteData.sublistView(bytes);
    } catch (e) {
      throw CloudStorageException('Failed to retrieve file. ($e)');
    }
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
    if (storageId != 'public') return null;

    var exists = await fileExists(session: session, path: path);
    if (!exists) return null;

    var config = session.server.serverpod.config;

    return Uri(
      scheme: config.apiServer.publicScheme,
      host: config.apiServer.publicHost,
      port: config.apiServer.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: {
        'method': 'file',
        'path': path,
      },
    );
  }

  /// Whether a file is available at [path].
  ///
  /// Returns false for files that have expired or are not verified, since
  /// those are not retrievable. Note that this is stricter than
  /// [DatabaseCloudStorage], which reports unverified files as existing;
  /// consequently, storing with `preventOverwrite` replaces expired and
  /// unverified files.
  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    var fullPath = _resolveFilePath(path);
    try {
      return await _isAvailable(fullPath);
    } catch (e) {
      throw CloudStorageException('Failed to check if file exists. ($e)');
    }
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    var fullPath = _resolveFilePath(path);
    try {
      var file = File(fullPath);
      if (await file.exists()) {
        await file.delete();
      }
      var metadataFile = _metadataFile(fullPath);
      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }
    } catch (e) {
      throw CloudStorageException('Failed to delete file. ($e)');
    }
  }

  /// Direct file uploads are not supported by [LocalCloudStorage], since
  /// they require database backed tracking of upload entries.
  ///
  /// Always returns null. Store uploaded data through an endpoint with
  /// `session.storage.storeFile` instead, or use [DatabaseCloudStorage] if
  /// direct uploads are needed.
  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return null;
  }

  /// Verifies a file that was stored with `verified: false`.
  ///
  /// Returns true if the file existed and was pending verification, in which
  /// case it is marked as verified and its expiration time is retained.
  /// Returns false if the file does not exist or was already verified.
  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    var fullPath = _resolveFilePath(path);
    try {
      if (!await File(fullPath).exists()) return false;
      var metadata = await _readMetadata(fullPath);
      if (metadata == null || metadata.verified) return false;
      await _writeMetadata(
        fullPath,
        expiration: metadata.expiration,
        verified: true,
      );
      return true;
    } catch (e) {
      throw CloudStorageException('Failed to verify file upload. ($e)');
    }
  }

  @override
  Future<void> storeFileWithOptions({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
    required CloudStorageOptions options,
  }) async {
    if (options.preventOverwrite) {
      final exists = await fileExists(session: session, path: path);
      if (exists) {
        throw CloudStorageException(
          'File already exists at path "$path" and preventOverwrite is '
          'enabled.',
        );
      }
    }

    await storeFile(
      session: session,
      path: path,
      byteData: byteData,
      expiration: expiration,
      verified: verified,
    );
  }

  @override
  Future<String?> createDirectFileUploadDescriptionWithOptions({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
    required CloudStorageOptions options,
  }) async {
    if (options.contentLength != null && options.contentLength! > maxFileSize) {
      throw CloudStorageException(
        'Content length (${options.contentLength} bytes) exceeds maximum '
        'file size ($maxFileSize bytes).',
      );
    }
    return createDirectFileUploadDescription(
      session: session,
      path: path,
      expirationDuration: expirationDuration,
      maxFileSize: maxFileSize,
    );
  }

  /// Stores a file from [stream], without buffering the contents in memory.
  ///
  /// This is not part of the [CloudStorage] interface, but is useful when
  /// handling large files on the local filesystem.
  Future<void> storeFileStream({
    required Session session,
    required String path,
    required Stream<List<int>> stream,
    DateTime? expiration,
    bool verified = true,
  }) async {
    var fullPath = _resolveFilePath(path);
    try {
      var file = File(fullPath);
      await file.parent.create(recursive: true);

      // See storeFile for the rationale behind the write ordering.
      var keepsMetadata = expiration != null || !verified;
      if (keepsMetadata) {
        await _writeMetadata(
          fullPath,
          expiration: expiration,
          verified: verified,
        );
      }
      try {
        var sink = file.openWrite();
        try {
          await sink.addStream(stream);
        } finally {
          await sink.close();
        }
      } catch (_) {
        await _cleanUpFailedStore(fullPath);
        rethrow;
      }
      if (!keepsMetadata) {
        await _writeMetadata(fullPath, expiration: null, verified: true);
      }
    } catch (e) {
      throw CloudStorageException('Failed to store file stream. ($e)');
    }
  }

  /// Retrieves a file as a stream, without buffering the contents in memory.
  ///
  /// Returns null if the file does not exist, has expired, or is not
  /// verified.
  Future<Stream<List<int>>?> retrieveFileStream({
    required Session session,
    required String path,
  }) async {
    var fullPath = _resolveFilePath(path);
    try {
      if (!await _isAvailable(fullPath)) return null;
      return File(fullPath).openRead();
    } catch (e) {
      throw CloudStorageException('Failed to retrieve file stream. ($e)');
    }
  }

  /// Returns the size in bytes of the file at [path].
  ///
  /// Returns null if the file does not exist, has expired, or is not
  /// verified.
  Future<int?> getFileSize({
    required Session session,
    required String path,
  }) async {
    var fullPath = _resolveFilePath(path);
    try {
      if (!await _isAvailable(fullPath)) return null;
      return await File(fullPath).length();
    } catch (e) {
      throw CloudStorageException('Failed to get file size. ($e)');
    }
  }

  /// Whether the cleanup scheduler is currently running.
  bool get isCleanupSchedulerRunning => _cleanupTimer != null;

  /// Starts periodically deleting expired files.
  ///
  /// Once their expiration time passes, files are hidden from all retrieval
  /// methods but stay on disk until a cleanup run removes them. A cleanup
  /// run is skipped if the previous run is still in progress.
  void startCleanupScheduler([Duration interval = const Duration(hours: 1)]) {
    stopCleanupScheduler();
    _cleanupTimer = Timer.periodic(
      interval,
      (_) => unawaited(cleanupExpiredFiles()),
    );
  }

  /// Stops the cleanup scheduler if it is running.
  void stopCleanupScheduler() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// Deletes all expired files and their metadata.
  ///
  /// Returns the number of deleted files. Files that cannot be processed
  /// are skipped and retried on the next run.
  Future<int> cleanupExpiredFiles() async {
    if (_cleanupInProgress) return 0;
    _cleanupInProgress = true;
    try {
      var directory = Directory(storagePath);
      if (!await directory.exists()) return 0;

      var deletedCount = 0;
      var now = DateTime.now().toUtc();

      try {
        await for (var entity in directory.list(recursive: true)) {
          if (entity is! File || !entity.path.endsWith(_metadataSuffix)) {
            continue;
          }
          try {
            var dataFilePath = entity.path.substring(
              0,
              entity.path.length - _metadataSuffix.length,
            );
            var metadata = await _readMetadata(dataFilePath);
            var expiration = metadata?.expiration;
            if (expiration == null || expiration.isAfter(now)) continue;

            var dataFile = File(dataFilePath);
            if (await dataFile.exists()) {
              await dataFile.delete();
              deletedCount++;
            }
            await entity.delete();
          } catch (_) {
            // Skip files that cannot be processed; they are retried on the
            // next cleanup run.
            continue;
          }
        }
      } catch (_) {
        // The directory listing itself can fail, e.g. when a directory is
        // removed while it is being listed. Never let an error escape to
        // the periodic timer, where it would be an unhandled async error;
        // remaining files are retried on the next run.
      }
      return deletedCount;
    } finally {
      _cleanupInProgress = false;
    }
  }
}
