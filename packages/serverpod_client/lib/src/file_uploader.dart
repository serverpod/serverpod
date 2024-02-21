import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

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
  @Deprecated('Use uploadUint8List instead')
  Future<bool> uploadByteData(ByteData byteData) =>
      uploadUint8List(byteData.buffer.asUint8List());

  /// Uploads a file from a [Stream], returns true if successful.
  @Deprecated('Use uploadUint8List instead')
  Future<bool> upload(Stream<List<int>> stream, int length) async {
    var data = <int>[];
    await for (var segment in stream) {
      data += segment;
    }
    return await uploadUint8List(Uint8List.fromList(data));
  }

  /// Uploads a file contained by a [Uint8List] object, returns true if
  /// successful.
  Future<bool> uploadUint8List(Uint8List data) async {
    if (_attemptedUpload) {
      throw Exception(
          'Data has already been uploaded using this FileUploader.');
    }
    _attemptedUpload = true;

    Object? dataToPost;
    if (_uploadDescription.type == _UploadType.binary) {
      dataToPost = data;
    } else if (_uploadDescription.type == _UploadType.multipart) {
      dataToPost = FormData.fromMap({
        'name': 'dio',
        'date': DateTime.now().toIso8601String(),
        'file': MultipartFile.fromBytes(
          data,
          filename: _uploadDescription.fileName,
        ),
      });
    } else {
      throw UnimplementedError('Unknown upload type');
    }
    var dio = Dio();
    dio.options.contentType = 'application/octet-stream';
    dio.options.headers['Accept'] = '*/*';
    try {
      var result = await dio.post(_uploadDescription.url, data: dataToPost);
      // var body = result.data == null ? '' : result.data.toString();
      // print('body: $body');
      return _uploadDescription.type == _UploadType.binary
          ? result.statusCode == 200
          : result.statusCode == 204;
    } catch (e) {
      return false;
    } finally {
      dio.close();
    }
  }
}

enum _UploadType {
  binary,
  multipart,
}

class _UploadDescription {
  late _UploadType type;
  late String url;
  String? field;
  String? fileName;
  Map<String, String> requestFields = {};

  _UploadDescription(String description) {
    var data = jsonDecode(description);
    if (data['type'] == 'binary') {
      type = _UploadType.binary;
    } else if (data['type'] == 'multipart') {
      type = _UploadType.multipart;
    } else {
      throw const FormatException('Missing type, can be binary or multipart');
    }

    if (data['url'] == null) {
      throw const FormatException('Missing url');
    }
    url = data['url'];

    if (type == _UploadType.multipart) {
      field = data['field'];
      fileName = data['file-name'];
      requestFields = (data['request-fields'] as Map).cast<String, String>();
    }
  }
}
