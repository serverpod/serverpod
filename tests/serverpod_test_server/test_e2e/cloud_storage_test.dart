import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

Stream<int> streamBytes() async* {
  int i = 0;
  while (true) yield i++ % 256;
}

extension<T> on Stream<T> {
  Stream<List<T>> inChunksOf(int chunkSize) async* {
    var chunk = <T>[];
    await for (final e in this) {
      chunk.add(e);
      if (chunk.length >= chunkSize) {
        yield chunk;
        chunk = <T>[];
      }
    }
  }
}

ByteData createByteData(int len) {
  final ints = Uint8List(len);
  for (var i = 0; i < len; i++) {
    ints[i] = i % 256;
  }
  return ByteData.view(ints.buffer);
}

bool verifyByteData(ByteData byteData) {
  final ints = byteData.buffer.asUint8List();
  for (var i = 0; i < ints.length; i++) {
    if (ints[i] != i % 256) return false;
  }
  return true;
}

void main() {
  final client = Client(serverUrl);

  group('Given the database cloud storage with no stored files', () {
    setUp(() async {
      await client.cloudStorage.reset();
    });

    tearDown(() async {
      await client.cloudStorage.reset();
    });

    test(
      'when a public file is stored, '
      'then it can be retrieved with its original contents',
      () async {
        const path = 'testdir/myfile.bin';

        await client.cloudStorage.storePublicFile(
          path,
          createByteData(256),
        );
        final actual = await client.cloudStorage.retrievePublicFile(path);

        expect(actual.lengthInBytes, 256);
        expect(verifyByteData(actual), isTrue);
      },
    );

    test(
      'when a missing file is retrieved, '
      'then a ServerpodClientException is thrown',
      () async {
        await expectLater(
          () => client.cloudStorage.retrievePublicFile(
            'testdir/missing.bin',
          ),
          throwsA(isA<ServerpodClientException>()),
        );
      },
    );

    test(
      'when a missing file is retrieved through the storage route, '
      'then the response status is 404',
      () async {
        final url = Uri.parse(
          '${serverUrl}serverpod_cloud_storage?method=file&path=testdir/missing.bin',
        );

        final response = await http.get(url);

        expect(response.statusCode, 404);
      },
    );

    test(
      'when file existence is checked for a missing file, '
      'then it returns false',
      () async {
        final exists = await client.cloudStorage.existsPublicFile(
          'testdir/missing.bin',
        );

        expect(exists, isFalse);
      },
    );
  });

  group('Given the database cloud storage with an existing public file', () {
    const path = 'testdir/myfile.bin';

    setUp(() async {
      await client.cloudStorage.storePublicFile(
        path,
        createByteData(256),
      );
    });

    tearDown(() async {
      await client.cloudStorage.reset();
    });

    test(
      'when the file is replaced, '
      'then the replacement contents can be retrieved',
      () async {
        await client.cloudStorage.storePublicFile(
          path,
          createByteData(128),
        );

        final actual = await client.cloudStorage.retrievePublicFile(path);

        expect(actual.lengthInBytes, 128);
        expect(verifyByteData(actual), isTrue);
      },
    );

    test(
      'when the file is retrieved through the storage route, '
      'then the response contains the file contents',
      () async {
        final url = Uri.parse(
          '${serverUrl}serverpod_cloud_storage?method=file&path=$path',
        );

        final response = await http.get(url);

        expect(response.statusCode, 200);
        expect(response.bodyBytes.length, 256);
        expect(
          verifyByteData(ByteData.view(response.bodyBytes.buffer)),
          isTrue,
        );
      },
    );

    test(
      'when its public download URL is requested, '
      'then a URL is returned',
      () async {
        final url = await client.cloudStorage.publicDownloadUrlForFile(path);

        expect(url, isNotEmpty);
      },
    );

    test(
      'when it is fetched through its public download URL, '
      'then the response contains the file contents',
      () async {
        final url = await client.cloudStorage.publicDownloadUrlForFile(path);

        final response = await http.get(Uri.parse(url));

        expect(response.statusCode, 200);
        expect(response.bodyBytes.length, 256);
        expect(
          verifyByteData(ByteData.view(response.bodyBytes.buffer)),
          isTrue,
        );
      },
    );

    test(
      'when it is fetched through a temporary download URL, '
      'then the response contains the file contents',
      () async {
        final url = await client.cloudStorage.temporaryDownloadUrlForFile(
          path,
        );

        final response = await http.get(Uri.parse(url));

        expect(response.statusCode, 200);
        expect(response.bodyBytes.length, 256);
        expect(
          verifyByteData(ByteData.view(response.bodyBytes.buffer)),
          isTrue,
        );
      },
    );

    test(
      'when file existence is checked, '
      'then it returns true',
      () async {
        final exists = await client.cloudStorage.existsPublicFile(path);

        expect(exists, isTrue);
      },
    );

    test(
      'when it is deleted, '
      'then it no longer exists',
      () async {
        await client.cloudStorage.deletePublicFile(path);

        final exists = await client.cloudStorage.existsPublicFile(path);

        expect(exists, isFalse);
      },
    );
  });

  group('Given an invalid storage route request', () {
    test(
      'when the path parameter is missing, '
      'then the response status is 400',
      () async {
        final url = Uri.parse(
          '${serverUrl}serverpod_cloud_storage?method=file&foo=testdir/myfile.bin',
        );

        final response = await http.get(url);

        expect(response.statusCode, 400);
      },
    );

    test(
      'when the method parameter is missing, '
      'then the response status is 400',
      () async {
        final url = Uri.parse(
          '${serverUrl}serverpod_cloud_storage?foo=file&path=testdir/myfile.bin',
        );

        final response = await http.get(url);

        expect(response.statusCode, 400);
      },
    );
  });

  group(
    'Given the database cloud storage with a direct file upload description',
    () {
      const path = 'testdir/directupload.bin';
      late String uploadDescription;

      setUp(() async {
        uploadDescription = await client.cloudStorage
            .createUploadDescriptionForFile(path);
      });

      tearDown(() async {
        await client.cloudStorage.reset();
      });

      test(
        'when ByteData is uploaded, '
        'then the upload succeeds and can be verified and retrieved',
        () async {
          final uploader = FileUploader(uploadDescription);

          final uploaded = await uploader.uploadByteData(
            createByteData(1024),
          );
          final verified = await client.cloudStorage.verifyUpload(path);

          expect(uploaded, isTrue);
          expect(verified, isTrue);

          final byteData = await client.cloudStorage.retrievePublicFile(path);

          expect(byteData.lengthInBytes, 1024);
          expect(verifyByteData(byteData), isTrue);
        },
      );

      test(
        'when a byte stream is uploaded, '
        'then it can be verified and retrieved',
        () async {
          final uploader = FileUploader(uploadDescription);

          final uploaded = await uploader.upload(
            streamBytes().take(512).inChunksOf(64),
          );
          final verified = await client.cloudStorage.verifyUpload(path);
          final byteData = await client.cloudStorage.retrievePublicFile(path);

          expect(uploaded, isTrue);
          expect(verified, isTrue);
          expect(byteData.lengthInBytes, 512);
          expect(verifyByteData(byteData), isTrue);
        },
      );

      test(
        'when the same FileUploader uploads data twice, '
        'then the second upload throws an exception',
        () async {
          final byteData = createByteData(100);
          final uploader = FileUploader(uploadDescription);
          final firstUpload = await uploader.uploadByteData(byteData);

          expect(firstUpload, isTrue);
          await expectLater(
            () => uploader.uploadByteData(byteData),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains(
                  'Data has already been uploaded using this FileUploader.',
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
