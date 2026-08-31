import 'dart:typed_data';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

class CloudStorageEndpoint extends Endpoint {
  Future<void> reset(Session session) async {
    // Remove all entries
    await CloudStorageEntry.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
    await CloudStorageDirectUploadEntry.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
    await CloudStorageDirectDownloadEntry.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
  }

  Future<void> storePublicFile(
    Session session,
    String path,
    ByteData byteData,
  ) async {
    await session.storage.storeFile(
      storageId: 'public',
      path: path,
      byteData: byteData,
    );
  }

  Future<ByteData> retrievePublicFile(Session session, String path) async {
    return await session.storage.retrieveFile(
      storageId: 'public',
      path: path,
    );
  }

  Future<bool> existsPublicFile(Session session, String path) async {
    return await session.storage.fileExists(
      storageId: 'public',
      path: path,
    );
  }

  Future<void> deletePublicFile(Session session, String path) async {
    await session.storage.deleteFile(
      storageId: 'public',
      path: path,
    );
  }

  Future<String> publicDownloadUrlForFile(Session session, String path) async {
    var uri = await session.storage.publicDownloadUrl(
      storageId: 'public',
      path: path,
    );
    return uri.toString();
  }

  Future<String> temporaryDownloadUrlForFile(
    Session session,
    String path,
  ) async {
    final uri = await session.storage.temporaryDownloadUrl(
      storageId: 'public',
      path: path,
      options: const TemporaryDownloadUrlOptions(
        expirationDuration: Duration(minutes: 5),
      ),
    );
    return uri.toString();
  }

  Future<String> createUploadDescriptionForFile(
    Session session,
    String path,
  ) async {
    return await session.storage.createUploadDescription(
      storageId: 'public',
      path: path,
    );
  }

  Future<bool> verifyUpload(Session session, String path) async {
    return await session.storage.verifyUpload(
      storageId: 'public',
      path: path,
    );
  }
}
