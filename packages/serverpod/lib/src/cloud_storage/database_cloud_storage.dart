import 'dart:typed_data';

import '../../serverpod.dart';
import '../generated/cloud_storage.dart';
import '../generated/cloud_storage_direct_upload.dart';
import '../util/random.dart';

/// The [DatabaseCloudStorage] uses the standard Serverpod database to store
/// binary files. It's the default [CloudStorage] interface of Serverpod, but
/// you may want to replace it with a more robust service depending on your
/// needs, especially in your production environment.
class DatabaseCloudStorage extends CloudStorage {
  /// Creates a new [DatabaseCloudStorage].
  DatabaseCloudStorage(super.storageId);

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    try {
      await session.db.delete<CloudStorageEntry>(
        where: CloudStorageEntry.t.storageId.equals(storageId) &
            CloudStorageEntry.t.path.equals(path),
      );
    } catch (e) {
      throw CloudStorageException('Failed to delete file. ($e)');
    }
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    try {
      final numRows = await session.db.count<CloudStorageEntry>(
        where: CloudStorageEntry.t.storageId.equals(storageId) &
            CloudStorageEntry.t.path.equals(path),
      );
      return numRows > 0;
    } catch (e) {
      throw CloudStorageException('Failed to check if file exists. ($e)');
    }
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
    if (storageId != 'public') return null;

    final exists = await fileExists(session: session, path: path);
    if (!exists) return null;

    final config = session.server.serverpod.config;

    return Uri(
      scheme: config.apiServer.publicScheme,
      host: config.apiServer.publicHost,
      port: config.apiServer.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: <String, dynamic>{
        'method': 'file',
        'path': path,
      },
    );
  }

  @override
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    try {
      return await session.db.retrieveFile(storageId, path);
    } catch (e) {
      throw CloudStorageException('Failed to retrieve file. ($e)');
    }
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
      await session.db
          .storeFile(storageId, path, byteData, expiration, verified);
    } catch (e) {
      throw CloudStorageException('Failed to store file. ($e)');
    }
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
  }) async {
    final config = session.server.serverpod.config;

    final expiration = DateTime.now().add(expirationDuration);

    final authKey = generateString();

    final uploadEntry = CloudStorageDirectUploadEntry(
      storageId: storageId,
      path: path,
      expiration: expiration,
      authKey: authKey,
    );
    await session.db.insert(uploadEntry);
    if (uploadEntry.id == null) return null;

    final uri = Uri(
      scheme: config.apiServer.publicScheme,
      host: config.apiServer.publicHost,
      port: config.apiServer.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: <String, dynamic>{
        'method': 'upload',
        'storage': storageId,
        'path': path,
        'key': uploadEntry.authKey,
      },
    );

    final uploadDescriptionData = {
      'url': uri.toString(),
      'type': 'binary',
    };

    return SerializationManager.encode(uploadDescriptionData);
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return session.db.verifyFile(storageId, path);
  }
}
