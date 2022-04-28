import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import '../../serverpod.dart';
import '../generated/cloud_storage_direct_upload.dart';

const String _endpointName = 'serverpod_cloud_storage';

/// Endpoint for the default public [DatabaseCloudStorage].
class CloudStoragePublicEndpoint extends Endpoint {
  @override
  bool get sendByteDataAsRaw => true;

  /// Retrieves a file from the public database cloud storage.
  Future<ByteData?> file(MethodCallSession session, String path) async {
    HttpResponse response = session.httpRequest.response;

    // Fetch the file from storage.
    ByteData? file =
        await session.storage.retrieveFile(storageId: 'public', path: path);

    // Set the response code
    if (file == null) {
      response.statusCode = HttpStatus.notFound;
      return null;
    }

    // TODO: Support more extension types.

    String extension = p.extension(path);
    extension = extension.toLowerCase();
    if (extension == '.js') {
      response.headers.contentType = ContentType('text', 'javascript');
    } else if (extension == '.css') {
      response.headers.contentType = ContentType('text', 'css');
    } else if (extension == '.png') {
      response.headers.contentType = ContentType('image', 'png');
    } else if (extension == '.jpg') {
      response.headers.contentType = ContentType('image', 'jpeg');
    } else if (extension == '.svg') {
      response.headers.contentType = ContentType('image', 'svg+xml');
    } else if (extension == '.ttf') {
      response.headers.contentType = ContentType('application', 'x-font-ttf');
    } else if (extension == '.woff') {
      response.headers.contentType = ContentType('application', 'x-font-woff');
    }

    // Retrieve the file from storage and return it.
    return file;
  }

  /// Uploads a file to the the public database cloud storage.
  Future<bool> upload(MethodCallSession session, String storageId, String path,
      String key) async {
    // Confirm that we are allowed to do the upload
    CloudStorageDirectUploadEntry? uploadInfo =
        await session.db.findSingleRow<CloudStorageDirectUploadEntry>(
      where: CloudStorageDirectUploadEntry.t.storageId.equals(storageId) &
          CloudStorageDirectUploadEntry.t.path.equals(path),
    );

    if (uploadInfo == null) return false;

    await session.db.deleteRow(uploadInfo);

    if (uploadInfo.authKey != key) return false;

    List<int>? body = await _readBinaryBody(session.httpRequest);
    if (body == null) return false;

    ByteData byteData = ByteData.view(Uint8List.fromList(body).buffer);

    CloudStorage? storage = server.serverpod.storage[storageId];
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
    int len = 0;
    List<int> data = <int>[];

    await for (Uint8List segment in request) {
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
      methodConnectors: <String, MethodConnector>{
        'file': MethodConnector(
          name: name,
          params: <String, ParameterDescription>{
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
          params: <String, ParameterDescription>{
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
