import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

int globalInt = 0;

class CloudStorageEndpoint extends Endpoint {
  Future<void> storePublicFile(Session session, String path, ByteData byteData) async {
    await session.storage['public']!.storeFile(session: session, path: path, byteData: byteData);

    var storedFile = await session.storage['public']!.retrieveFile(session: session, path: path);
    print('STORED len: ${storedFile!.lengthInBytes}');
  }

  Future<ByteData?> retrievePublicFile(Session session, String path) async {
    return await session.storage['public']!.retrieveFile(session: session, path: path);
  }
}