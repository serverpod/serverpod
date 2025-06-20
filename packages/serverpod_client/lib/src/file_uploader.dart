import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:http/http.dart' as http;

/// The file uploader uploads files to Serverpod's cloud storage. On the server
/// you can setup a custom storage service, such as S3 or Google Cloud. To
/// directly upload a file, you first need to retrieve an upload description
/// from your server. After the file is uploaded, make sure to notify the server
/// by calling the verifyDirectFileUpload on the current Session object.
class FileUploader {
  late final _UploadDescription _uploadDescription;
  bool _attemptedUpload = false;

  /// Creates a new FileUploader from an [uploadDescription] created by the
  /// server.
  FileUploader(String uploadDescription) {
    _uploadDescription = _UploadDescription(uploadDescription);
  }

  /// Uploads a file contained by a [ByteData] object, returns true if
  /// successful.
  Future<bool> uploadByteData(ByteData byteData) async {
    var stream = http.ByteStream.fromBytes(Uint8List.sublistView(byteData));
    return _upload(stream, byteData.lengthInBytes);
  }

  /// Uploads a file from a [Stream], returns true if successful. The [length]
  /// of the stream is optional, but if it's not provided for a multipart upload,
  /// the entire file will be buffered in memory.
  Future<bool> upload(Stream<List<int>> stream, [int? length]) =>
      _upload(stream.toByteStream(), length);

  Future<bool> _upload(http.ByteStream stream, int? length) async {
    if (_attemptedUpload) {
      throw Exception(
          'Data has already been uploaded using this FileUploader.');
    }
    _attemptedUpload = true;

    try {
      switch (_uploadDescription.type) {
        case _UploadType.binary:
          final request = http.StreamedRequest('POST', _uploadDescription.url);
          request.headers.addAll({
            'Content-Type': 'application/octet-stream',
            'Accept': '*/*',
          });
          request.contentLength = length;
          unawaited(stream.pipe(request.sink));

          var response = await request.send();

          return response.statusCode == 200;

        case _UploadType.multipart:
          var multipartFile = switch (length) {
            null => http.MultipartFile.fromBytes(
                _uploadDescription.field!, await stream.toBytes(),
                filename: _uploadDescription.fileName),
            _ => http.MultipartFile(_uploadDescription.field!, stream, length,
                filename: _uploadDescription.fileName),
          };

          var request = http.MultipartRequest('POST', _uploadDescription.url);
          request.files.add(multipartFile);
          for (var key in _uploadDescription.requestFields.keys) {
            request.fields[key] = _uploadDescription.requestFields[key]!;
          }

          var response = await request.send();

          return response.statusCode == 204;
      }
    } catch (e) {
      // TODO: Shouldn't we log something here?
      return false;
    }
  }
}

enum _UploadType {
  binary,
  multipart,
}

class _UploadDescription {
  late _UploadType type;
  late Uri url;
  String? field;
  String? fileName;
  Map<String, String> requestFields = {};

  _UploadDescription(String description) {
    var data = jsonDecode(description);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Description not a JSON (map) object');
    }
    if (data['type'] == 'binary') {
      type = _UploadType.binary;
    } else if (data['type'] == 'multipart') {
      type = _UploadType.multipart;
    } else {
      throw const FormatException('Missing type, can be binary or multipart');
    }

    url = Uri.parse(data['url']);

    if (type == _UploadType.multipart) {
      field = data['field'];
      fileName = data['file-name'];
      requestFields = (data['request-fields'] as Map).cast<String, String>();
    }
  }
}

extension on Stream<List<int>> {
  http.ByteStream toByteStream() {
    final self = this;
    if (self is http.ByteStream) return self;
    return http.ByteStream(self);
  }
}
