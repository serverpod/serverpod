import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_upload.dart';

import '../server/endpoint.dart';
import '../server/session.dart';
import '../server/serverpod.dart';

const _endpointName = 'serverpod_cloud_storage';

/// Endpoint for the default public [DatabaseCloudStorage].
class CloudStoragePublicEndpoint extends Endpoint {
  @override
  bool get sendByteDataAsRaw => true;

  /// Retrieves a file from the public database cloud storage.
  Future<ByteData?> file(MethodCallSession session, String path) async {
    var response = session.httpRequest.response;

    // Fetch the file from storage.
    var file = await session.storage.retrieveFile(storageId: 'public', path: path);

    // Set the response code
    if (file == null) {
      response.statusCode = HttpStatus.notFound;
      return null;
    }

    // TODO: Support more extension types.

    var extension = p.extension(path);
    extension = extension.toLowerCase();
    if (extension == '.js')
      response.headers.contentType = ContentType('text', 'javascript');
    else if (extension == '.css')
      response.headers.contentType = ContentType('text', 'css');
    else if (extension == '.png')
      response.headers.contentType = ContentType('image', 'png');
    else if (extension == '.jpg')
      response.headers.contentType = ContentType('image', 'jpeg');
    else if (extension == '.svg')
      response.headers.contentType = ContentType('image', 'svg+xml');
    else if (extension == '.ttf')
      response.headers.contentType = ContentType('application', 'x-font-ttf');
    else if (extension == '.woff')
      response.headers.contentType = ContentType('application', 'x-font-woff');

    // Retrieve the file from storage and return it.
    return file;
  }

  Future<bool> upload(MethodCallSession session, String storageId, String path, String key) async {
    // Confirm that we are allowed to do the upload
    var uploadInfo = (await session.db.findSingleRow(
      tCloudStorageDirectUploadEntry,
      where: tCloudStorageDirectUploadEntry.storageId.equals(storageId) & tCloudStorageDirectUploadEntry.path.equals(path),
    )) as CloudStorageDirectUploadEntry?;

    if (uploadInfo == null)
      return false;

    await session.db.deleteRow(uploadInfo);

    if (uploadInfo.authKey != key)
      return false;

    var body = await _readBinaryBody(session.httpRequest);
    if (body == null)
      return false;

    var byteData = ByteData.view(Uint8List.fromList(body).buffer);

    var storage = server.serverpod.storage[storageId];
    if (storage == null)
      return false;

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
      if (len > server.serverpod.config.maxRequestSize)
        return null;
      data += segment;
    }
    return data;
  }

  /// Registers the endpoint with the Serverpod by manually adding an
  /// [EndpointConnector].
  void register(Serverpod serverpod) {
    initialize(serverpod.server, _endpointName, null);

    serverpod.endpoints.connectors[_endpointName] = EndpointConnector(
      name: _endpointName, endpoint: this, methodConnectors: {
        'file': MethodConnector(
          name: name,
          params: {
            'path': ParameterDescription(
              name: 'path', type: String, nullable: false,
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
              name: 'storage', type: String, nullable: false,
            ),
            'path': ParameterDescription(
              name: 'path', type: String, nullable: false,
            ),
            'key': ParameterDescription(
              name: 'key', type: String, nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return upload(session as MethodCallSession, params['storage'], params['path'], params['key']);
          },
        ),
      },
    );
  }
}