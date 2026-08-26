import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/cloud_storage.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_download.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_upload.dart';

/// The [DatabaseCloudStorage] uses the standard Serverpod database to store
/// binary files. It's the default [CloudStorage] interface of Serverpod, but
/// you may want to replace it with a more robust service depending on your
/// needs, especially in your production environment.
class DatabaseCloudStorage extends CloudStorage {
  /// Creates a new [DatabaseCloudStorage].
  DatabaseCloudStorage(super.storageId);

  /// Serializes best-effort deletion of expired temporary download
  /// authorizations so scheduled cleanup tasks do not overlap with each other.
  Future<void> _temporaryDownloadDeletionQueue = Future.value();

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    try {
      await CloudStorageEntry.db.deleteWhere(
        session,
        where: (t) => t.storageId.equals(storageId) & t.path.equals(path),
      );
    } catch (e) {
      throw CloudStorageException('Failed to delete file. ($e)');
    }
  }

  @override
  Future<ByteData> retrieveFile({
    required Session session,
    required String path,
  }) async {
    final entry = await _findAvailableEntry(session, path);
    if (entry == null) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }
    return entry.byteData;
  }

  /// Retrieves a file and its metadata.
  ///
  /// This method is used by Serverpod's built-in cloud storage endpoint to
  /// avoid loading the stored file into memory once for [retrieveFile] and
  /// again for [statFile].
  /// Application code should normally use those methods directly.
  Future<({ByteData file, FileStat stat})> retrieveFileWithStat({
    required Session session,
    required String path,
  }) async {
    final entry = await _findAvailableEntry(session, path);
    if (entry == null) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }

    return (file: entry.byteData, stat: _fileStat(entry));
  }

  @override
  Future<FileStat> statFile({
    required Session session,
    required String path,
  }) async {
    final entry = await _findAvailableEntry(session, path);
    if (entry == null) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }

    return _fileStat(entry);
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    final now = DateTime.now().toUtc();
    try {
      final count = await CloudStorageEntry.db.count(
        session,
        where: (t) =>
            t.storageId.equals(storageId) &
            t.path.equals(path) &
            t.verified.equals(true) &
            (t.expiration.equals(null) | (t.expiration > now)),
        limit: 1,
      );
      return count > 0;
    } catch (error) {
      throw CloudStorageException('Failed to check if file exists. ($error)');
    }
  }

  @override
  Future<Uri> publicDownloadUrl({
    required Session session,
    required String path,
  }) async {
    if (storageId != 'public') {
      throw CloudStorageUnsupportedOperationException(
        storageId: storageId,
        operation: 'public download URLs',
      );
    }

    final exists = await fileExists(session: session, path: path);
    if (!exists) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }
    return _endpointUri(session, {'method': 'file', 'path': path});
  }

  @override
  Future<Uri> temporaryDownloadUrl({
    required Session session,
    required String path,
    TemporaryDownloadUrlOptions options = const TemporaryDownloadUrlOptions(),
  }) async {
    options.validate();
    final exists = await fileExists(session: session, path: path);
    if (!exists) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }

    final entry = CloudStorageDirectDownloadEntry(
      storageId: storageId,
      path: path,
      expiration: DateTime.now().toUtc().add(options.expirationDuration),
      authKey: _generateAuthKey(),
      downloadFileName: options.downloadFileName,
      contentType: options.contentType,
    );

    late CloudStorageDirectDownloadEntry inserted;

    try {
      inserted = await CloudStorageDirectDownloadEntry.db.insertRow(
        session,
        entry,
      );
    } catch (error) {
      throw CloudStorageException(
        'Failed to create a temporary download URL. ($error)',
      );
    }

    _scheduleTemporaryDownloadDeletion(
      session: session,
      delay: options.expirationDuration,
      delete: () async {
        await CloudStorageDirectDownloadEntry.db.deleteWhere(
          session,
          where: (t) =>
              t.storageId.equals(inserted.storageId) &
              t.path.equals(inserted.path) &
              t.authKey.equals(inserted.authKey),
          noReturn: true,
        );
      },
    );

    return _endpointUri(session, {
      'method': 'temporaryFile',
      'storage': storageId,
      'path': path,
      'key': inserted.authKey,
    });
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    StoreFileOptions options = const StoreFileOptions(),
  }) => _storeFile(
    session: session,
    path: path,
    byteData: byteData,
    verified: true,
    options: options,
  );

  /// Stores a file that remains inaccessible until [verifyUpload] succeeds.
  ///
  /// This method is used by Serverpod's built-in upload endpoint. Application
  /// code should normally use [storeFile].
  Future<void> storeUnverifiedFile({
    required Session session,
    required String path,
    required ByteData byteData,
    StoreFileOptions options = const StoreFileOptions(),
  }) => _storeFile(
    session: session,
    path: path,
    byteData: byteData,
    verified: false,
    options: options,
  );

  Future<void> _storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    required bool verified,
    required StoreFileOptions options,
  }) async {
    final metadata = options.metadata;
    final entry = CloudStorageEntry(
      storageId: storageId,
      path: path,
      addedTime: DateTime.now().toUtc(),
      expiration: options.expiration?.toUtc(),
      byteData: byteData,
      verified: verified,
      contentType: metadata.contentType,
      cacheControl: metadata.cacheControl,
      contentDisposition: metadata.contentDisposition,
      contentEncoding: metadata.contentEncoding,
      customMetadata: _encodeCustomMetadata(metadata.custom),
    );

    try {
      final stored = await CloudStorageEntry.db.upsertRow(
        session,
        entry,
        conflictColumns: (t) => [t.storageId, t.path],
        updateWhere: options.preventOverwrite
            ? (_) => Constant.bool(false)
            : null,
      );
      if (stored == null) {
        throw CloudStorageFileAlreadyExistsException(
          storageId: storageId,
          path: path,
        );
      }
    } on CloudStorageException {
      rethrow;
    } catch (error) {
      throw CloudStorageException('Failed to store file. ($error)');
    }
  }

  @override
  Future<UploadDescription> createUploadDescription({
    required Session session,
    required String path,
    UploadOptions options = const UploadOptions(),
  }) async {
    options.validate();
    final metadata = options.metadata;
    final uploadEntry = CloudStorageDirectUploadEntry(
      storageId: storageId,
      path: path,
      expiration: DateTime.now().toUtc().add(options.expirationDuration),
      authKey: _generateAuthKey(),
      maxFileSize: options.maxFileSize,
      contentLength: options.contentLength,
      preventOverwrite: options.preventOverwrite,
      contentType: metadata.contentType,
      cacheControl: metadata.cacheControl,
      contentDisposition: metadata.contentDisposition,
      contentEncoding: metadata.contentEncoding,
      customMetadata: _encodeCustomMetadata(metadata.custom),
    );
    CloudStorageDirectUploadEntry? inserted;
    try {
      inserted = await CloudStorageDirectUploadEntry.db.upsertRow(
        session,
        uploadEntry,
        conflictColumns: (t) => [t.storageId, t.path],
      );
    } catch (error) {
      throw CloudStorageException(
        'Failed to create an upload description. ($error)',
      );
    }
    if (inserted == null) {
      throw CloudStorageException('Failed to create an upload description.');
    }

    return BinaryUploadDescription(
      url: _endpointUri(session, {
        'method': 'upload',
        'storage': storageId,
        'path': path,
        'key': inserted.authKey,
      }),
      fileName: path.split('/').last,
    );
  }

  @override
  Future<bool> verifyUpload({
    required Session session,
    required String path,
  }) async {
    final now = DateTime.now().toUtc();
    try {
      final updated = await CloudStorageEntry.db.updateWhere(
        session,
        columnValues: (t) => [t.verified(true)],
        where: (t) =>
            t.storageId.equals(storageId) &
            t.path.equals(path) &
            t.verified.equals(false) &
            (t.expiration.equals(null) | (t.expiration > now)),
      );
      return updated.isNotEmpty;
    } catch (e) {
      throw CloudStorageException('Failed to verify upload. ($e)');
    }
  }

  Future<CloudStorageEntry?> _findAvailableEntry(
    Session session,
    String path,
  ) async {
    final now = DateTime.now().toUtc();
    try {
      return await CloudStorageEntry.db.findFirstRow(
        session,
        where: (t) =>
            t.storageId.equals(storageId) &
            t.path.equals(path) &
            t.verified.equals(true) &
            (t.expiration.equals(null) | (t.expiration > now)),
      );
    } catch (e) {
      throw CloudStorageException('Failed to retrieve file. ($e)');
    }
  }

  Uri _endpointUri(Session session, Map<String, String> queryParameters) {
    final config = session.server.serverpod.config.apiServer;
    return Uri(
      scheme: config.publicScheme,
      host: config.publicHost,
      port: config.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: queryParameters,
    );
  }

  static String? _encodeCustomMetadata(Map<String, String> metadata) =>
      metadata.isEmpty ? null : jsonEncode(metadata);

  static Map<String, String> _decodeCustomMetadata(String? metadata) {
    if (metadata == null) return const {};
    final decoded = jsonDecode(metadata);
    if (decoded is! Map) return const {};
    return {
      for (final entry in decoded.entries)
        if (entry.key is String && entry.value is String)
          entry.key as String: entry.value as String,
    };
  }

  FileStat _fileStat(CloudStorageEntry entry) {
    return FileStat(
      size: entry.byteData.lengthInBytes,
      lastModified: entry.addedTime,
      contentType: entry.contentType,
      cacheControl: entry.cacheControl,
      contentDisposition: entry.contentDisposition,
      contentEncoding: entry.contentEncoding,
      custom: _decodeCustomMetadata(entry.customMetadata),
    );
  }

  void _scheduleTemporaryDownloadDeletion({
    required Session session,
    required Duration delay,
    required Future<void> Function() delete,
  }) {
    Timer(delay, () {
      _temporaryDownloadDeletionQueue = _temporaryDownloadDeletionQueue.then((
        _,
      ) async {
        try {
          await delete();
        } catch (error) {
          session.server.serverpod.logVerbose(
            'Failed to delete an expired temporary download authorization. '
            '($error)',
          );
        }
      });
    });
  }

  static String _generateAuthKey() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        16,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
