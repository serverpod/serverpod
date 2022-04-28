import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

ByteData createByteData(int len) {
  Uint8List ints = Uint8List(len);
  for (int i = 0; i < len; i++) {
    ints[i] = i % len;
  }
  return ByteData.view(ints.buffer);
}

bool verifyByteData(ByteData byteData) {
  Uint8List ints = byteData.buffer.asUint8List();
  for (int i in ints) {
    if (ints[i] != i % byteData.lengthInBytes) return false;
  }
  return true;
}

void main() {
  Client client = Client('http://serverpod_test_server:8080/');

  setUp(() {});

  group('Database cloud storage', () {
    test('Clear files', () async {
      await client.cloudStorage.reset();
    });

    test('Store file 1', () async {
      await client.cloudStorage
          .storePublicFile('testdir/myfile1.bin', createByteData(256));
    });

    test('Store file 2', () async {
      await client.cloudStorage
          .storePublicFile('testdir/myfile2.bin', createByteData(256));
    });

    test('Replace file 1', () async {
      await client.cloudStorage
          .storePublicFile('testdir/myfile1.bin', createByteData(128));
    });

    test('Retrieve file 1', () async {
      ByteData? byteData =
          await client.cloudStorage.retrievePublicFile('testdir/myfile1.bin');
      expect(byteData!.lengthInBytes, equals(128));
      expect(verifyByteData(byteData), equals(true));
    });

    test('Retrieve file 2 through URL', () async {
      Uri url = Uri.parse(
          'http://serverpod_test_server:8080/serverpod_cloud_storage?method=file&path=testdir/myfile2.bin');
      http.Response response = await http.get(url);
      expect(response.statusCode, equals(200));
      Uint8List bytes = response.bodyBytes;
      expect(bytes.length, equals(256));
      verifyByteData(ByteData.view(bytes.buffer));
    });

    test('Retrieve file 1 URL', () async {
      String? urlStr =
          await client.cloudStorage.getPublicUrlForFile('testdir/myfile1.bin');
      expect(urlStr, isNotNull);
    });

    test('Retrieve file 2 through fetched URL', () async {
      String? urlStr =
          await client.cloudStorage.getPublicUrlForFile('testdir/myfile2.bin');
      Uri url = Uri.parse(urlStr!);
      http.Response response = await http.get(url);
      expect(response.statusCode, equals(200));
      Uint8List bytes = response.bodyBytes;
      expect(bytes.length, equals(256));
      verifyByteData(ByteData.view(bytes.buffer));
    });

    test('Retrieve file 2', () async {
      ByteData? byteData =
          await client.cloudStorage.retrievePublicFile('testdir/myfile2.bin');
      expect(byteData!.lengthInBytes, equals(256));
      expect(verifyByteData(byteData), equals(true));
    });

    test('Retrieve non existing file', () async {
      ByteData? byteData =
          await client.cloudStorage.retrievePublicFile('testdir/myfile3.bin');
      expect(byteData, isNull);
    });

    test('Retrieve non existing file through URL', () async {
      Uri url = Uri.parse(
          'http://serverpod_test_server:8080/serverpod_cloud_storage?method=file&path=testdir/myfile3.bin');
      http.Response response = await http.get(url);
      expect(response.statusCode, equals(404));
      Uint8List bytes = response.bodyBytes;
      expect(bytes.length, equals(0));
    });

    test('Attempt retrieve file through URL with invalid params', () async {
      Uri url = Uri.parse(
          'http://serverpod_test_server:8080/serverpod_cloud_storage?method=file&foo=testdir/myfile2.bin');
      http.Response response = await http.get(url);
      // TODO: Actual response should probably be 400 (see server todo with verification of parameters).
      expect(response.statusCode, equals(500));
    });

    test('Attempt retrieve file through URL with invalid method', () async {
      Uri url = Uri.parse(
          'http://serverpod_test_server:8080/serverpod_cloud_storage?foo=file&path=testdir/myfile2.bin');
      http.Response response = await http.get(url);
      expect(response.statusCode, equals(400));
    });

    test('Exists file 1', () async {
      bool? exists =
          await client.cloudStorage.existsPublicFile('testdir/myfile1.bin');
      expect(exists, true);
    });

    test('Exists non existing file', () async {
      bool? exists =
          await client.cloudStorage.existsPublicFile('testdir/myfile3.bin');
      expect(exists, false);
    });

    test('Delete file 1', () async {
      await client.cloudStorage.deletePublicFile('testdir/myfile1.bin');
    });

    test('Exists file 1 after deletion', () async {
      bool? exists =
          await client.cloudStorage.existsPublicFile('testdir/myfile1.bin');
      expect(exists, false);
    });

    test('Direct file upload', () async {
      String? uploadDescription = await client.cloudStorage
          .getDirectFilePostUrl('testdir/directupload.bin');
      expect(uploadDescription, isNotNull);
      ByteData byteData = createByteData(1024);

      FileUploader uploader = FileUploader(uploadDescription!);
      bool result = await uploader.uploadByteData(byteData);

      expect(result, equals(true));

      bool verified = await client.cloudStorage
          .verifyDirectFileUpload('testdir/directupload.bin');
      expect(verified, equals(true));
    });

    test('Retrieve directly uploaded file', () async {
      ByteData? byteData = await client.cloudStorage
          .retrievePublicFile('testdir/directupload.bin');
      expect(byteData!.lengthInBytes, equals(1024));
      expect(verifyByteData(byteData), equals(true));
    });
  });
}
