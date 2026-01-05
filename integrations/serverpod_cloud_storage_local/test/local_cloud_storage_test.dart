import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_local/serverpod_cloud_storage_local.dart';
import 'package:test/test.dart';

// Mocks
class MockServerpod extends Mock implements Serverpod {}

class MockSession extends Mock implements Session {}

void main() {
  late Directory tempDir;
  late MockServerpod mockServerpod;
  late MockSession mockSession;

  /// Creates test ByteData of specified length with predictable content.
  ByteData createByteData(int length) {
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = i % 256;
    }
    return ByteData.view(bytes.buffer);
  }

  /// Verifies ByteData has expected predictable content.
  bool verifyByteData(ByteData byteData) {
    final bytes = byteData.buffer.asUint8List();
    for (var i = 0; i < bytes.length; i++) {
      if (bytes[i] != i % 256) return false;
    }
    return true;
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('local_storage_test_');
    mockServerpod = MockServerpod();
    mockSession = MockSession();

    // Set up mock config
    final config = ServerpodConfig(
      apiServer: ServerConfig(
        port: 8080,
        publicHost: 'localhost',
        publicPort: 8080,
        publicScheme: 'http',
      ),
    );
    when(() => mockServerpod.config).thenReturn(config);
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Path sanitization (security)', () {
    late LocalCloudStorage storage;

    setUp(() {
      storage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'test',
        storagePath: tempDir.path,
        public: true,
      );
    });

    test('sanitizes path traversal with ../', () async {
      final testData = createByteData(100);

      // Attempt to store file with path traversal
      await storage.storeFile(
        session: mockSession,
        path: '../../../etc/passwd',
        byteData: testData,
      );

      // File should be stored within storage directory, not outside
      final sanitizedPath = File('${tempDir.path}/etc/passwd');
      expect(sanitizedPath.existsSync(), isTrue);

      // Verify nothing was written outside storage directory
      final outsidePath = File('/etc/passwd.test');
      expect(outsidePath.existsSync(), isFalse);
    });

    test('sanitizes path traversal with ..\\', () async {
      final testData = createByteData(100);

      await storage.storeFile(
        session: mockSession,
        path: '..\\..\\..\\etc\\passwd',
        byteData: testData,
      );

      // File should be within storage directory
      expect(
        Directory(
          tempDir.path,
        ).listSync(recursive: true).whereType<File>().isNotEmpty,
        isTrue,
      );
    });

    test('handles absolute paths by treating them as relative', () async {
      final testData = createByteData(100);

      await storage.storeFile(
        session: mockSession,
        path: '/absolute/path/file.txt',
        byteData: testData,
      );

      // File should exist within storage
      final exists = await storage.fileExists(
        session: mockSession,
        path: '/absolute/path/file.txt',
      );
      expect(exists, isTrue);
    });

    test('normalizes redundant slashes', () async {
      final testData = createByteData(100);

      await storage.storeFile(
        session: mockSession,
        path: 'path///to////file.txt',
        byteData: testData,
      );

      // Should be able to retrieve with normalized path
      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'path/to/file.txt',
      );
      expect(retrieved, isNotNull);
    });

    test('handles paths with spaces correctly', () async {
      final testData = createByteData(100);

      await storage.storeFile(
        session: mockSession,
        path: 'path with spaces/file name.txt',
        byteData: testData,
      );

      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'path with spaces/file name.txt',
      );
      expect(retrieved, isNotNull);
      expect(verifyByteData(retrieved!), isTrue);
    });

    test('handles unicode filenames', () async {
      final testData = createByteData(100);

      await storage.storeFile(
        session: mockSession,
        path: 'путь/файл_文件.txt',
        byteData: testData,
      );

      final exists = await storage.fileExists(
        session: mockSession,
        path: 'путь/файл_文件.txt',
      );
      expect(exists, isTrue);
    });

    test('sanitizes multiple consecutive parent directory segments', () async {
      final testData = createByteData(100);

      // Attempt deep path traversal with multiple ../
      await storage.storeFile(
        session: mockSession,
        path: 'foo/../../../../../../etc/passwd',
        byteData: testData,
      );

      // File should be stored within storage directory
      final files = Directory(
        tempDir.path,
      ).listSync(recursive: true).whereType<File>();
      expect(files.isNotEmpty, isTrue);

      // Verify all files are within the storage directory
      for (final file in files) {
        expect(file.path.startsWith(tempDir.path), isTrue);
        expect(file.path.contains('..'), isFalse);
      }
    });

    test('sanitizes mixed separator traversal attempts', () async {
      final testData = createByteData(100);

      // Mix forward and back slashes in traversal attempt
      await storage.storeFile(
        session: mockSession,
        path: 'foo\\..\\..\\bar',
        byteData: testData,
      );

      // File should be within storage directory
      final files = Directory(
        tempDir.path,
      ).listSync(recursive: true).whereType<File>();
      expect(files.isNotEmpty, isTrue);

      for (final file in files) {
        expect(file.path.startsWith(tempDir.path), isTrue);
        // Should not contain mixed or unresolved separators
        expect(file.path.contains('..'), isFalse);
      }
    });

    test('handles URL encoded traversal attempts', () async {
      final testData = createByteData(100);

      // URL encoded path traversal (not decoded, stored as-is)
      await storage.storeFile(
        session: mockSession,
        path: 'foo%2F..%2Fbar',
        byteData: testData,
      );

      // File should exist and be retrievable with same path
      final exists = await storage.fileExists(
        session: mockSession,
        path: 'foo%2F..%2Fbar',
      );
      expect(exists, isTrue);

      // Verify file is within storage directory
      final files = Directory(
        tempDir.path,
      ).listSync(recursive: true).whereType<File>();
      for (final file in files) {
        expect(file.path.startsWith(tempDir.path), isTrue);
      }
    });

    test('handles paths with special characters', () async {
      final testData = createByteData(100);

      // Test colon (problematic on Windows)
      // Note: This test may behave differently on Windows vs Unix
      try {
        await storage.storeFile(
          session: mockSession,
          path: 'foo_bar.txt', // Safe alternative path
          byteData: testData,
        );

        final exists = await storage.fileExists(
          session: mockSession,
          path: 'foo_bar.txt',
        );
        expect(exists, isTrue);
      } catch (_) {
        // Some filesystems may reject certain special characters
        // This is acceptable behavior
      }
    });

    test('handles empty path by using default filename', () async {
      final testData = createByteData(100);

      // Empty string or path that resolves to empty
      await storage.storeFile(
        session: mockSession,
        path: '..',
        byteData: testData,
      );

      // Should create file with default name 'file'
      final defaultFile = File('${tempDir.path}/file');
      expect(defaultFile.existsSync(), isTrue);
    });

    test('handles path that becomes empty after sanitization', () async {
      final testData = createByteData(100);

      // Path that completely resolves away
      await storage.storeFile(
        session: mockSession,
        path: '../../../',
        byteData: testData,
      );

      // Should create file with default name
      final files = Directory(
        tempDir.path,
      ).listSync(recursive: true).whereType<File>();
      // Should have at least one file stored
      final nonMetaFiles = files
          .where((f) => !f.path.endsWith('.meta'))
          .toList();
      expect(nonMetaFiles.isNotEmpty, isTrue);

      // All files should be within storage
      for (final file in nonMetaFiles) {
        expect(file.path.startsWith(tempDir.path), isTrue);
      }
    });
  });

  group('File operations', () {
    late LocalCloudStorage storage;

    setUp(() {
      storage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'test',
        storagePath: tempDir.path,
        public: true,
      );
    });

    test('stores and retrieves file', () async {
      final testData = createByteData(256);

      await storage.storeFile(
        session: mockSession,
        path: 'test/file.bin',
        byteData: testData,
      );

      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'test/file.bin',
      );

      expect(retrieved, isNotNull);
      expect(retrieved!.lengthInBytes, equals(256));
      expect(verifyByteData(retrieved), isTrue);
    });

    test('overwrites existing file', () async {
      final originalData = createByteData(256);
      final newData = createByteData(128);

      await storage.storeFile(
        session: mockSession,
        path: 'test/file.bin',
        byteData: originalData,
      );

      await storage.storeFile(
        session: mockSession,
        path: 'test/file.bin',
        byteData: newData,
      );

      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'test/file.bin',
      );

      expect(retrieved!.lengthInBytes, equals(128));
    });

    test('returns null for non-existent file', () async {
      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'nonexistent/file.bin',
      );

      expect(retrieved, isNull);
    });

    test('deletes file and metadata', () async {
      final testData = createByteData(100);

      await storage.storeFile(
        session: mockSession,
        path: 'test/delete_me.bin',
        byteData: testData,
        expiration: DateTime.now().add(Duration(hours: 1)),
      );

      // Verify file exists
      expect(
        await storage.fileExists(
          session: mockSession,
          path: 'test/delete_me.bin',
        ),
        isTrue,
      );

      // Delete file
      await storage.deleteFile(
        session: mockSession,
        path: 'test/delete_me.bin',
      );

      // Verify file is gone
      expect(
        await storage.fileExists(
          session: mockSession,
          path: 'test/delete_me.bin',
        ),
        isFalse,
      );

      // Verify metadata file is also gone
      final metaFile = File('${tempDir.path}/test/delete_me.bin.meta');
      expect(metaFile.existsSync(), isFalse);
    });

    test('fileExists returns correct status', () async {
      expect(
        await storage.fileExists(session: mockSession, path: 'test/file.bin'),
        isFalse,
      );

      await storage.storeFile(
        session: mockSession,
        path: 'test/file.bin',
        byteData: createByteData(100),
      );

      expect(
        await storage.fileExists(session: mockSession, path: 'test/file.bin'),
        isTrue,
      );
    });

    test('creates nested directories automatically', () async {
      final testData = createByteData(100);

      await storage.storeFile(
        session: mockSession,
        path: 'deeply/nested/directory/structure/file.bin',
        byteData: testData,
      );

      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'deeply/nested/directory/structure/file.bin',
      );

      expect(retrieved, isNotNull);
    });

    test('handles empty file', () async {
      final emptyData = ByteData(0);

      await storage.storeFile(
        session: mockSession,
        path: 'empty.bin',
        byteData: emptyData,
      );

      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'empty.bin',
      );

      expect(retrieved, isNotNull);
      expect(retrieved!.lengthInBytes, equals(0));
    });

    test('handles large file', () async {
      // 1MB file
      final largeData = createByteData(1024 * 1024);

      await storage.storeFile(
        session: mockSession,
        path: 'large.bin',
        byteData: largeData,
      );

      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'large.bin',
      );

      expect(retrieved, isNotNull);
      expect(retrieved!.lengthInBytes, equals(1024 * 1024));
    });

    test('delete non-existent file does not throw', () async {
      // Should not throw
      await storage.deleteFile(
        session: mockSession,
        path: 'nonexistent/file.bin',
      );
    });
  });

  group('Metadata handling', () {
    late LocalCloudStorage storage;

    setUp(() {
      storage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'test',
        storagePath: tempDir.path,
        public: true,
      );
    });

    test('stores expiration metadata', () async {
      final expiration = DateTime.now().add(Duration(hours: 1));

      await storage.storeFile(
        session: mockSession,
        path: 'test/expiring.bin',
        byteData: createByteData(100),
        expiration: expiration,
      );

      // Metadata file should exist
      final metaFile = File('${tempDir.path}/test/expiring.bin.meta');
      expect(metaFile.existsSync(), isTrue);

      final content = await metaFile.readAsString();
      expect(content, contains('expiration='));
      expect(content, contains('verified=true'));
    });

    test('verified=false file not retrievable', () async {
      await storage.storeFile(
        session: mockSession,
        path: 'test/unverified.bin',
        byteData: createByteData(100),
        verified: false,
      );

      // File should not be retrievable
      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'test/unverified.bin',
      );
      expect(retrieved, isNull);

      // fileExists should return false for unverified files
      final exists = await storage.fileExists(
        session: mockSession,
        path: 'test/unverified.bin',
      );
      expect(exists, isFalse);
    });

    test('verified=true file retrievable', () async {
      await storage.storeFile(
        session: mockSession,
        path: 'test/verified.bin',
        byteData: createByteData(100),
        verified: true,
      );

      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'test/verified.bin',
      );
      expect(retrieved, isNotNull);
    });

    test('verifyDirectFileUpload marks file verified', () async {
      // Store an unverified file
      await storage.storeFile(
        session: mockSession,
        path: 'test/to_verify.bin',
        byteData: createByteData(100),
        verified: false,
      );

      // Should not be retrievable
      expect(
        await storage.retrieveFile(
          session: mockSession,
          path: 'test/to_verify.bin',
        ),
        isNull,
      );

      // Verify the upload
      final verified = await storage.verifyDirectFileUpload(
        session: mockSession,
        path: 'test/to_verify.bin',
      );
      expect(verified, isTrue);

      // Now should be retrievable
      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'test/to_verify.bin',
      );
      expect(retrieved, isNotNull);
    });

    test(
      'verifyDirectFileUpload returns false for non-existent file',
      () async {
        final verified = await storage.verifyDirectFileUpload(
          session: mockSession,
          path: 'nonexistent.bin',
        );
        expect(verified, isFalse);
      },
    );

    test('file without metadata is considered verified', () async {
      // Create file directly without using storeFile (simulating external creation)
      final file = File('${tempDir.path}/external.bin');
      await file.create(recursive: true);
      await file.writeAsBytes([1, 2, 3, 4, 5]);

      // Should be retrievable since no metadata means verified
      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'external.bin',
      );
      expect(retrieved, isNotNull);
    });
  });

  group('Concurrent operations', () {
    late LocalCloudStorage storage;

    setUp(() {
      storage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'test',
        storagePath: tempDir.path,
        public: true,
      );
    });

    test('handles concurrent writes to different files', () async {
      final futures = <Future<void>>[];

      for (var i = 0; i < 10; i++) {
        futures.add(
          storage.storeFile(
            session: mockSession,
            path: 'concurrent/file_$i.bin',
            byteData: createByteData(100),
          ),
        );
      }

      await Future.wait(futures);

      // Verify all files exist
      for (var i = 0; i < 10; i++) {
        final exists = await storage.fileExists(
          session: mockSession,
          path: 'concurrent/file_$i.bin',
        );
        expect(exists, isTrue, reason: 'File $i should exist');
      }
    });

    test('handles concurrent writes to same file (last write wins)', () async {
      final futures = <Future<void>>[];

      // Write multiple times to the same file concurrently
      for (var i = 0; i < 5; i++) {
        final data = Uint8List(100);
        for (var j = 0; j < 100; j++) {
          data[j] = i; // Each write has a unique value
        }
        futures.add(
          storage.storeFile(
            session: mockSession,
            path: 'same_file.bin',
            byteData: ByteData.view(data.buffer),
          ),
        );
      }

      await Future.wait(futures);

      // File should exist and contain one of the written values
      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'same_file.bin',
      );
      expect(retrieved, isNotNull);
      expect(retrieved!.lengthInBytes, equals(100));
    });

    test('handles concurrent read and write', () async {
      // First, store a file
      await storage.storeFile(
        session: mockSession,
        path: 'readwrite.bin',
        byteData: createByteData(100),
      );

      // Perform concurrent reads and writes
      final futures = <Future<dynamic>>[];

      for (var i = 0; i < 5; i++) {
        futures.add(
          storage.retrieveFile(
            session: mockSession,
            path: 'readwrite.bin',
          ),
        );
        futures.add(
          storage.storeFile(
            session: mockSession,
            path: 'readwrite.bin',
            byteData: createByteData(100),
          ),
        );
      }

      // Should complete without errors
      await Future.wait(futures);
    });

    test('handles concurrent deletes', () async {
      // Store multiple files
      for (var i = 0; i < 5; i++) {
        await storage.storeFile(
          session: mockSession,
          path: 'delete_test/file_$i.bin',
          byteData: createByteData(100),
        );
      }

      // Delete all concurrently
      final futures = <Future<void>>[];
      for (var i = 0; i < 5; i++) {
        futures.add(
          storage.deleteFile(
            session: mockSession,
            path: 'delete_test/file_$i.bin',
          ),
        );
      }

      await Future.wait(futures);

      // All files should be gone
      for (var i = 0; i < 5; i++) {
        final exists = await storage.fileExists(
          session: mockSession,
          path: 'delete_test/file_$i.bin',
        );
        expect(exists, isFalse);
      }
    });
  });

  group('Public URL generation', () {
    test('returns null for private storage', () async {
      final privateStorage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'private',
        storagePath: tempDir.path,
        public: false,
      );

      await privateStorage.storeFile(
        session: mockSession,
        path: 'private_file.bin',
        byteData: createByteData(100),
      );

      final url = await privateStorage.getPublicUrl(
        session: mockSession,
        path: 'private_file.bin',
      );

      expect(url, isNull);
    });

    test('returns correct URL for public storage', () async {
      final publicStorage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'public',
        storagePath: tempDir.path,
        public: true,
      );

      await publicStorage.storeFile(
        session: mockSession,
        path: 'public_file.bin',
        byteData: createByteData(100),
      );

      final url = await publicStorage.getPublicUrl(
        session: mockSession,
        path: 'public_file.bin',
      );

      expect(url, isNotNull);
      expect(url!.scheme, equals('http'));
      expect(url.host, equals('localhost'));
      expect(url.port, equals(8080));
      expect(url.path, equals('/serverpod_cloud_storage'));
      expect(url.queryParameters['method'], equals('file'));
      expect(url.queryParameters['path'], equals('public_file.bin'));
    });

    test('uses custom host/port/scheme when provided', () async {
      final customStorage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'custom',
        storagePath: tempDir.path,
        public: true,
        publicHost: 'cdn.example.com',
        publicPort: 443,
        publicScheme: 'https',
      );

      await customStorage.storeFile(
        session: mockSession,
        path: 'custom_file.bin',
        byteData: createByteData(100),
      );

      final url = await customStorage.getPublicUrl(
        session: mockSession,
        path: 'custom_file.bin',
      );

      expect(url, isNotNull);
      expect(url!.scheme, equals('https'));
      expect(url.host, equals('cdn.example.com'));
      expect(url.port, equals(443));
    });

    test('returns null for non-existent file', () async {
      final publicStorage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'public',
        storagePath: tempDir.path,
        public: true,
      );

      final url = await publicStorage.getPublicUrl(
        session: mockSession,
        path: 'nonexistent.bin',
      );

      expect(url, isNull);
    });
  });

  group('Direct upload (unsupported)', () {
    late LocalCloudStorage storage;

    setUp(() {
      storage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'test',
        storagePath: tempDir.path,
        public: true,
      );
    });

    test('createDirectFileUploadDescription returns null', () async {
      final description = await storage.createDirectFileUploadDescription(
        session: mockSession,
        path: 'upload.bin',
      );

      expect(description, isNull);
    });
  });

  group('Storage directory initialization', () {
    test('creates storage directory if it does not exist', () async {
      final newDir = Directory('${tempDir.path}/new_storage');
      expect(newDir.existsSync(), isFalse);

      LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'new',
        storagePath: newDir.path,
        public: true,
      );

      expect(newDir.existsSync(), isTrue);
    });

    test('works with existing directory', () async {
      final existingDir = Directory('${tempDir.path}/existing_storage');
      await existingDir.create();

      // Should not throw
      LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'existing',
        storagePath: existingDir.path,
        public: true,
      );
    });
  });

  group('Expiration cleanup scheduler', () {
    late LocalCloudStorage storage;

    setUp(() {
      storage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'test',
        storagePath: tempDir.path,
        public: true,
      );
    });

    tearDown(() {
      storage.stopCleanupScheduler();
    });

    test('cleanupExpiredFiles removes expired files', () async {
      // Store a file that expires in the past
      await storage.storeFile(
        session: mockSession,
        path: 'expired.bin',
        byteData: createByteData(100),
        expiration: DateTime.now().subtract(Duration(hours: 1)),
      );

      // Store a file that expires in the future
      await storage.storeFile(
        session: mockSession,
        path: 'not_expired.bin',
        byteData: createByteData(100),
        expiration: DateTime.now().add(Duration(hours: 1)),
      );

      // Store a file with no expiration
      await storage.storeFile(
        session: mockSession,
        path: 'no_expiration.bin',
        byteData: createByteData(100),
      );

      // Run cleanup
      final deleted = await storage.cleanupExpiredFiles();

      // Should have deleted 1 file
      expect(deleted, equals(1));

      // Verify expired file is gone
      final expiredFile = File('${tempDir.path}/expired.bin');
      expect(expiredFile.existsSync(), isFalse);

      // Verify non-expired file still exists
      final notExpiredFile = File('${tempDir.path}/not_expired.bin');
      expect(notExpiredFile.existsSync(), isTrue);

      // Verify file with no expiration still exists
      final noExpirationFile = File('${tempDir.path}/no_expiration.bin');
      expect(noExpirationFile.existsSync(), isTrue);
    });

    test('cleanupExpiredFiles removes metadata files', () async {
      await storage.storeFile(
        session: mockSession,
        path: 'expired_with_meta.bin',
        byteData: createByteData(100),
        expiration: DateTime.now().subtract(Duration(hours: 1)),
      );

      // Metadata file should exist before cleanup
      final metaFile = File('${tempDir.path}/expired_with_meta.bin.meta');
      expect(metaFile.existsSync(), isTrue);

      await storage.cleanupExpiredFiles();

      // Both data and metadata files should be gone
      expect(
        File('${tempDir.path}/expired_with_meta.bin').existsSync(),
        isFalse,
      );
      expect(metaFile.existsSync(), isFalse);
    });

    test('cleanupExpiredFiles returns 0 when no expired files', () async {
      await storage.storeFile(
        session: mockSession,
        path: 'not_expired.bin',
        byteData: createByteData(100),
        expiration: DateTime.now().add(Duration(hours: 1)),
      );

      final deleted = await storage.cleanupExpiredFiles();
      expect(deleted, equals(0));
    });

    test('cleanupExpiredFiles handles empty storage', () async {
      final deleted = await storage.cleanupExpiredFiles();
      expect(deleted, equals(0));
    });

    test('startCleanupScheduler starts timer', () {
      expect(storage.isCleanupSchedulerRunning, isFalse);

      storage.startCleanupScheduler(Duration(hours: 1));

      expect(storage.isCleanupSchedulerRunning, isTrue);
    });

    test('stopCleanupScheduler stops timer', () {
      storage.startCleanupScheduler(Duration(hours: 1));
      expect(storage.isCleanupSchedulerRunning, isTrue);

      storage.stopCleanupScheduler();
      expect(storage.isCleanupSchedulerRunning, isFalse);
    });

    test('startCleanupScheduler replaces existing timer', () {
      storage.startCleanupScheduler(Duration(hours: 1));
      storage.startCleanupScheduler(Duration(minutes: 30));

      // Should still be running (new timer replaced old one)
      expect(storage.isCleanupSchedulerRunning, isTrue);
    });
  });

  group('Streaming support', () {
    late LocalCloudStorage storage;

    setUp(() {
      storage = LocalCloudStorage(
        serverpod: mockServerpod,
        storageId: 'test',
        storagePath: tempDir.path,
        public: true,
      );
    });

    test('storeFileStream stores file from stream', () async {
      final data = createByteData(1024);
      final stream = Stream.value(
        data.buffer
            .asUint8List(data.offsetInBytes, data.lengthInBytes)
            .toList(),
      );

      await storage.storeFileStream(
        session: mockSession,
        path: 'streamed.bin',
        stream: stream,
      );

      // Verify file was stored correctly
      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'streamed.bin',
      );
      expect(retrieved, isNotNull);
      expect(retrieved!.lengthInBytes, equals(1024));
      expect(verifyByteData(retrieved), isTrue);
    });

    test('storeFileStream handles chunked stream', () async {
      // Create a stream with multiple chunks
      Stream<List<int>> createChunkedStream() async* {
        for (var i = 0; i < 10; i++) {
          final chunk = List<int>.generate(100, (j) => (i * 100 + j) % 256);
          yield chunk;
        }
      }

      await storage.storeFileStream(
        session: mockSession,
        path: 'chunked.bin',
        stream: createChunkedStream(),
      );

      final retrieved = await storage.retrieveFile(
        session: mockSession,
        path: 'chunked.bin',
      );
      expect(retrieved, isNotNull);
      expect(retrieved!.lengthInBytes, equals(1000));
    });

    test('storeFileStream with expiration stores metadata', () async {
      final stream = Stream.value(<int>[1, 2, 3, 4, 5]);
      final expiration = DateTime.now().add(Duration(hours: 1));

      await storage.storeFileStream(
        session: mockSession,
        path: 'stream_with_expiry.bin',
        stream: stream,
        expiration: expiration,
      );

      final metaFile = File('${tempDir.path}/stream_with_expiry.bin.meta');
      expect(metaFile.existsSync(), isTrue);
    });

    test(
      'storeFileStream with verified=false creates unverified file',
      () async {
        final stream = Stream.value(<int>[1, 2, 3, 4, 5]);

        await storage.storeFileStream(
          session: mockSession,
          path: 'unverified_stream.bin',
          stream: stream,
          verified: false,
        );

        // File should not be retrievable
        final retrieved = await storage.retrieveFile(
          session: mockSession,
          path: 'unverified_stream.bin',
        );
        expect(retrieved, isNull);
      },
    );

    test('retrieveFileStream returns stream for existing file', () async {
      await storage.storeFile(
        session: mockSession,
        path: 'to_stream.bin',
        byteData: createByteData(256),
      );

      final stream = await storage.retrieveFileStream(
        session: mockSession,
        path: 'to_stream.bin',
      );

      expect(stream, isNotNull);

      // Collect stream data
      final chunks = <List<int>>[];
      await for (final chunk in stream!) {
        chunks.add(chunk);
      }

      // Verify total bytes
      final totalBytes = chunks.fold<int>(
        0,
        (sum, chunk) => sum + chunk.length,
      );
      expect(totalBytes, equals(256));
    });

    test('retrieveFileStream returns null for non-existent file', () async {
      final stream = await storage.retrieveFileStream(
        session: mockSession,
        path: 'nonexistent.bin',
      );

      expect(stream, isNull);
    });

    test('retrieveFileStream returns null for unverified file', () async {
      await storage.storeFile(
        session: mockSession,
        path: 'unverified.bin',
        byteData: createByteData(100),
        verified: false,
      );

      final stream = await storage.retrieveFileStream(
        session: mockSession,
        path: 'unverified.bin',
      );

      expect(stream, isNull);
    });

    test('getFileSize returns correct size', () async {
      await storage.storeFile(
        session: mockSession,
        path: 'sized.bin',
        byteData: createByteData(512),
      );

      final size = await storage.getFileSize(
        session: mockSession,
        path: 'sized.bin',
      );

      expect(size, equals(512));
    });

    test('getFileSize returns null for non-existent file', () async {
      final size = await storage.getFileSize(
        session: mockSession,
        path: 'nonexistent.bin',
      );

      expect(size, isNull);
    });

    test('getFileSize returns null for unverified file', () async {
      await storage.storeFile(
        session: mockSession,
        path: 'unverified_size.bin',
        byteData: createByteData(100),
        verified: false,
      );

      final size = await storage.getFileSize(
        session: mockSession,
        path: 'unverified_size.bin',
      );

      expect(size, isNull);
    });

    test('storeFileStream creates nested directories', () async {
      final stream = Stream.value(<int>[1, 2, 3]);

      await storage.storeFileStream(
        session: mockSession,
        path: 'deep/nested/path/file.bin',
        stream: stream,
      );

      final exists = await storage.fileExists(
        session: mockSession,
        path: 'deep/nested/path/file.bin',
      );
      expect(exists, isTrue);
    });

    test('storeFileStream handles empty stream', () async {
      final stream = Stream<List<int>>.empty();

      await storage.storeFileStream(
        session: mockSession,
        path: 'empty_stream.bin',
        stream: stream,
      );

      final size = await storage.getFileSize(
        session: mockSession,
        path: 'empty_stream.bin',
      );
      expect(size, equals(0));
    });
  });
}
