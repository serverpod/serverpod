import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:serverpod/server.dart';

import '../server/endpoint.dart';
import '../server/session.dart';
import '../server/serverpod.dart';

const _endpointName = 'serverpod_cloud_storage';

/// Endpoint for the default public [DatabaseCloudStorage].
class CloudStoragePublicEndpoint extends Endpoint {
  @override
  bool get sendByteDataAsRaw => true;

  @override
  String get name => _endpointName;

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

  /// Registers the endpoint with the Serverpod by manually adding an
  /// [EndpointConnector].
  void register(Serverpod serverpod) {
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
    });
  }
}