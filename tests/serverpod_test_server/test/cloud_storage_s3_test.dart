import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import 'config.dart';

ByteData createByteData(int len) {
  var ints = Uint8List(len);
  for (var i = 0; i < len; i++) {
    ints[i] = i % 256;
  }
  return ByteData.view(ints.buffer);
}

bool verifyByteData(ByteData byteData) {
  var ints = byteData.buffer.asUint8List();
  for (var i = 0; i < byteData.lengthInBytes; i++) {
    if (ints[i] != i % 256) {
      return false;
    }
  }
  return true;
}

void main() {
  var client = Client(serverUrl);

  setUp(() {});

  group('Database cloud storage', () {
    test('Clear files', () async {
      // await client.s3cloudStorage.reset();
    });

    test('Store file 1', () async {
      await client.s3CloudStorage
          .storePublicFile('testdir/myfile1.bin', createByteData(256));
    });

    test('Store file 2', () async {
      await client.s3CloudStorage
          .storePublicFile('testdir/myfile2.bin', createByteData(256));
    });

    test('Replace file 1', () async {
      await client.s3CloudStorage
          .storePublicFile('testdir/myfile1.bin', createByteData(128));
    });

    test('Retrieve file 1', () async {
      var byteData =
          await client.s3CloudStorage.retrievePublicFile('testdir/myfile1.bin');
      expect(byteData!.lengthInBytes, equals(128));
      expect(verifyByteData(byteData), equals(true));
    });
    //
    //   test('Retrieve file 2 through URL', () async {
    //     var url = Uri.parse('http://localhost:8080/serverpod_cloud_storage?method=file&path=testdir/myfile2.bin');
    //     var response = await http.get(url);
    //     expect(response.statusCode, equals(200));
    //     var bytes = response.bodyBytes;
    //     expect(bytes.length, equals(256));
    //     verifyByteData(ByteData.view(bytes.buffer));
    //   });
    //
    test('Retrieve file 1 URL', () async {
      var urlStr = await client.s3CloudStorage
          .getPublicUrlForFile('testdir/myfile1.bin');
      expect(urlStr, isNotNull);
    });

    test('Retrieve file 2 through fetched URL', () async {
      var urlStr = await client.s3CloudStorage
          .getPublicUrlForFile('testdir/myfile2.bin');
      var url = Uri.parse(urlStr!);
      var response = await http.get(url);
      expect(response.statusCode, equals(200));
      var bytes = response.bodyBytes;
      expect(bytes.length, equals(256));
      verifyByteData(ByteData.view(bytes.buffer));
    });

    test('Retrieve file 2', () async {
      var byteData =
          await client.s3CloudStorage.retrievePublicFile('testdir/myfile2.bin');
      expect(byteData!.lengthInBytes, equals(256));
      expect(verifyByteData(byteData), equals(true));
    });

    test('Retrieve non existing file', () async {
      var byteData =
          await client.s3CloudStorage.retrievePublicFile('testdir/myfile3.bin');
      expect(byteData, isNull);
    });

    // test('Retrieve non existing file through URL', () async {
    //   var url = Uri.parse('http://localhost:8080/serverpod_cloud_storage?method=file&path=testdir/myfile3.bin');
    //   var response = await http.get(url);
    //   expect(response.statusCode, equals(404));
    //   var bytes = response.bodyBytes;
    //   expect(bytes.length, equals(0));
    // });
    //
    //   test('Attempt retrieve file through URL with invalid params', () async {
    //     var url = Uri.parse('http://localhost:8080/serverpod_cloud_storage?method=file&foo=testdir/myfile2.bin');
    //     var response = await http.get(url);
    //     // TODO: Actual response should probably be 400 (see server todo with verification of parameters).
    //     expect(response.statusCode, equals(500));
    //   });
    //
    //   test('Attempt retrieve file through URL with invalid method', () async {
    //     var url = Uri.parse('http://localhost:8080/serverpod_cloud_storage?foo=file&path=testdir/myfile2.bin');
    //     var response = await http.get(url);
    //     expect(response.statusCode, equals(400));
    //   });
    //
    test('Exists file 1', () async {
      var exists =
          await client.s3CloudStorage.existsPublicFile('testdir/myfile1.bin');
      expect(exists, true);
    });

    test('Exists non existing file', () async {
      var exists =
          await client.s3CloudStorage.existsPublicFile('testdir/myfile3.bin');
      expect(exists, false);
    });

    test('Delete file 1', () async {
      await client.s3CloudStorage.deletePublicFile('testdir/myfile1.bin');
    });

    test('Exists file 1 after deletion', () async {
      var exists =
          await client.s3CloudStorage.existsPublicFile('testdir/myfile1.bin');
      expect(exists, false);
    });

    test('Direct file upload', () async {
      var uploadDescription = await client.s3CloudStorage
          .getDirectFilePostUrl('testdir/directupload.bin');
      expect(uploadDescription, isNotNull);
      var byteData = createByteData(1024);

      var uploader = FileUploader(uploadDescription!);
      var result = await uploader.uploadByteData(byteData);

      expect(result, equals(true));

      var verified = await client.s3CloudStorage
          .verifyDirectFileUpload('testdir/directupload.bin');
      expect(verified, equals(true));
    });

    test('Retrieve directly uploaded file', () async {
      var byteData = await client.s3CloudStorage
          .retrievePublicFile('testdir/directupload.bin');
      expect(byteData!.lengthInBytes, equals(1024));
      expect(verifyByteData(byteData), equals(true));
    });
    //
    //   test('Direct file upload', () async {
    //     var urlStr = await client.cloudStorage.getDirectFilePostUrl('testdir/directupload.bin');
    //     expect(urlStr, isNotNull);
    //     var url = Uri.parse(urlStr!);
    //     var byteData = createByteData(1024);
    //     var result = await http.post(
    //       url,
    //       body: byteData.buffer.asUint8List(),
    //       headers: {
    //         'Content-Type': 'application/octet-stream',
    //         'Accept': '*/*',
    //       },
    //     );
    //     expect(result.statusCode, equals(200));
    //     expect(result.body, equals('true'));
    //
    //     var verified = await client.cloudStorage.verifyDirectFileUpload('testdir/directupload.bin');
    //     expect(verified, equals(true));
    //   });
    //
    //   test('Retrieve directly uploaded file', () async {
    //     var byteData = await client.cloudStorage.retrievePublicFile('testdir/directupload.bin');
    //     expect(byteData!.lengthInBytes, equals(1024));
    //     expect(verifyByteData(byteData), equals(true));
    //   });
    //
    //   test('Direct file upload with invalid key', () async {
    //     var urlStr = await client.cloudStorage.getDirectFilePostUrl('testdir/directupload.bin');
    //     expect(urlStr, isNotNull);
    //     var url = Uri.parse('http://localhost:8080/serverpod_cloud_storage?method=upload&storage=public&path=testdir%2Fdirectupload.bin&key=oAXvFnAGsYsaA5Wh');
    //     var byteData = createByteData(1024);
    //     var result = await http.post(
    //       url,
    //       body: byteData.buffer.asUint8List(),
    //       headers: {
    //         'Content-Type': 'application/octet-stream',
    //         'Accept': '*/*',
    //       },
    //     );
    //     expect(result.statusCode, equals(200));
    //     expect(result.body, equals('false'));
    //   });
  });
}
