import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:http/http.dart' as http;

/// The file uploader uploads files to Serverpod's cloud storage. On the server
/// you can setup a custom storage service, such as S3 or Google Cloud. To
/// directly upload a file, you first need to retrieve an upload description
/// from your server. After the file is uploaded, make sure to notify the server
/// by calling `verifyUpload` on the current Session object.
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
  /// of the stream is optional. If it's not provided for a multipart upload
  /// and the upload description doesn't pin the exact file size, the entire
  /// file will be buffered in memory.
  Future<bool> upload(Stream<List<int>> stream, [int? length]) =>
      _upload(stream.toByteStream(), length);

  Future<bool> _upload(http.ByteStream stream, int? length) async {
    if (_attemptedUpload) {
      throw Exception(
        'Data has already been uploaded using this FileUploader.',
      );
    }
    _attemptedUpload = true;

    try {
      switch (_uploadDescription.type) {
        case _UploadType.binary:
          final method = _uploadDescription.method ?? 'POST';
          final request = http.StreamedRequest(method, _uploadDescription.url);

          // Apply custom headers from description, with defaults
          final headers = {
            'Content-Type': 'application/octet-stream',
            'Accept': '*/*',
            ..._uploadDescription.headers,
          };
          request.headers.addAll(headers);
          request.contentLength = length;

          final (_, response) = await (
            stream.pipe(request.sink),
            request.send(),
          ).wait;
          await response.stream.drain();

          // Accept both 200 and 204 as success (PUT uploads often return 200)
          return response.statusCode == 200 || response.statusCode == 204;

        case _UploadType.multipart:
          // Multipart providers require a Content-Length, so a file size
          // pinned by the server's policy lets the stream be sent unbuffered.
          length ??= _uploadDescription.contentLength;
          var multipartFile = switch (length) {
            null => http.MultipartFile.fromBytes(
              _uploadDescription.field!,
              await stream.toBytes(),
              filename: _uploadDescription.fileName,
            ),
            _ => http.MultipartFile(
              _uploadDescription.field!,
              stream,
              length,
              filename: _uploadDescription.fileName,
            ),
          };

          var request = http.MultipartRequest('POST', _uploadDescription.url);
          request.files.add(multipartFile);
          for (var key in _uploadDescription.requestFields.keys) {
            request.fields[key] = _uploadDescription.requestFields[key]!;
          }

          var response = await request.send();
          await response.stream.drain();

          return response.statusCode == 204;
      }
    } catch (e) {
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

  /// HTTP method for binary uploads (defaults to POST for backwards compat).
  String? method;

  /// Custom headers for binary uploads.
  Map<String, String> headers = {};

  /// Exact file size in bytes pinned by a multipart upload policy, if any.
  int? contentLength;

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
      contentLength = _policyContentLength(requestFields);
    } else if (type == _UploadType.binary) {
      method = data['method'] as String?;
      if (data['headers'] != null) {
        headers = (data['headers'] as Map).cast<String, String>();
      }
    }
  }

  /// Reads the file size from a presigned POST policy whose
  /// `content-length-range` condition has equal lower and upper bounds.
  static int? _policyContentLength(Map<String, String> requestFields) {
    String? policy;
    for (var entry in requestFields.entries) {
      if (entry.key.toLowerCase() == 'policy') policy = entry.value;
    }
    if (policy == null) return null;

    try {
      var decoded = jsonDecode(utf8.decode(base64.decode(policy)));
      if (decoded is! Map) return null;
      var conditions = decoded['conditions'];
      if (conditions is! List) return null;
      for (var condition in conditions) {
        if (condition is List &&
            condition.length == 3 &&
            condition[0] == 'content-length-range' &&
            condition[1] is int &&
            condition[1] == condition[2]) {
          return condition[1] as int;
        }
      }
    } on FormatException {
      return null;
    }
    return null;
  }
}

extension on Stream<List<int>> {
  http.ByteStream toByteStream() {
    final self = this;
    if (self is http.ByteStream) return self;
    return http.ByteStream(self);
  }
}
