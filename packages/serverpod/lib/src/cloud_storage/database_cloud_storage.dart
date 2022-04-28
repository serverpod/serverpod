import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import '../generated/cloud_storage.dart';
import '../generated/cloud_storage_direct_upload.dart';
import '../server/session.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

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
      int numRows = await session.db.count<CloudStorageEntry>(
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

    bool exists = await fileExists(session: session, path: path);
    if (!exists) return null;

    ServerConfig config = session.server.serverpod.config;

    return Uri(
      scheme: config.publicScheme,
      host: config.publicHost,
      port: config.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: <String, dynamic>{
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
    ServerConfig config = session.server.serverpod.config;

    DateTime expiration = DateTime.now().add(expirationDuration);

    CloudStorageDirectUploadEntry uploadEntry = CloudStorageDirectUploadEntry(
      storageId: storageId,
      path: path,
      expiration: expiration,
      authKey: _generateAuthKey(),
    );
    await session.db.insert(uploadEntry);
    if (uploadEntry.id == null) return null;

    Uri uri = Uri(
      scheme: config.publicScheme,
      host: config.publicHost,
      port: config.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: <String, dynamic>{
        'method': 'upload',
        'storage': storageId,
        'path': path,
        'key': uploadEntry.authKey,
      },
    );

    Map<String, String> uploadDescriptionData = <String, String>{
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
    const int len = 16;
    const String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable<int>.generate(
        len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
