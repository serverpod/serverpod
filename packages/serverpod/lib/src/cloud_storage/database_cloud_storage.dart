import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/src/generated/cloud_storage.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_upload.dart';
import 'package:serverpod/src/server/session.dart';

import 'cloud_storage.dart';

/// The [DatabaseCloudStorage] uses the standard Serverpod database to store
/// binary files. It's the default [CloudStorage] interface of Serverpod, but
/// you may want to replace it with a more robust service depending on your
/// needs, especially in your production environment.
class DatabaseCloudStorage extends CloudStorage {
  /// Creates a new [DatabaseCloudStorage].
  DatabaseCloudStorage(String storageId) : super(storageId);

  @override
  Future<void> deleteFile(
      {required Session session, required String path}) async {
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
  Future<bool> fileExists(
      {required Session session, required String path}) async {
    try {
      var numRows = await session.db.count<CloudStorageEntry>(
        where: CloudStorageEntry.t.storageId.equals(storageId) &
            CloudStorageEntry.t.path.equals(path),
      );
      return (numRows > 0);
    } catch (e) {
      throw CloudStorageException('Failed to check if file exists. ($e)');
    }
  }

  @override
  Future<Uri?> getPublicUrl(
      {required Session session, required String path}) async {
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

  @override
  Future<ByteData?> retrieveFile(
      {required Session session, required String path}) async {
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
    var config = session.server.serverpod.config;

    var expiration = DateTime.now().add(expirationDuration);

    var uploadEntry = CloudStorageDirectUploadEntry(
      storageId: storageId,
      path: path,
      expiration: expiration,
      authKey: _generateAuthKey(),
    );
    await session.db.insert(uploadEntry);
    if (uploadEntry.id == null) return null;

    var uri = Uri(
      scheme: config.apiServer.publicScheme,
      host: config.apiServer.publicHost,
      port: config.apiServer.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: {
        'method': 'upload',
        'storage': storageId,
        'path': path,
        'key': uploadEntry.authKey,
      },
    );

    var uploadDescriptionData = {
      'url': uri.toString(),
      'type': 'binary',
    };

    return jsonEncode(uploadDescriptionData);
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return await session.db.verifyFile(storageId, path);
  }

  static String _generateAuthKey() {
    const len = 16;
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
