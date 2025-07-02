import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_upload.dart';

const _endpointName = 'serverpod_cloud_storage';

/// Endpoint for the default public [DatabaseCloudStorage].
@doNotGenerate
class CloudStoragePublicEndpoint extends Endpoint {
  @override
  bool get sendAsRaw => true;

  /// Retrieves a file from the public database cloud storage.
  Future<ByteData?> file(MethodCallSession session, String path) async {
    // Fetch the file from storage.
    var file =
        await session.storage.retrieveFile(storageId: 'public', path: path);

    // Set the response code
    if (file == null) {
      throw EndpointNotFoundException('File not found: $path');
    }

    // TODO: Support more extension types.
    // Content-Type headers are usually set by Server.dart or by returning a specific
    // Response object. Endpoint methods returning ByteData with sendByteDataAsRaw=true
    // will typically have Content-Type set by the server, often to application/octet-stream.
    // The custom logic below is removed for now.
    // var extension = p.extension(path);
    // extension = extension.toLowerCase();
    // if (extension == '.js') {
    // } else if (extension == '.css') {
    // } else if (extension == '.png') {
    // } else if (extension == '.jpg') {
    // } else if (extension == '.svg') {
    // } else if (extension == '.ttf') {
    // } else if (extension == '.woff') {
    // }

    // Retrieve the file from storage and return it.
    return file;
  }

  /// Uploads a file to the public database cloud storage.
  Future<bool> upload(MethodCallSession session, String storageId, String path,
      String key) async {
    // Confirm that we are allowed to do the upload
    var uploadInfo =
        await session.db.findFirstRow<CloudStorageDirectUploadEntry>(
      where: CloudStorageDirectUploadEntry.t.storageId.equals(storageId) &
          CloudStorageDirectUploadEntry.t.path.equals(path),
    );

    if (uploadInfo == null) return false;

    await session.db.deleteRow(uploadInfo);

    if (uploadInfo.authKey != key) return false;

    var body = await _readBinaryBody(session.request);
    if (body == null) return false;

    var byteData = ByteData.view(Uint8List.fromList(body).buffer);

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

  Future<List<int>?> _readBinaryBody(Request request) async {
    // TODO: Find more efficient solution?
    int len = 0;
    var builder = BytesBuilder();

    await for (var chunk in request.read()) {
      len += chunk.length;
      if (len > server.serverpod.config.maxRequestSize) return null;
      builder.add(chunk);
    }
    return builder.toBytes();
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
            return upload(session as MethodCallSession, params['storage'],
                params['path'], params['key']);
          },
        ),
      },
    );
  }
}
