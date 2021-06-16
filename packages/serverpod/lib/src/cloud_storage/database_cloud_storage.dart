import 'dart:io';
import 'dart:typed_data';

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
  Future<void> deleteFile({required Session session, required String path}) {
    // TODO: implement deleteFile
    throw UnimplementedError();
  }

  @override
  Future<bool?> fileExists({required Session session, required String path}) {
    // TODO: implement fileExists
    throw UnimplementedError();
  }

  @override
  Future<Uri?> getPublicUri({required Session session, required String path}) {
    // TODO: implement getPublicUri
    throw UnimplementedError();
  }

  @override
  Future<ByteData?> retrieveFile({required Session session, required String path}) async {
    try {
      return await session.db.retrieveFile(storageId, path);
    }
    catch(e) {
      throw CloudStorageException('Failed to retrieve file. ($e)');
    }
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
  }) async {
    try {
      await session.db.storeFile(storageId, path, byteData, expiration);
    }
    catch(e) {
      throw CloudStorageException('Failed to store file. ($e)');
    }
  }

}