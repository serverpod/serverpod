import 'dart:io';
import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_upload.dart';

const _endpointName = 'serverpod_cloud_storage';

/// Endpoint for the default public [DatabaseCloudStorage].
class CloudStoragePublicEndpoint extends Endpoint {
  @override
  bool get sendByteDataAsRaw => true;

  /// Retrieves a file from the public database cloud storage.
  Future<ByteData?> file(MethodCallSession session, String path) async {
    var response = session.httpRequest.response;

    // Fetch the file from storage.
    var file =
        await session.storage.retrieveFile(storageId: 'public', path: path);

    // Set the response code
    if (file == null) {
      response.statusCode = HttpStatus.notFound;
      return null;
    }

    // Get the mime type
    var type = lookupMimeType(path);
    if(type==null){
      response.statusCode = HttpStatus.notFound;
      return null;
    }

    // Content type parse
    var contentType = ContentType.parse(type);

    response.headers.contentType = contentType;

    // Retrieve the file from storage and return it.
    return file;
  }

  /// Uploads a file to the the public database cloud storage.
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

    var body = await _readBinaryBody(session.httpRequest);
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

  Future<List<int>?> _readBinaryBody(HttpRequest request) async {
    // TODO: Find more efficient solution?
    var len = 0;
    var data = <int>[];

    await for (var segment in request) {
      len += segment.length;
      if (len > server.serverpod.config.maxRequestSize) return null;
      data += segment;
    }
    return data;
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
