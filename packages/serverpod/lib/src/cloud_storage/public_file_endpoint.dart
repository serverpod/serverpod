import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cloud_storage/content_type.dart';

const _endpointName = 'serverpod_file_storage';

/// Endpoint for the default public [FileCloudStorage].
class FileStoragePublicEndpoint extends Endpoint {
  @override
  bool get sendByteDataAsRaw => true;

  /// Retrieves a file from the public database cloud storage.
  Future<ByteData?> file(MethodCallSession session, String path) async {
    var response = session.httpRequest.response;

   
    // Fetch the file from local path .
    var file = File(path);
  
    // Set the response code
    if (!file.existsSync()) {
      response.statusCode = HttpStatus.notFound;
      return null;
    }

    // TODO: Support more extension types.

    var extension = p.extension(path);
    extension = extension.toLowerCase();
   
      response.headers.contentType = contentType[extension];
  
      final fileData = await file.readAsBytes();
      final data = ByteData.view(fileData.buffer);
      return data;
  }

  /// Uploads a file to the Servers directory represented with path.
  Future<bool> upload(MethodCallSession session, String path) async {

    var body = await _readBinaryBody(session.httpRequest);
    if (body == null) return false;

      var byteData = ByteData.view(Uint8List.fromList(body).buffer);

      final buffer = byteData.buffer;
      final file =  File(path);

      await file.create(recursive: true);
      
      await file.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

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
            return upload(session as MethodCallSession,
                params['path']);
          },
        ),
      },
    );
  }
}
