import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/cloud_storage.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_upload.dart';
import 'package:serverpod/src/service/service_manager.dart';

/// The [DatabaseCloudStorage] uses the standard Serverpod database to store
/// binary files. It's the default [CloudStorage] interface of Serverpod, but
/// you may want to replace it with a more robust service depending on your
/// needs, especially in your production environment.
class DatabaseCloudStorage extends CloudStorage {
  /// Creates a new [DatabaseCloudStorage].
  DatabaseCloudStorage(super.storageId);

  @override
  Future<void> deleteFile(
      {required ServiceLocator serviceLocator, required String path}) async {
    try {
      Database db = serviceLocator.locate<Database>()!;
      await db.deleteWhere<CloudStorageEntry>(
        where: CloudStorageEntry.t.storageId.equals(storageId) &
            CloudStorageEntry.t.path.equals(path),
      );
    } catch (e) {
      throw CloudStorageException('Failed to delete file. ($e)');
    }
  }

  @override
  Future<bool> fileExists(
      {required ServiceLocator serviceLocator, required String path}) async {
    try {
      Database db = serviceLocator.locate<Database>()!;
      var numRows = await db.count<CloudStorageEntry>(
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
      {required ServiceLocator serviceLocator, required String path}) async {
    if (storageId != 'public') return null;

    var exists = await fileExists(serviceLocator: serviceLocator, path: path);
    if (!exists) return null;

    ServerpodConfig config = serviceLocator.locate<ServerpodConfig>()!;

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
  Future<ByteData?> retrieveFile({
    required ServiceLocator serviceLocator,
    required String path,
  }) async {
    var query =
        'SELECT encode("byteData", \'base64\') AS "encoded" FROM serverpod_cloud_storage WHERE "storageId"=${EscapedExpression(storageId)} AND path=${EscapedExpression(path)} AND verified=${EscapedExpression(true)}';

    try {
      Database db = serviceLocator.locate<Database>()!;
      var result = await db.unsafeQuery(query);
      if (result.isNotEmpty) {
        var encoded = (result.first.first as String).replaceAll('\n', '');
        return ByteData.view(base64Decode(encoded).buffer);
      }
    } catch (e) {
      throw CloudStorageException('Failed to retrieve file. ($e)');
    }

    return null;
  }

  @override
  Future<void> storeFile({
    required ServiceLocator serviceLocator,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    var addedTime = DateTime.now().toUtc();
    var encoded = byteData.base64encodedString();
    var query =
        'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "verified", "byteData") VALUES (${EscapedExpression(storageId)}, ${EscapedExpression(path)}, ${EscapedExpression(addedTime)}, ${EscapedExpression(expiration?.toUtc())}, ${EscapedExpression(verified)}, $encoded) ON CONFLICT("storageId", "path") DO UPDATE SET "byteData"=$encoded, "addedTime"=${EscapedExpression(addedTime)}, "expiration"=${EscapedExpression(expiration?.toUtc())}, "verified"=${EscapedExpression(verified)}';
    try {
      Database db = serviceLocator.locate<Database>()!;
      await db.unsafeQuery(query);
    } catch (e) {
      throw CloudStorageException('Failed to store file. ($e)');
    }
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required ServiceLocator serviceLocator,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    ServerpodConfig config = serviceLocator.locate<ServerpodConfig>()!;

    var expiration = DateTime.now().add(expirationDuration);

    var uploadEntry = CloudStorageDirectUploadEntry(
      storageId: storageId,
      path: path,
      expiration: expiration,
      authKey: _generateAuthKey(),
    );
    Database db = serviceLocator.locate<Database>()!;
    var inserted =
        await db.insertRow<CloudStorageDirectUploadEntry>(uploadEntry);

    var uri = Uri(
      scheme: config.apiServer.publicScheme,
      host: config.apiServer.publicHost,
      port: config.apiServer.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: {
        'method': 'upload',
        'storage': storageId,
        'path': path,
        'key': inserted.authKey,
      },
    );

    var uploadDescriptionData = {
      'url': uri.toString(),
      'type': 'binary',
    };

    return SerializationManager.encode(uploadDescriptionData);
  }

  /// Returns true if the specified file has been successfully uploaded to the
  /// database cloud storage.
  @override
  Future<bool> verifyDirectFileUpload({
    required ServiceLocator serviceLocator,
    required String path,
  }) async {
    var query =
        'SELECT verified FROM serverpod_cloud_storage WHERE "storageId"=${EscapedExpression(storageId)} AND "path"=${EscapedExpression(path)}';
    Database db = serviceLocator.locate<Database>()!;
    var result = await db.unsafeQuery(query);
    if (result.isEmpty) return false;

    var verified = result.first.first as bool;
    if (verified) return false;

    query =
        'UPDATE serverpod_cloud_storage SET "verified"=${EscapedExpression(true)} WHERE "storageId"=${EscapedExpression(storageId)} AND "path"=${EscapedExpression(path)}';
    await db.unsafeQuery(query);
    return true;
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
