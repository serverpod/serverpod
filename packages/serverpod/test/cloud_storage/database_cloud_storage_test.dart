import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

/// A testable [DatabaseCloudStorage] that overrides DB-dependent methods
/// so the option-handling logic can be tested in isolation.
class TestableDatabaseCloudStorage extends DatabaseCloudStorage {
  final Map<String, ByteData> _files = {};

  TestableDatabaseCloudStorage() : super('test-storage');

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    return _files.containsKey(path);
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    _files[path] = byteData;
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return '{"url": "http://test/$path", "type": "binary"}';
  }
}

/// A minimal fake [Session] that satisfies the type system.
///
/// The testable storage overrides all methods that access `session.db`,
/// so no real database connection is needed.
class _FakeSession implements Session {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not implemented in _FakeSession',
  );
}

void main() {
  late TestableDatabaseCloudStorage storage;
  late Session session;

  setUp(() {
    storage = TestableDatabaseCloudStorage();
    session = _FakeSession();
  });

  group('Given a DatabaseCloudStorage with storeFileWithOptions', () {
    test(
      'when preventOverwrite is false '
      'then the file is stored',
      () async {
        final data = ByteData.view(
          Uint8List.fromList('content'.codeUnits).buffer,
        );

        await storage.storeFileWithOptions(
          session: session,
          path: 'test/file.txt',
          byteData: data,
          options: const CloudStorageOptions(preventOverwrite: false),
        );

        final exists = await storage.fileExists(
          session: session,
          path: 'test/file.txt',
        );
        expect(exists, isTrue);
      },
    );

    test(
      'when preventOverwrite is true and file does not exist '
      'then the file is stored',
      () async {
        final data = ByteData.view(
          Uint8List.fromList('content'.codeUnits).buffer,
        );

        await storage.storeFileWithOptions(
          session: session,
          path: 'test/new-file.txt',
          byteData: data,
          options: const CloudStorageOptions(preventOverwrite: true),
        );

        final exists = await storage.fileExists(
          session: session,
          path: 'test/new-file.txt',
        );
        expect(exists, isTrue);
      },
    );

    test(
      'when preventOverwrite is true and file already exists '
      'then it throws CloudStorageException',
      () async {
        final data = ByteData.view(
          Uint8List.fromList('original'.codeUnits).buffer,
        );

        await storage.storeFile(
          session: session,
          path: 'test/existing.txt',
          byteData: data,
        );

        final duplicateData = ByteData.view(
          Uint8List.fromList('duplicate'.codeUnits).buffer,
        );

        expect(
          () => storage.storeFileWithOptions(
            session: session,
            path: 'test/existing.txt',
            byteData: duplicateData,
            options: const CloudStorageOptions(preventOverwrite: true),
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('preventOverwrite'),
            ),
          ),
        );
      },
    );
  });

  group(
    'Given a DatabaseCloudStorage with createDirectFileUploadDescriptionWithOptions',
    () {
      test(
        'when contentLength is within maxFileSize '
        'then it returns a description',
        () async {
          final description = await storage
              .createDirectFileUploadDescriptionWithOptions(
                session: session,
                path: 'test/file.txt',
                maxFileSize: 10 * 1024 * 1024,
                options: const CloudStorageOptions(contentLength: 5000),
              );

          expect(description, isNotNull);
        },
      );

      test(
        'when contentLength exceeds maxFileSize '
        'then it throws CloudStorageException',
        () {
          expect(
            () => storage.createDirectFileUploadDescriptionWithOptions(
              session: session,
              path: 'test/file.txt',
              maxFileSize: 1024,
              options: const CloudStorageOptions(contentLength: 2048),
            ),
            throwsA(
              isA<CloudStorageException>().having(
                (e) => e.message,
                'message',
                contains('exceeds maximum file size'),
              ),
            ),
          );
        },
      );

      test(
        'when contentLength equals maxFileSize '
        'then it returns a description',
        () async {
          final description = await storage
              .createDirectFileUploadDescriptionWithOptions(
                session: session,
                path: 'test/file.txt',
                maxFileSize: 1024,
                options: const CloudStorageOptions(contentLength: 1024),
              );

          expect(description, isNotNull);
        },
      );

      test(
        'when contentLength is null '
        'then it returns a description',
        () async {
          final description = await storage
              .createDirectFileUploadDescriptionWithOptions(
                session: session,
                path: 'test/file.txt',
                options: const CloudStorageOptions(),
              );

          expect(description, isNotNull);
        },
      );
    },
  );
}
