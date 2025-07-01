import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

class UploadEndpoint extends Endpoint {
  Future<bool> uploadByteData(
    Session session,
    String path,
    ByteData data,
  ) async {
    print('path: "$path", lengthInBytes: ${data.lengthInBytes}');
    return true;
  }
}
