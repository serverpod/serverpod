import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

int globalInt = 0;

class CloudStorageEndpoint extends Endpoint {
  Future<void> storePublicFile(Session session, String path, ByteData byteData) async {
    await session.storage.storeFile(
      storageId: 'public',
      path: path,
      byteData: byteData,
    );
  }

  Future<ByteData?> retrievePublicFile(Session session, String path) async {
    return await session.storage.retrieveFile(
      storageId: 'public',
      path: path,
    );
  }

  Future<bool?> existsPublicFile(Session session, String path) async {
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

  Future<String?> getPublicUrlForFile(Session session, String path) async {
    var uri = await session.storage.getPublicUrl(storageId: 'public', path: path);
    return uri?.toString();
  }
}