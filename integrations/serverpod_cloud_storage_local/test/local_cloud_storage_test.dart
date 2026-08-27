import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_local/serverpod_cloud_storage_local.dart';
import 'package:test/test.dart';

class MockSession extends Mock implements Session {}

class MockServer extends Mock implements Server {}

class MockServerpod extends Mock implements Serverpod {}

/// Creates test ByteData of the specified length with predictable content.
ByteData createByteData(int length) {
  var bytes = Uint8List(length);
  for (var i = 0; i < length; i++) {
    bytes[i] = i % 256;
  }
  return ByteData.sublistView(bytes);
}

void main() {
  late Directory tempDir;
  late MockSession session;
  late LocalCloudStorage storage;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('local_storage_test_');
    session = MockSession();
    storage = LocalCloudStorage('test', storagePath: tempDir.path);
  });

  tearDown(() async {
    storage.stopCleanupScheduler();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Given a path that escapes the storage directory', () {
    for (var path in [
      '../outside.txt',
      '../../../etc/passwd',
      '..',
      'foo/../../outside.txt',
      r'..\..\outside.txt',
      r'foo\..\..\outside.txt',
    ]) {
      test('when storing a file at "$path" then it throws', () async {
        await expectLater(
          storage.storeFile(
            session: session,
            path: path,
            byteData: createByteData(16),
          ),
          throwsA(isA<CloudStorageException>()),
        );
      });
    }

    test('when retrieving, checking, or deleting then it throws', () async {
      await expectLater(
        storage.retrieveFile(session: session, path: '../outside.txt'),
        throwsA(isA<CloudStorageException>()),
      );
      await expectLater(
        storage.fileExists(session: session, path: '../outside.txt'),
        throwsA(isA<CloudStorageException>()),
      );
      await expectLater(
        storage.deleteFile(session: session, path: '../outside.txt'),
        throwsA(isA<CloudStorageException>()),
      );
    });
  });

  group('Given an empty or root path', () {
    for (var path in ['', '.', '/', '//', './']) {
      test('when storing a file at "$path" then it throws', () async {
        await expectLater(
          storage.storeFile(
            session: session,
            path: path,
            byteData: createByteData(16),
          ),
          throwsA(isA<CloudStorageException>()),
        );
      });
    }
  });

  group('Given a path with unsupported segments', () {
    for (var path in [
      'foo:bar.txt',
      'C:/file.txt',
      r'C:\file.txt',
      'trailing./file.txt',
      'file.txt.',
      'file.txt ',
    ]) {
      test('when storing a file at "$path" then it throws', () async {
        await expectLater(
          storage.storeFile(
            session: session,
            path: path,
            byteData: createByteData(16),
          ),
          throwsA(isA<CloudStorageException>()),
        );
      });
    }
  });

  group('Given a path with the reserved metadata suffix', () {
    for (var path in [
      'file.meta',
      'dir/file.meta',
      'file.META',
      'file.Meta',
      'dir.meta/file.txt',
    ]) {
      test('when storing a file at "$path" then it throws', () async {
        await expectLater(
          storage.storeFile(
            session: session,
            path: path,
            byteData: createByteData(16),
          ),
          throwsA(isA<CloudStorageException>()),
        );
      });

      test('when retrieving a file at "$path" then it throws', () async {
        await expectLater(
          storage.retrieveFile(session: session, path: path),
          throwsA(isA<CloudStorageException>()),
        );
      });
    }
  });

  group('Given an absolute path', () {
    test(
      'when storing a file then it is stored inside the storage directory',
      () async {
        await storage.storeFile(
          session: session,
          path: '/absolute/file.txt',
          byteData: createByteData(16),
        );

        expect(
          await File(p.join(tempDir.path, 'absolute', 'file.txt')).exists(),
          isTrue,
        );
      },
    );
  });

  group('Given a path with redundant segments', () {
    test(
      'when storing a file then internal ".." segments are resolved',
      () async {
        await storage.storeFile(
          session: session,
          path: 'foo/bar/../baz.txt',
          byteData: createByteData(16),
        );

        expect(
          await File(p.join(tempDir.path, 'foo', 'baz.txt')).exists(),
          isTrue,
        );
      },
    );

    test('when storing a file then "." segments are ignored', () async {
      await storage.storeFile(
        session: session,
        path: './foo/./file.txt',
        byteData: createByteData(16),
      );

      expect(
        await File(p.join(tempDir.path, 'foo', 'file.txt')).exists(),
        isTrue,
      );
    });
  });

  group('Given a file to store', () {
    test(
      'when storing and retrieving it then the content is identical',
      () async {
        var byteData = createByteData(1024);

        await storage.storeFile(
          session: session,
          path: 'dir/file.bin',
          byteData: byteData,
        );
        var retrieved = await storage.retrieveFile(
          session: session,
          path: 'dir/file.bin',
        );

        expect(retrieved, isNotNull);
        expect(
          Uint8List.sublistView(retrieved!),
          Uint8List.sublistView(byteData),
        );
      },
    );

    test('when storing a ByteData view with a non-zero offset '
        'then only the viewed bytes are stored', () async {
      var bytes = Uint8List.fromList(List.generate(100, (i) => i));
      var view = ByteData.sublistView(bytes, 10, 60);

      await storage.storeFile(
        session: session,
        path: 'view.bin',
        byteData: view,
      );
      var retrieved = await storage.retrieveFile(
        session: session,
        path: 'view.bin',
      );

      expect(Uint8List.sublistView(retrieved!), bytes.sublist(10, 60));
    });

    test('when storing a large file then it round-trips intact', () async {
      var byteData = createByteData(1024 * 1024);

      await storage.storeFile(
        session: session,
        path: 'large.bin',
        byteData: byteData,
      );
      var retrieved = await storage.retrieveFile(
        session: session,
        path: 'large.bin',
      );

      expect(retrieved!.lengthInBytes, 1024 * 1024);
      expect(
        Uint8List.sublistView(retrieved),
        Uint8List.sublistView(byteData),
      );
    });

    test(
      'when storing to a nested path then parent directories are created',
      () async {
        await storage.storeFile(
          session: session,
          path: 'a/b/c/file.txt',
          byteData: createByteData(16),
        );

        expect(
          await File(p.join(tempDir.path, 'a', 'b', 'c', 'file.txt')).exists(),
          isTrue,
        );
      },
    );

    test(
      'when storing to a path with spaces and unicode then it round-trips',
      () async {
        var path = 'dir with spaces/fil. övrigt 文件.bin';
        var byteData = createByteData(64);

        await storage.storeFile(
          session: session,
          path: path,
          byteData: byteData,
        );
        var retrieved = await storage.retrieveFile(
          session: session,
          path: path,
        );

        expect(retrieved, isNotNull);
        expect(
          Uint8List.sublistView(retrieved!),
          Uint8List.sublistView(byteData),
        );
      },
    );

    test(
      'when overwriting an existing file then the content is replaced',
      () async {
        await storage.storeFile(
          session: session,
          path: 'file.bin',
          byteData: ByteData.sublistView(Uint8List.fromList([1, 2, 3])),
        );
        await storage.storeFile(
          session: session,
          path: 'file.bin',
          byteData: ByteData.sublistView(Uint8List.fromList([4, 5])),
        );

        var retrieved = await storage.retrieveFile(
          session: session,
          path: 'file.bin',
        );
        expect(Uint8List.sublistView(retrieved!), [4, 5]);
      },
    );
  });

  group('Given a stored file', () {
    setUp(() async {
      await storage.storeFile(
        session: session,
        path: 'file.bin',
        byteData: createByteData(16),
      );
    });

    test('when checking existence then it returns true', () async {
      expect(
        await storage.fileExists(session: session, path: 'file.bin'),
        isTrue,
      );
    });

    test('when deleting it then it no longer exists', () async {
      await storage.deleteFile(session: session, path: 'file.bin');

      expect(
        await storage.fileExists(session: session, path: 'file.bin'),
        isFalse,
      );
      expect(await File(p.join(tempDir.path, 'file.bin')).exists(), isFalse);
    });

    test('when retrieving its size then the size is returned', () async {
      expect(
        await storage.getFileSize(session: session, path: 'file.bin'),
        16,
      );
    });
  });

  group('Given a missing file', () {
    test('when retrieving it then null is returned', () async {
      expect(
        await storage.retrieveFile(session: session, path: 'missing.bin'),
        isNull,
      );
    });

    test('when checking existence then it returns false', () async {
      expect(
        await storage.fileExists(session: session, path: 'missing.bin'),
        isFalse,
      );
    });

    test('when deleting it then no error is thrown', () async {
      await storage.deleteFile(session: session, path: 'missing.bin');
    });

    test('when retrieving its size then null is returned', () async {
      expect(
        await storage.getFileSize(session: session, path: 'missing.bin'),
        isNull,
      );
    });
  });

  group('Given a file stored with a future expiration', () {
    setUp(() async {
      await storage.storeFile(
        session: session,
        path: 'expiring.bin',
        byteData: createByteData(16),
        expiration: DateTime.now().add(const Duration(hours: 1)),
      );
    });

    test('when retrieving it then it is still available', () async {
      expect(
        await storage.retrieveFile(session: session, path: 'expiring.bin'),
        isNotNull,
      );
    });

    test('then a metadata sidecar file exists', () async {
      expect(
        await File(p.join(tempDir.path, 'expiring.bin.meta')).exists(),
        isTrue,
      );
    });

    test('when overwriting it without an expiration '
        'then the stale metadata is removed', () async {
      await storage.storeFile(
        session: session,
        path: 'expiring.bin',
        byteData: createByteData(16),
      );

      expect(
        await File(p.join(tempDir.path, 'expiring.bin.meta')).exists(),
        isFalse,
      );
    });
  });

  group('Given a file stored with a past expiration', () {
    setUp(() async {
      await storage.storeFile(
        session: session,
        path: 'expired.bin',
        byteData: createByteData(16),
        expiration: DateTime.now().subtract(const Duration(hours: 1)),
      );
    });

    test('when retrieving it then null is returned', () async {
      expect(
        await storage.retrieveFile(session: session, path: 'expired.bin'),
        isNull,
      );
    });

    test('when checking existence then it returns false', () async {
      expect(
        await storage.fileExists(session: session, path: 'expired.bin'),
        isFalse,
      );
    });

    test('when retrieving it as a stream then null is returned', () async {
      expect(
        await storage.retrieveFileStream(session: session, path: 'expired.bin'),
        isNull,
      );
    });

    test('when retrieving its size then null is returned', () async {
      expect(
        await storage.getFileSize(session: session, path: 'expired.bin'),
        isNull,
      );
    });
  });

  group('Given a file stored as unverified', () {
    setUp(() async {
      await storage.storeFile(
        session: session,
        path: 'unverified.bin',
        byteData: createByteData(16),
        verified: false,
      );
    });

    test('when retrieving it then null is returned', () async {
      expect(
        await storage.retrieveFile(session: session, path: 'unverified.bin'),
        isNull,
      );
    });

    test('when verifying it '
        'then it returns true and the file becomes available', () async {
      var verified = await storage.verifyDirectFileUpload(
        session: session,
        path: 'unverified.bin',
      );

      expect(verified, isTrue);
      expect(
        await storage.retrieveFile(session: session, path: 'unverified.bin'),
        isNotNull,
      );
    });

    test(
      'when verifying it twice then the second call returns false',
      () async {
        await storage.verifyDirectFileUpload(
          session: session,
          path: 'unverified.bin',
        );

        expect(
          await storage.verifyDirectFileUpload(
            session: session,
            path: 'unverified.bin',
          ),
          isFalse,
        );
      },
    );
  });

  group('Given a file stored as unverified with an expiration', () {
    setUp(() async {
      await storage.storeFile(
        session: session,
        path: 'pending.bin',
        byteData: createByteData(16),
        expiration: DateTime.now().add(const Duration(hours: 1)),
        verified: false,
      );
    });

    test('when verifying it then the expiration is retained', () async {
      await storage.verifyDirectFileUpload(
        session: session,
        path: 'pending.bin',
      );

      var metadataFile = File(p.join(tempDir.path, 'pending.bin.meta'));
      expect(await metadataFile.exists(), isTrue);
      var metadata = jsonDecode(await metadataFile.readAsString());
      expect(metadata['verified'], isTrue);
      expect(metadata['expiration'], isNotNull);
    });
  });

  group('Given a verified file without metadata', () {
    setUp(() async {
      await storage.storeFile(
        session: session,
        path: 'plain.bin',
        byteData: createByteData(16),
      );
    });

    test('then no metadata sidecar file is written', () async {
      expect(
        await File(p.join(tempDir.path, 'plain.bin.meta')).exists(),
        isFalse,
      );
    });

    test('when verifying it then it returns false', () async {
      expect(
        await storage.verifyDirectFileUpload(
          session: session,
          path: 'plain.bin',
        ),
        isFalse,
      );
    });
  });

  group('Given a missing file', () {
    test('when verifying it then it returns false', () async {
      expect(
        await storage.verifyDirectFileUpload(
          session: session,
          path: 'missing.bin',
        ),
        isFalse,
      );
    });
  });

  group('Given a file with corrupt metadata', () {
    for (var (description, content) in [
      ('invalid json', 'not valid json'),
      ('json of the wrong shape', '[1, 2, 3]'),
      ('a wrong typed expiration', '{"verified": true, "expiration": 123}'),
      ('a wrong typed verified flag', '{"verified": "yes"}'),
    ]) {
      test(
        'when the metadata contains $description '
        'then retrieving the file returns null (fails closed)',
        () async {
          await storage.storeFile(
            session: session,
            path: 'corrupt.bin',
            byteData: createByteData(16),
          );
          await File(
            p.join(tempDir.path, 'corrupt.bin.meta'),
          ).writeAsString(content);

          expect(
            await storage.retrieveFile(session: session, path: 'corrupt.bin'),
            isNull,
          );
        },
      );
    }
  });

  group('Given a public storage', () {
    late LocalCloudStorage publicStorage;

    setUp(() async {
      var server = MockServer();
      var serverpod = MockServerpod();
      when(() => session.server).thenReturn(server);
      when(() => server.serverpod).thenReturn(serverpod);
      when(() => serverpod.config).thenReturn(
        ServerpodConfig(
          apiServer: ServerConfig(
            port: 8080,
            publicHost: 'localhost',
            publicPort: 8080,
            publicScheme: 'http',
          ),
        ),
      );

      publicStorage = LocalCloudStorage('public', storagePath: tempDir.path);
      await publicStorage.storeFile(
        session: session,
        path: 'image.png',
        byteData: createByteData(16),
      );
    });

    test('when getting the public URL of a stored file then it is served '
        'through the serverpod_cloud_storage endpoint', () async {
      var url = await publicStorage.getPublicUrl(
        session: session,
        path: 'image.png',
      );

      expect(url, isNotNull);
      expect(url!.scheme, 'http');
      expect(url.host, 'localhost');
      expect(url.port, 8080);
      expect(url.path, '/serverpod_cloud_storage');
      expect(url.queryParameters, {'method': 'file', 'path': 'image.png'});
    });

    test(
      'when getting the public URL of a missing file then null is returned',
      () async {
        expect(
          await publicStorage.getPublicUrl(
            session: session,
            path: 'missing.png',
          ),
          isNull,
        );
      },
    );
  });

  group('Given a non-public storage', () {
    test('when getting a public URL then null is returned', () async {
      await storage.storeFile(
        session: session,
        path: 'file.bin',
        byteData: createByteData(16),
      );

      expect(
        await storage.getPublicUrl(session: session, path: 'file.bin'),
        isNull,
      );
    });
  });

  group('Given direct file uploads', () {
    test('when creating an upload description then null is returned', () async {
      expect(
        await storage.createDirectFileUploadDescription(
          session: session,
          path: 'upload.bin',
        ),
        isNull,
      );
    });

    test('when creating an upload description with options '
        'within the size limit then null is returned', () async {
      expect(
        await storage.createDirectFileUploadDescriptionWithOptions(
          session: session,
          path: 'upload.bin',
          options: const CloudStorageOptions(contentLength: 1024),
        ),
        isNull,
      );
    });

    test('when creating an upload description with a content length '
        'exceeding the maximum file size then it throws', () async {
      await expectLater(
        storage.createDirectFileUploadDescriptionWithOptions(
          session: session,
          path: 'upload.bin',
          maxFileSize: 1024,
          options: const CloudStorageOptions(contentLength: 2048),
        ),
        throwsA(isA<CloudStorageException>()),
      );
    });
  });

  group('Given storing with options', () {
    test('when preventOverwrite is enabled and the file does not exist '
        'then the file is stored', () async {
      await storage.storeFileWithOptions(
        session: session,
        path: 'new.bin',
        byteData: createByteData(16),
        options: const CloudStorageOptions(preventOverwrite: true),
      );

      expect(
        await storage.fileExists(session: session, path: 'new.bin'),
        isTrue,
      );
    });

    test('when preventOverwrite is enabled and the file exists '
        'then it throws and the file is unchanged', () async {
      await storage.storeFile(
        session: session,
        path: 'existing.bin',
        byteData: ByteData.sublistView(Uint8List.fromList([1, 2, 3])),
      );

      await expectLater(
        storage.storeFileWithOptions(
          session: session,
          path: 'existing.bin',
          byteData: ByteData.sublistView(Uint8List.fromList([4, 5, 6])),
          options: const CloudStorageOptions(preventOverwrite: true),
        ),
        throwsA(isA<CloudStorageException>()),
      );

      var retrieved = await storage.retrieveFile(
        session: session,
        path: 'existing.bin',
      );
      expect(Uint8List.sublistView(retrieved!), [1, 2, 3]);
    });

    test('when preventOverwrite is disabled and the file exists '
        'then the file is overwritten', () async {
      await storage.storeFile(
        session: session,
        path: 'existing.bin',
        byteData: ByteData.sublistView(Uint8List.fromList([1, 2, 3])),
      );

      await storage.storeFileWithOptions(
        session: session,
        path: 'existing.bin',
        byteData: ByteData.sublistView(Uint8List.fromList([4, 5, 6])),
        options: const CloudStorageOptions(),
      );

      var retrieved = await storage.retrieveFile(
        session: session,
        path: 'existing.bin',
      );
      expect(Uint8List.sublistView(retrieved!), [4, 5, 6]);
    });

    test('when preventOverwrite is enabled and an unverified file exists '
        'then the file is stored', () async {
      await storage.storeFile(
        session: session,
        path: 'unverified.bin',
        byteData: createByteData(16),
        verified: false,
      );

      await storage.storeFileWithOptions(
        session: session,
        path: 'unverified.bin',
        byteData: createByteData(16),
        options: const CloudStorageOptions(preventOverwrite: true),
      );

      expect(
        await storage.fileExists(session: session, path: 'unverified.bin'),
        isTrue,
      );
    });

    test('when preventOverwrite is enabled and an expired file exists '
        'then the file is stored', () async {
      await storage.storeFile(
        session: session,
        path: 'expired.bin',
        byteData: createByteData(16),
        expiration: DateTime.now().subtract(const Duration(hours: 1)),
      );

      await storage.storeFileWithOptions(
        session: session,
        path: 'expired.bin',
        byteData: createByteData(16),
        options: const CloudStorageOptions(preventOverwrite: true),
      );

      expect(
        await storage.fileExists(session: session, path: 'expired.bin'),
        isTrue,
      );
    });
  });

  group('Given a file stored from a stream', () {
    test('when retrieving it then the content is identical', () async {
      var byteData = createByteData(256 * 1024);
      var bytes = Uint8List.sublistView(byteData);
      var chunks = <List<int>>[
        for (var i = 0; i < bytes.length; i += 64 * 1024)
          bytes.sublist(
            i,
            i + 64 * 1024 > bytes.length ? bytes.length : i + 64 * 1024,
          ),
      ];

      await storage.storeFileStream(
        session: session,
        path: 'streamed.bin',
        stream: Stream.fromIterable(chunks),
      );

      var retrieved = await storage.retrieveFile(
        session: session,
        path: 'streamed.bin',
      );
      expect(Uint8List.sublistView(retrieved!), bytes);
    });

    test(
      'when retrieving it as a stream then the content is identical',
      () async {
        var byteData = createByteData(1024);
        await storage.storeFile(
          session: session,
          path: 'streamed.bin',
          byteData: byteData,
        );

        var stream = await storage.retrieveFileStream(
          session: session,
          path: 'streamed.bin',
        );
        expect(stream, isNotNull);

        var builder = BytesBuilder(copy: false);
        await for (var chunk in stream!) {
          builder.add(chunk);
        }
        expect(builder.takeBytes(), Uint8List.sublistView(byteData));
      },
    );

    test(
      'when the source stream errors then no partial file is left behind',
      () async {
        Stream<List<int>> brokenStream() async* {
          yield <int>[1, 2, 3];
          throw Exception('source stream error');
        }

        await expectLater(
          storage.storeFileStream(
            session: session,
            path: 'partial.bin',
            stream: brokenStream(),
          ),
          throwsA(isA<CloudStorageException>()),
        );

        expect(
          await File(p.join(tempDir.path, 'partial.bin')).exists(),
          isFalse,
        );
        expect(
          await storage.fileExists(session: session, path: 'partial.bin'),
          isFalse,
        );
      },
    );

    test('when storing with an expiration then metadata is written', () async {
      await storage.storeFileStream(
        session: session,
        path: 'streamed.bin',
        stream: Stream.fromIterable([
          [1, 2, 3],
        ]),
        expiration: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(
        await File(p.join(tempDir.path, 'streamed.bin.meta')).exists(),
        isTrue,
      );
    });
  });

  group('Given expired and non-expired files', () {
    setUp(() async {
      await storage.storeFile(
        session: session,
        path: 'expired.bin',
        byteData: createByteData(16),
        expiration: DateTime.now().subtract(const Duration(hours: 1)),
      );
      await storage.storeFile(
        session: session,
        path: 'nested/also_expired.bin',
        byteData: createByteData(16),
        expiration: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      await storage.storeFile(
        session: session,
        path: 'fresh.bin',
        byteData: createByteData(16),
        expiration: DateTime.now().add(const Duration(hours: 1)),
      );
      await storage.storeFile(
        session: session,
        path: 'forever.bin',
        byteData: createByteData(16),
      );
    });

    test('when cleaning up expired files '
        'then only the expired files and their metadata are deleted', () async {
      var deletedCount = await storage.cleanupExpiredFiles();

      expect(deletedCount, 2);
      expect(await File(p.join(tempDir.path, 'expired.bin')).exists(), isFalse);
      expect(
        await File(p.join(tempDir.path, 'expired.bin.meta')).exists(),
        isFalse,
      );
      expect(
        await File(p.join(tempDir.path, 'nested', 'also_expired.bin')).exists(),
        isFalse,
      );
      expect(await File(p.join(tempDir.path, 'fresh.bin')).exists(), isTrue);
      expect(
        await File(p.join(tempDir.path, 'fresh.bin.meta')).exists(),
        isTrue,
      );
      expect(await File(p.join(tempDir.path, 'forever.bin')).exists(), isTrue);
    });
  });

  group('Given a cleanup run', () {
    test(
      'when the storage directory does not exist then it returns zero',
      () async {
        var emptyStorage = LocalCloudStorage(
          'test',
          storagePath: p.join(tempDir.path, 'does_not_exist'),
        );

        expect(await emptyStorage.cleanupExpiredFiles(), 0);
      },
    );

    test('when a metadata file is corrupt then it is skipped', () async {
      await storage.storeFile(
        session: session,
        path: 'file.bin',
        byteData: createByteData(16),
      );
      await File(
        p.join(tempDir.path, 'file.bin.meta'),
      ).writeAsString('not valid json');

      expect(await storage.cleanupExpiredFiles(), 0);
      expect(await File(p.join(tempDir.path, 'file.bin')).exists(), isTrue);
    });

    test('when an unverified file has no expiration then it is kept', () async {
      await storage.storeFile(
        session: session,
        path: 'unverified.bin',
        byteData: createByteData(16),
        verified: false,
      );

      expect(await storage.cleanupExpiredFiles(), 0);
      expect(
        await File(p.join(tempDir.path, 'unverified.bin')).exists(),
        isTrue,
      );
    });
  });

  group('Given the cleanup scheduler', () {
    test('when starting and stopping it then its state is reported', () async {
      expect(storage.isCleanupSchedulerRunning, isFalse);

      storage.startCleanupScheduler(const Duration(hours: 1));
      expect(storage.isCleanupSchedulerRunning, isTrue);

      storage.stopCleanupScheduler();
      expect(storage.isCleanupSchedulerRunning, isFalse);
    });

    test('when starting it twice then it remains running', () async {
      storage.startCleanupScheduler(const Duration(hours: 1));
      storage.startCleanupScheduler(const Duration(hours: 1));
      expect(storage.isCleanupSchedulerRunning, isTrue);

      storage.stopCleanupScheduler();
      expect(storage.isCleanupSchedulerRunning, isFalse);
    });

    test(
      'when the interval elapses then expired files are cleaned up',
      () async {
        await storage.storeFile(
          session: session,
          path: 'expired.bin',
          byteData: createByteData(16),
          expiration: DateTime.now().subtract(const Duration(hours: 1)),
        );

        storage.startCleanupScheduler(const Duration(milliseconds: 20));

        // Poll instead of using a fixed delay, to stay robust on slow CI
        // runners.
        var file = File(p.join(tempDir.path, 'expired.bin'));
        var deadline = DateTime.now().add(const Duration(seconds: 10));
        while (await file.exists() && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
        storage.stopCleanupScheduler();

        expect(
          await File(p.join(tempDir.path, 'expired.bin')).exists(),
          isFalse,
        );
      },
    );
  });
}
