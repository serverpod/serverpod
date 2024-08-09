
import 'dart:io';

import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

/// The [FileCloudStorage] uses the standard file system to store
///  files. It's the default [CloudStorage] interface of Serverpod, but
/// you may want to replace it with a more robust service depending on your
/// needs, especially in your production environment.
class FileCloudStorage extends CloudStorage {
  /// Creates a new [FileCloudStorage].
  FileCloudStorage(super.storageId);

  @override
  Future<void> deleteFile(
      {required Session session, required String path}) async {
    try {
      var file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
      
    } catch (e) {
      throw CloudStorageException('Failed to delete file. ($e)');
    }
  }

  @override
  Future<bool> fileExists(
      {required Session session, required String path}) async {
    try {
       var file = File(path);
     return (file.existsSync());
    } catch (e) {
      throw CloudStorageException('Failed to check if file exists. ($e)');
    }
  }

  @override
  Future<Uri?> getPublicUrl(
      {required Session session, required String path}) async {
    if (storageId != 'file') return null;

    var exists = await fileExists(session: session, path: path);
    if (!exists) return null;

    var config = session.server.serverpod.config;

    return Uri(
      scheme: config.apiServer.publicScheme,
      host: config.apiServer.publicHost,
      port: config.apiServer.publicPort,
      path: '/serverpod_file_storage',
      queryParameters: {
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
        var file = File(path);
        if (!file.existsSync()) return null;
      
        return ByteData.view(file.readAsBytesSync().buffer);
    
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
      var buffer = byteData.buffer;
      var file =  File(path);

      await file.create(recursive: true);
      
      await file.writeAsBytes( buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      
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
    var uri = Uri(
      scheme: config.apiServer.publicScheme,
      host: config.apiServer.publicHost,
      port: config.apiServer.publicPort,
      path: '/serverpod_file_storage',
      queryParameters: {
        'method': 'upload',
        'storage': storageId,
        'path': path,
     
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
    required Session session,
    required String path,
  }) async {
    var file = File(path);
    var exist =  await file.exists();
    return exist;

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
