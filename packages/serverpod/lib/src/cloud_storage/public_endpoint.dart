import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_download.dart';
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
  Future<Response> file(MethodCallSession session, String path) =>
      _fileResponse(session, storageId: 'public', path: path);

  /// Retrieves a file using a temporary database-storage download token.
  Future<Response> temporaryFile(
    MethodCallSession session,
    String storageId,
    String path,
    String key,
  ) async {
    final download = await CloudStorageDirectDownloadEntry.db.findFirstRow(
      session,
      where: (t) =>
          t.storageId.equals(storageId) &
          t.path.equals(path) &
          t.authKey.equals(key) &
          (t.expiration > DateTime.now().toUtc()),
    );
    if (download == null) {
      throw EndpointNotFoundException('Temporary download URL is invalid.');
    }

    return _fileResponse(
      session,
      storageId: storageId,
      path: path,
      contentTypeOverride: download.contentType,
      downloadFileName: download.downloadFileName,
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

    if (uploadInfo == null ||
        uploadInfo.authKey != key ||
        !uploadInfo.expiration.isAfter(DateTime.now().toUtc())) {
      return false;
    }

    var body = await _readBinaryBody(
      session.request,
      min(uploadInfo.maxFileSize, server.serverpod.config.maxRequestSize),
    );
    if (body == null) return false;

    if (uploadInfo.contentLength != null &&
        body.length != uploadInfo.contentLength) {
      return false;
    }

    var byteData = ByteData.sublistView(body);

    var storage = server.serverpod.storage[storageId];
    if (storage is! DatabaseCloudStorage) return false;

    await storage.storeUnverifiedFile(
      session: session,
      path: path,
      byteData: byteData,
      options: StoreFileOptions(
        preventOverwrite: uploadInfo.preventOverwrite,
        metadata: FileMetadata(
          contentType: uploadInfo.contentType,
          cacheControl: uploadInfo.cacheControl,
          contentDisposition: uploadInfo.contentDisposition,
          contentEncoding: uploadInfo.contentEncoding,
          custom: _decodeCustomMetadata(uploadInfo.customMetadata),
        ),
      ),
    );

    await CloudStorageDirectUploadEntry.db.deleteRow(session, uploadInfo);

    return true;
  }

  Future<Uint8List?> _readBinaryBody(Request request, int maxFileSize) async {
    int len = 0;
    var builder = BytesBuilder(copy: false);

    await for (var chunk in request.read()) {
      len += chunk.length;
      if (len > maxFileSize) return null;
      builder.add(chunk);
    }
    return builder.takeBytes();
  }

  Future<Response> _fileResponse(
    MethodCallSession session, {
    required String storageId,
    required String path,
    String? contentTypeOverride,
    String? downloadFileName,
  }) async {
    try {
      final results = await Future.wait([
        session.storage.retrieveFile(storageId: storageId, path: path),
        session.storage.statFile(storageId: storageId, path: path),
      ]);
      final file = results.first as ByteData;
      final stat = results.last as FileStat;

      final extension = p.extension(path).toLowerCase();
      final mimeType = switch (contentTypeOverride ?? stat.contentType) {
        final value? => MimeType.parse(value),
        null => _mimeTypeMapping[extension] ?? MimeType.octetStream,
      };
      final headers = Headers.build((mutableHeaders) {
        if (stat.cacheControl != null) {
          mutableHeaders['Cache-Control'] = [stat.cacheControl!];
        }
        if (stat.contentEncoding != null) {
          mutableHeaders['Content-Encoding'] = [stat.contentEncoding!];
        }
        final disposition = downloadFileName == null
            ? stat.contentDisposition
            : "attachment; filename*=UTF-8''${Uri.encodeComponent(downloadFileName)}";
        if (disposition != null) {
          mutableHeaders['Content-Disposition'] = [disposition];
        }
      });
      return Response.ok(
        body: Body.fromData(Uint8List.sublistView(file), mimeType: mimeType),
        headers: headers,
      );
    } on CloudStorageFileNotFoundException {
      throw EndpointNotFoundException('File not found: $path');
    }
  }

  Map<String, String> _decodeCustomMetadata(String? metadata) {
    if (metadata == null) return const {};
    final decoded = jsonDecode(metadata);
    if (decoded is! Map) return const {};
    return decoded.cast<String, String>();
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
        'temporaryFile': MethodConnector(
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
            return temporaryFile(
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
