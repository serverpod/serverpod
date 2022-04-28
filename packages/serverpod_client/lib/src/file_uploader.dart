import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// The file uploader uploads files to Serverpods cloud storage. On the server
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
    http.ByteStream stream =
        http.ByteStream.fromBytes(byteData.buffer.asUint8List());
    return upload(stream, byteData.lengthInBytes);
  }

  /// Uploads a file from a [Stream], returns true if successful.
  Future<bool> upload(Stream<List<int>> stream, int length) async {
    if (_attemptedUpload) {
      throw Exception(
          'Data has already been uploaded using this FileUploader.');
    }
    _attemptedUpload = true;

    if (_uploadDescription.type == _UploadType.binary) {
      try {
        http.Response result = await http.post(
          _uploadDescription.url,
          body: await _readStreamData(stream),
          headers: <String, String>{
            'Content-Type': 'application/octet-stream',
            'Accept': '*/*',
          },
        );
        return result.statusCode == 200;
      } catch (e) {
        return false;
      }
    } else if (_uploadDescription.type == _UploadType.multipart) {
      // final stream = http.ByteStream(Stream.castFrom(file.openRead()));
      // final length = await file.length();

      // final stream = http.ByteStream.fromBytes(data.buffer.asUint8List());
      // final length = await data.lengthInBytes;

      http.MultipartRequest request =
          http.MultipartRequest('POST', _uploadDescription.url);
      http.MultipartFile multipartFile = http.MultipartFile(
          _uploadDescription.field!, stream, length,
          filename: _uploadDescription.fileName);

      request.files.add(multipartFile);
      for (String key in _uploadDescription.requestFields.keys) {
        request.fields[key] = _uploadDescription.requestFields[key]!;
      }

      try {
        http.StreamedResponse result = await request.send();
        // var body = await _readBody(result.stream);
        // print('body: $body');
        return result.statusCode == 204;
      } catch (e) {
        return false;
      }
    }
    throw UnimplementedError('Unknown upload type');
  }

  // Future<String?> _readBody(http.ByteStream stream) async {
  //   // TODO: Find more efficient solution?
  //   var len = 0;
  //   var data = <int>[];
  //   await for (var segment in stream) {
  //     len += segment.length;
  //     data += segment;
  //   }
  //   return Utf8Decoder().convert(data);
  // }

  Future<List<int>> _readStreamData(Stream<List<int>> stream) async {
    // TODO: Find more efficient solution?
    List<int> data = <int>[];
    await for (List<int> segment in stream) {
      data += segment;
    }
    return data;
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
  Map<String, String> requestFields = <String, String>{};

  _UploadDescription(String description) {
    Map<String, dynamic> data = jsonDecode(description);
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
      requestFields = (data['request-fields'] as Map<String, String>)
          .cast<String, String>();
    }
  }
}
