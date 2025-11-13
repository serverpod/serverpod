import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_upload.dart';
import 'package:path/path.dart' as p;

const _endpointName = 'serverpod_cloud_storage';

const _mimeTypeMapping = <String, MimeType>{
  '.js': MimeType.javascript,
  '.json': MimeType.json,
  '.wasm': MimeType('application', 'wasm'),
  '.css': MimeType.css,
  '.png': MimeType('image', 'png'),
  '.jpg': MimeType('image', 'jpeg'),
  '.jpeg': MimeType('image', 'jpeg'),
  '.svg': MimeType('image', 'svg+xml'),
  '.ttf': MimeType('application', 'x-font-ttf'),
  '.woff': MimeType('application', 'x-font-woff'),
  '.mp3': MimeType('audio', 'mpeg'),
  '.pdf': MimeType.pdf,
};

/// Endpoint for the default public [DatabaseCloudStorage].
@doNotGenerate
class CloudStoragePublicEndpoint extends Endpoint {
  @override
  bool get sendAsRaw => true;

  /// Retrieves a file from the public database cloud storage.
  Future<Body?> file(MethodCallSession session, String path) async {
    // Fetch the file from storage.
    var file = await session.storage.retrieveFile(
      storageId: 'public',
      path: path,
    );

    if (file == null) {
      throw EndpointNotFoundException('File not found: $path');
    }

    final extension = p.extension(path).toLowerCase();
    return Body.fromData(
      Uint8List.sublistView(file),
      mimeType: _mimeTypeMapping[extension] ?? MimeType.octetStream,
    );
  }

  /// Uploads a file to the public database cloud storage.
  Future<bool> upload(
    MethodCallSession session,
    String storageId,
    String path,
    String key,
  ) async {
    // Confirm that we are allowed to do the upload
    var uploadInfo = await session.db
        .findFirstRow<CloudStorageDirectUploadEntry>(
          where:
              CloudStorageDirectUploadEntry.t.storageId.equals(storageId) &
              CloudStorageDirectUploadEntry.t.path.equals(path),
        );

    if (uploadInfo == null) return false;

    await session.db.deleteRow(uploadInfo);

    if (uploadInfo.authKey != key) return false;

    var body = await _readBinaryBody(session.request);
    if (body == null) return false;

    var byteData = ByteData.sublistView(body);

    var storage = server.serverpod.storage[storageId];
    if (storage == null) return false;

    await storage.storeFile(
      session: session,
      path: path,
      byteData: byteData,
      verified: false,
    );

    return true;
  }

  Future<Uint8List?> _readBinaryBody(Request request) async {
    int len = 0;
    var builder = BytesBuilder(copy: false);

    await for (var chunk in request.read()) {
      len += chunk.length;
      if (len > server.serverpod.config.maxRequestSize) return null;
      builder.add(chunk);
    }
    return builder.takeBytes();
  }

  /// Registers the endpoint with the Serverpod by manually adding an
  /// [EndpointConnector].
  void register(Serverpod serverpod) {
    initialize(serverpod.server, _endpointName, null);

    serverpod.endpoints.connectors[_endpointName] = EndpointConnector(
      name: _endpointName,
      endpoint: this,
      methodConnectors: {
        'file': MethodConnector(
          name: name,
          params: {
            'path': ParameterDescription(
              name: 'path',
              type: String,
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return file(session as MethodCallSession, params['path']);
          },
        ),
        'upload': MethodConnector(
          name: name,
          params: {
            'storage': ParameterDescription(
              name: 'storage',
              type: String,
              nullable: false,
            ),
            'path': ParameterDescription(
              name: 'path',
              type: String,
              nullable: false,
            ),
            'key': ParameterDescription(
              name: 'key',
              type: String,
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return upload(
              session as MethodCallSession,
              params['storage'],
              params['path'],
              params['key'],
            );
          },
        ),
      },
    );
  }
}
