import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class FileUploader {
  late final _UploadDescription _uploadDescription;
  bool _attemptedUpload = false;

  FileUploader(String uploadDescription) {
    _uploadDescription = _UploadDescription(uploadDescription);
  }

  Future<bool> uploadData(ByteData data) async {
    if (_attemptedUpload) {
      throw Exception('Data has already been uploaded using this FileUploader.');
    }
    _attemptedUpload = true;

    if (_uploadDescription.type == _UploadType.binary) {
      try {
        var result = await http.post(
          _uploadDescription.url,
          body: data.buffer.asUint8List(),
          headers: {
            'Content-Type': 'application/octet-stream',
            'Accept': '*/*',
          },
        );
        return result.statusCode == 200;
      }
      catch(e, stackTrace) {
        print('Upload failed: $e');
        print('$stackTrace');
        return false;
      }
    }
    else if (_uploadDescription.type == _UploadType.multipart) {
      // final stream = http.ByteStream(Stream.castFrom(file.openRead()));
      // final length = await file.length();

      final stream = http.ByteStream.fromBytes(data.buffer.asUint8List());
      final length = await data.lengthInBytes;

      final request = http.MultipartRequest("POST", _uploadDescription.url);
      final multipartFile = http.MultipartFile(_uploadDescription.field!, stream, length, filename: _uploadDescription.fileName);

      request.files.add(multipartFile);
      for (var key in _uploadDescription.requestFields.keys) {
        request.fields[key] = _uploadDescription.requestFields[key]!;
      }

      try {
        var result = await request.send();
        // var body = await _readBody(result.stream);
        // print('body: $body');
        return result.statusCode == 204;
      }
      catch(e, stackTrace) {
        print('Upload failed: $e');
        print('$stackTrace');
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
  Map<String,String> requestFields = {};

  _UploadDescription(String description) {
    var data = jsonDecode(description);
    if (data['type'] == 'binary')
      type = _UploadType.binary;
    else if (data['type'] == 'multipart')
      type = _UploadType.multipart;
    else
      throw FormatException('Missing type, can be binary or multipart');

    url = Uri.parse(data['url']);

    if (type == _UploadType.multipart) {
      field = data['field'];
      fileName = data['file-name'];
      requestFields = (data['request-fields'] as Map).cast<String, String>();
    }
  }
}